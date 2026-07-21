#!/usr/bin/env bash
#
# Create the MCP EKS cluster from mcp-cluster.yaml.
#
# The config is a template: eksctl refuses every command line flag when -f is
# set, but it reads the config from stdin, so the deployment specific ids are
# substituted here and piped in. All of them come from the VPC stack outputs,
# so nothing has to be copied by hand.
#
#   ./create-cluster.sh mcp-vpc mcp
#   ./create-cluster.sh mcp-vpc mcp --dry-run
#
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="${SCRIPT_DIR}/mcp-cluster.yaml"

usage() {
    cat >&2 <<EOF
Usage: $(basename "$0") <vpc-stack-name> <cluster-name> [eksctl args...]

  vpc-stack-name  CloudFormation stack that built the network, e.g. mcp-vpc.
                  Its VpcId, PublicSubnetIds and PrivateSubnetIds outputs are
                  read directly.
  cluster-name    Name for the EKS cluster. Must match the ClusterName the VPC
                  stack was deployed with, since that is what tags the subnets.

Any further arguments are passed through to 'eksctl create cluster', so
--dry-run renders and validates the config without creating anything.

Options:
  --skip-tag-check  Proceed even when the subnets are not tagged for this
                    cluster. Only useful for a VPC not built by mcp-vpc.
EOF
    exit 64
}

SKIP_TAG_CHECK=0
ARGS=()
for arg in "$@"; do
    case "$arg" in
        --skip-tag-check) SKIP_TAG_CHECK=1 ;;
        -h|--help)        usage ;;
        *)                ARGS+=("$arg") ;;
    esac
done
set -- "${ARGS[@]:-}"

[ $# -ge 2 ] || usage

VPC_STACK="$1"
export CLUSTER_NAME="$2"
shift 2

for cmd in aws eksctl envsubst; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "error: '$cmd' is not installed or not on PATH" >&2
        exit 1
    }
done

[ -f "$TEMPLATE" ] || { echo "error: template not found: $TEMPLATE" >&2; exit 1; }

# --- Read the network ids out of the VPC stack -----------------------------

out() {
    aws cloudformation describe-stacks --stack-name "$VPC_STACK" \
        --query "Stacks[0].Outputs[?OutputKey=='$1'].OutputValue" \
        --output text 2>/dev/null
}

aws cloudformation describe-stacks --stack-name "$VPC_STACK" >/dev/null 2>&1 || {
    echo "error: stack '$VPC_STACK' not found in the current account/region." >&2
    echo "       Check with: aws sts get-caller-identity && aws configure get region" >&2
    exit 1
}

export VPC_ID
VPC_ID="$(out VpcId)"
IFS=, read -r PUBLIC_SUBNET_1  PUBLIC_SUBNET_2  PUBLIC_SUBNET_3  <<< "$(out PublicSubnetIds)"
IFS=, read -r PRIVATE_SUBNET_1 PRIVATE_SUBNET_2 PRIVATE_SUBNET_3 <<< "$(out PrivateSubnetIds)"
export PUBLIC_SUBNET_1 PUBLIC_SUBNET_2 PUBLIC_SUBNET_3
export PRIVATE_SUBNET_1 PRIVATE_SUBNET_2 PRIVATE_SUBNET_3

# envsubst turns an unset variable into an empty string rather than failing, so
# an incomplete stack would otherwise surface as a confusing eksctl validation
# error much later on.
for var in CLUSTER_NAME VPC_ID \
           PUBLIC_SUBNET_1 PUBLIC_SUBNET_2 PUBLIC_SUBNET_3 \
           PRIVATE_SUBNET_1 PRIVATE_SUBNET_2 PRIVATE_SUBNET_3; do
    [ -n "${!var:-}" ] || {
        echo "error: \$$var is empty - '$VPC_STACK' did not export what was expected." >&2
        echo "       Inspect with: aws cloudformation describe-stacks --stack-name $VPC_STACK --query 'Stacks[0].Outputs'" >&2
        exit 1
    }
done

# --- Refuse the mismatch that fails silently 20 minutes later --------------

if [ "$SKIP_TAG_CHECK" -eq 0 ]; then
    tagged="$(aws ec2 describe-tags \
        --filters "Name=key,Values=kubernetes.io/cluster/${CLUSTER_NAME}" \
                  "Name=resource-type,Values=subnet" \
        --query 'length(Tags)' --output text 2>/dev/null || echo 0)"

    if [ "$tagged" -lt 6 ]; then
        cat >&2 <<EOF
error: only ${tagged} of 6 subnets carry kubernetes.io/cluster/${CLUSTER_NAME}.

  The cluster would build and the nodes would join, but every Service of type
  LoadBalancer would stay <pending> forever with "could not find any suitable
  subnets for creating the ELB" - the cloud controller skips subnets tagged for
  a different cluster.

  '${CLUSTER_NAME}' must match the ClusterName '${VPC_STACK}' was deployed with.
  Realign the tags without disturbing anything already running:

    aws cloudformation deploy \\
        --template-file ${SCRIPT_DIR}/mcp-vpc.cloudformation.json \\
        --stack-name ${VPC_STACK} \\
        --parameter-overrides ClusterName=${CLUSTER_NAME}

  Pass --skip-tag-check to proceed anyway.
EOF
        exit 1
    fi
fi

# --- Go ---------------------------------------------------------------------

echo "Cluster : ${CLUSTER_NAME}"
echo "VPC     : ${VPC_ID} (from stack ${VPC_STACK})"
echo "Public  : ${PUBLIC_SUBNET_1} ${PUBLIC_SUBNET_2} ${PUBLIC_SUBNET_3}"
echo "Private : ${PRIVATE_SUBNET_1} ${PRIVATE_SUBNET_2} ${PRIVATE_SUBNET_3}"
echo

envsubst '$CLUSTER_NAME $VPC_ID
          $PUBLIC_SUBNET_1 $PUBLIC_SUBNET_2 $PUBLIC_SUBNET_3
          $PRIVATE_SUBNET_1 $PRIVATE_SUBNET_2 $PRIVATE_SUBNET_3' \
    < "$TEMPLATE" | eksctl create cluster -f - "$@"

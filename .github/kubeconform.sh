#!/bin/bash
set -euo pipefail

CHANGED_DIRS="$(git diff --find-renames --name-only remotes/origin/master -- charts)"
# protect against a pipeline failure here
CHART_DIRS=""
if [[ -n $CHANGED_DIRS ]]; then
    echo ${CHANGED_DIRS}
    CHART_DIRS="$(echo "${CHANGED_DIRS}" | grep '[cC]hart.yaml' | sed -e 's/[Cc]hart.yaml//g')"
fi
KUBECONFORM_VERSION="v0.6.6"
SCHEMA_LOCATION="https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master"

# install kubeval
curl --silent --show-error --fail --location --output /tmp/kubeconform.tar.gz https://github.com/yannh/kubeconform/releases/download/"${KUBECONFORM_VERSION}"/kubeconform-linux-amd64.tar.gz
tar -xf /tmp/kubeconform.tar.gz kubeconform

# validate charts
for CHART_DIR in ${CHART_DIRS}; do
    helm template --kube-version "${KUBERNETES_VERSION#v}" "${CHART_DIR}" | ./kubeconform -strict -kubernetes-version "${KUBERNETES_VERSION#v}" -schema-location "${SCHEMA_LOCATION}"
done


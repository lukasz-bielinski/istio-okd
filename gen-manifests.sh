#!/usr/bin/env bash
GRAFANA_IMAGE="grafana/grafana:6.0.2"
DOCKER_REPO_UPSTREAM="docker.io"
DOCKER_REPO_LOCAL=${1:-docker.io}
HELM="helm2"
HELM_ANNOTATIONS_STRING="helm.sh"
ISTIO_INIT_MANIFESTS="objects-install/manifests/helm-generated-files-istio-init"
ISTIO_MANIFESTS="objects-install/manifests/helm-generated-files-istio"
FIXED_CHARTS="objects-install/manifests/fixed-charts"
ISTIO_DIR="istio-1.1.17"

# clean
rm -rf istio-1.1.17
rm -rf "${ISTIO_INIT_MANIFESTS:?}" || true
rm -rf "${ISTIO_MANIFESTS:?}" || true
# extract
tar -xf istio-1.1.17-linux.tar.gz
# mkdir/clean directories
mkdir -p "${ISTIO_INIT_MANIFESTS:?}" || true
mkdir -p "${ISTIO_MANIFESTS:?}" || true

# patch role and rolebinding
cp $FIXED_CHARTS/rolebindings.yaml $ISTIO_DIR/install/kubernetes/helm/istio/charts/gateways/templates/rolebindings.yaml || true
cp $FIXED_CHARTS/role.yaml $ISTIO_DIR/install/kubernetes/helm/istio/charts/gateways/templates/role.yaml || true

# run helm
$HELM template istio-1.1.17/install/kubernetes/helm/istio-init --name istio-init --namespace istio-system --output-dir "${ISTIO_INIT_MANIFESTS:?}"

# istio
$HELM template istio-1.1.17/install/kubernetes/helm/istio --name istio --namespace istio-system \
  --set global.controlPlaneSecurityEnabled=true --set sidecarInjectorWebhook.rewriteAppHTTPProbe=true \
  --set kiali.enabled=true --set grafana.enabled=true --set servicegraph.enabled=true --set tracing.enabled=true \
  --set pilot.traceSampling=10 --output-dir "${ISTIO_MANIFESTS:?}"

# patch istio/istio-1.1.17/helm-generated-files-istio/istio/templates/sidecar-injector-configmap.yaml
sed -i '/NET_ADMIN/a \ \ \ \ \ \ \ \ \ \ privileged\: true' $ISTIO_MANIFESTS/istio/templates/sidecar-injector-configmap.yaml

# change registry
grep -rl $GRAFANA_IMAGE $ISTIO_MANIFESTS | xargs sed -i 's@'"$GRAFANA_IMAGE"'@'"$DOCKER_REPO_LOCAL\/$GRAFANA_IMAGE"'@'

grep -rl $DOCKER_REPO_UPSTREAM $ISTIO_INIT_MANIFESTS | xargs sed -i 's@'"$DOCKER_REPO_UPSTREAM"'@'"$DOCKER_REPO_LOCAL"'@'
grep -rl $DOCKER_REPO_UPSTREAM $ISTIO_MANIFESTS | xargs sed -i 's@'"$DOCKER_REPO_UPSTREAM"'@'"$DOCKER_REPO_LOCAL"'@'

# delete annotations about helm
grep -rl $HELM_ANNOTATIONS_STRING $ISTIO_INIT_MANIFESTS | xargs sed -i '/'"$HELM_ANNOTATIONS_STRING"'/d'
grep -rl $HELM_ANNOTATIONS_STRING $ISTIO_MANIFESTS | xargs sed -i '/'"$HELM_ANNOTATIONS_STRING"'/d'

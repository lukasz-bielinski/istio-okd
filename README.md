# Istio 1.1.17 on OKD 3.11

# cluster install

    ansible-playbook -i /root/okd-local-install/inventory.cfg playbooks/prerequisites.yml

    ansible-playbook -i /root/okd-local-install/inventory.cfg playbooks/deploy_cluster.yml

# SYSCTL

    ansible-playbook -i /root/okd-local-install/inventory.cfg objects-install/master-config/sysctl.yaml

# configuration flags

<https://istio.io/v1.1/docs/reference/config/installation-options/>

# istio-init

    helm2 template istio-1.1.17/install/kubernetes/helm/istio-init --name istio-init --namespace istio-system --output-dir helm-generated-files-istio-init

# istio

    helm2 template istio-1.1.17/install/kubernetes/helm/istio --name istio --namespace istio-system --set global.controlPlaneSecurityEnabled=true --set sidecarInjectorWebhook.rewriteAppHTTPProbe=true --set kiali.enabled=true --set grafana.enabled=true --set servicegraph.enabled=true --set tracing.enabled=true --set pilot.traceSampling=10 --output-dir helm-generated-files-istio

# securityContext

### FIXES

    privileged: true in
    istio/istio-1.1.17/helm-generated-files-istio/istio/templates/sidecar-injector-configmap.yaml


## role
    istio/charts/gateways/templates/role.yaml
## rolebinding
    istio/charts/gateways/templates/rolebindings.yaml

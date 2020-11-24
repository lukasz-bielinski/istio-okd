# cluster install

# local Install

    ansible-playbook -i /root/okd-local-install/inventory.cfg        playbooks/prerequisites.yml  

    ansible-playbook -i /root/okd-local-install/inventory.cfg        playbooks/deploy_cluster.yml  

# istio-init

    helm2 template istio-1.1.17/install/kubernetes/helm/istio-init  --name istio-init --namespace istio-system --output-dir helm-generated-files-istio-init      

# istio

    helm2 template istio-1.1.17/install/kubernetes/helm/istio  --name istio --namespace istio-system --set global.controlPlaneSecurityEnabled=true --set sidecarInjectorWebhook.rewriteAppHTTPProbe=true --set kiali.enabled=true --output-dir helm-generated-files-istio
# securityContext


### FIXES

    istio/istio-1.1.17/helm-generated-files-istio/istio/templates/sidecar-injector-configmap.yaml

add `privileged: true` into securityContext in initContainers

## role

## rolebinding

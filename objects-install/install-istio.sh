#!/usr/bin/env bash

cd manifests || true

kubectl apply -f istio-system-ns.yaml
kubectl apply -R -f okd/

kubectl apply -f kiali-password-secret.yaml
kubectl apply -R -f helm-generated-files-istio-init
kubectl apply -R -f helm-generated-files-istio

    cp -p master-config.yaml master-config.yaml.prepatch
    oc ex config patch master-config.yaml.prepatch -p "$(cat master-config.patch)" > master-config.yaml
    master-restart api
    master-restart controllers

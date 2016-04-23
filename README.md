# CoreOS Deploy

#### Cloud init

Online check the cloud-config.yaml: https://coreos.com/validate

#### Setting etcd discovery key


    curl -sL https://discovery.etcd.io/new?size=3


### Automate New etcd discovery key

The install/cloud-config.yaml file will run the following command:

    ETCD_DISCOVERY_URL=$(curl -sL http://coreos-deploy.s3-website-eu-west-1.amazonaws.com/discovery_etcd.json | \
            jq -r .url)

Read more about with the https://github.com/JulienBalestra/coreos_publisher repository.
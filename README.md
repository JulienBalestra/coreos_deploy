# CoreOS Deploy

#### Cloud init

Online check the cloud-config.yaml: https://coreos.com/validate

#### Setting etcd discovery key


    curl -sL https://discovery.etcd.io/new?size=3


### Automate New etcd discovery key

The install/cloud-config.yaml file will run the following command:

    ETCD_DISCOVERY_URL=$(curl -sL https://raw.githubusercontent.com/JulienBalestra/coreos_deploy/master/.etcd_discovery)

So for each run you need a fresh etcd discovery url wrote the `.etcd_discovery` file
CoreOS provide a public etcd cluster to bootstrap our own etcd clusters: `https://discovery.etcd.io/new?size=3`

Run the script `new_etcd_discovery.sh` with 3 as $1 for the etcd cluster size

This script will:

* get a new etcd discovery url
* write it to local file `.etcd_discovery`
* commit and push the file
* poll the etcd discovery url until all needed members are registered


A sample output:


    ./new_etcd_discovery.sh 3
    Go to working directory...
    -> Current directory is /home/stage/IdeaProjects/coreos_deploy
    [master a08fc96] New etcd discovery key of size=3
     1 file changed, 1 insertion(+), 1 deletion(-)
    Counting objects: 3, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (3/3), done.
    Writing objects: 100% (3/3), 338 bytes | 0 bytes/s, done.
    Total 3 (delta 1), reused 0 (delta 0)
    To https://github.com/julienbalestra/coreos_deploy.git
       01642a9..a08fc96  master -> master

    https://discovery.etcd.io/8416e10e2d690e16ed15baafd4853fe4
    16:09:00
    ---
    0/3 1

    0/3 63

    {"action":"create","node":{"key":"/_etcd/registry/8416e10e2d690e16ed15baafd4853fe4/78f14fa1556bfe8b","value":"bc48421a66f8473e8ef27b734aae3caa=http://192.168.2.100:2380","modifiedIndex":1071388611,"createdIndex":1071388611}}
    1/3 89

    {"action":"create","node":{"key":"/_etcd/registry/8416e10e2d690e16ed15baafd4853fe4/ece096e5b4a7fb01","value":"d4a964f6f6394ced97cb2e7263232fa4=http://192.168.2.101:2380","modifiedIndex":1071388665,"createdIndex":1071388665}}
    2/3 92

    {"action":"create","node":{"key":"/_etcd/registry/8416e10e2d690e16ed15baafd4853fe4/1cb8e33e5aba37d","value":"31fc249caed44f95a7aedcabf5d13251=http://192.168.2.102:2380","modifiedIndex":1071388757,"createdIndex":1071388757}}

    {
      "action": "get",
      "node": {
        "key": "/_etcd/registry/8416e10e2d690e16ed15baafd4853fe4",
        "dir": true,
        "nodes": [
          {
            "key": "/_etcd/registry/8416e10e2d690e16ed15baafd4853fe4/ece096e5b4a7fb01",
            "value": "d4a964f6f6394ced97cb2e7263232fa4=http://192.168.2.101:2380",
            "modifiedIndex": 1071388665,
            "createdIndex": 1071388665
          },
          {
            "key": "/_etcd/registry/8416e10e2d690e16ed15baafd4853fe4/1cb8e33e5aba37d",
            "value": "31fc249caed44f95a7aedcabf5d13251=http://192.168.2.102:2380",
            "modifiedIndex": 1071388757,
            "createdIndex": 1071388757
          },
          {
            "key": "/_etcd/registry/8416e10e2d690e16ed15baafd4853fe4/78f14fa1556bfe8b",
            "value": "bc48421a66f8473e8ef27b734aae3caa=http://192.168.2.100:2380",
            "modifiedIndex": 1071388611,
            "createdIndex": 1071388611
          }
        ],
        "modifiedIndex": 1071387336,
        "createdIndex": 1071387336
      }
    }

    Seconds needed: 99


The script indicates it took 99 seconds to generate an etcd cluster

This example was generated with over OpenStack Cloud with the following heat template:
https://github.com/JulienBalestra/openstack_deploy/tree/master/heat/coreos_ramdisk
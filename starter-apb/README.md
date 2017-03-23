This example uses ansible-container and AnsibleApp.



#### Prerequisites
```
yum install python-virtualenv gcc make libffi-devel openssl-devel

virtualenv venv
source venv/bin/activate
pip install -U pip setuptools
pip install ansible-container

# This step is optional
pip install ansible==2.2.0
```

#### Using ansible-container to create this project
##### Create OpenShift project, extract dockercfg and save the password to the registry
```
oc new-projet starter-apb
oc extract secret/$(oc get secret | grep default-dockercfg | awk '{print $1}') --to=/tmp --confirm
PASSWORD=$(python -c "import json;print json.loads(open('/tmp/.dockercfg').read())['docker-registry.default.svc:5000']['password']")
docker login -u serviceaccount -p ${PASSWORD} docker-registry-default.router.default.svc.cluster.local
```

##### Create, build and push to OpenShift registry

See [container.yml documentation](http://docs.ansible.com/ansible-container/container_yml/index.html) and [ansible-container cli reference](http://docs.ansible.com/ansible-container/reference/index.html)
for more detailed information.

```
mkdir starter-apb
cd starter-apb
ansible-container init

# modify
vim ansible/container.yml

# modify main.yml - this is the playbook that will install or configure
# the application
vim ansible/main.yml

ansible-container build
ansible-container push --push-to openshift
```

#### AnsibleApp Section
##### Adding AnsibleApp
See [AnsibleApp Developer documentation](https://github.com/fusor/ansibleapp/blob/master/docs/developers.md)
```
mkdir -p ansibleapp/actions
cp ansible/shipit-openshift.yml ansibleapp/actions/provision.yaml

# create deprovision
vim ansibleapp/actions/deprovision.yaml

# create Dockerfile
vim Dockerfile
```

##### Create AnsibleApp image and provision to OpenShift
```
docker build -t starter-apb-ansibleapp .
docker run -e "OPENSHIFT_TARGET=openshift.virtomation.com:8443" -e "OPENSHIFT_USER=jcallen" -e "OPENSHIFT_PASS=" starter-apb-ansibleapp provision
```

#### Links

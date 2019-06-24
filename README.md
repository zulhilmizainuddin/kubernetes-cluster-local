# kubernetes-cluster-local
Spin up and provision multi node Kubernetes cluster locally using Vagrant, Ubuntu, Ansible and Kubeadm

By default, a Kubernetes cluster with a single master and two worker nodes will be spinned up and provisioned

## Prerequisite
Install the following components into local machine
- Vagrant
- Ansible

## Getting Started
Install roles from Ansible Galaxy
```
$ ansible-galaxy install -r requirements.yml
```

Export Ansible environment variables for caching in your terminal
```
$ export ANSIBLE_CACHE_PLUGIN=yaml
$ export ANSIBLE_CACHE_PLUGIN_CONNECTION=.cache
```

Spin up and provision multi node Kubernetes cluster
```
$ vagrant up
```

SSH into master node after Kubernetes cluster provisioning is completed
```
$ vagrant ssh master
```

Deploy services using Kubectl
```
$ kubectl run nginx --image=nginx --port=80 --replicas=2
$ kubectl expose deploy nginx --type=NodePort
```

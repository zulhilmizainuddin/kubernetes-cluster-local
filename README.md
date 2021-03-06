# kubernetes-cluster-local [![Build Status](https://travis-ci.org/zulhilmizainuddin/kubernetes-cluster-local.svg?branch=master)](https://travis-ci.org/zulhilmizainuddin/kubernetes-cluster-local)
Automatically provision multi node Kubernetes cluster locally using Vagrant, Ubuntu, Ansible and Kubeadm

## Features
1) A Kubernetes cluster with a single `master` and two `worker` nodes will be provisioned
2) `Weave Net` will be deployed as the pod network
3) `kubectl` will be installed and configured in the `master` node
4) `helm` will be installed and configured in the `master` node
5) `tiller` will be deployed and initialized in the `master` node
6) `BIND9` `DNS` server will be installed and configured in the `master` node. All nodes will be using it as the `nameserver`
7) `NFS` server will be configured in the `master` node
8) [`NFS` client](https://hub.helm.sh/charts/stable/nfs-client-provisioner) with `StorageClass` of `nfs-client` will be deployed in the `master` node for dynamic provisioning of `PersistentVolume`s
9) [`Nginx` ingress](https://hub.helm.sh/charts/stable/nginx-ingress) will be deployed as the ingress controller in the `master` node
10) [`Metallb`](https://hub.helm.sh/charts/stable/metallb) load balancer will be deployed with `controller` in the `master` and `speaker` in all nodes

## Prerequisite
Install the following components into local machine
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/intro/getting-started/install.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Provision cluster
Automatically provision multi node Kubernetes cluster from scratch using base `Vagrant` box (*Use this when you want the latest `Docker`, `Kubelet`, `Kubeadm`, `Kubectl` and `Helm`  to be installed*)
```
$ ./cluster.sh start
```

or

Automatically provision multi node Kubernetes cluster using a prebuilt `Vagrant` box with `Docker`, `Kubelet`, `Kubeadm`, `Kubectl` and `Helm` preinstalled (*Use this if you want subsequent cluster provisioning to be faster after a cluster teardown*)
```
$ ./cluster.sh start prebuilt
```

Prebuilt `Vagrant` box from https://app.vagrantup.com/zulhilmizainuddin/boxes/kubernetes-ubuntu18.04 will be used

Prebuilt `Vagrant` box was built using https://github.com/zulhilmizainuddin/kubernetes-vagrant-box

## SSH into master node
SSH into master node after Kubernetes cluster provisioning has completed
```
$ ./cluster.sh ssh master
```

## Deployment example

### kubectl example
#### Nginx deployment

Deploy nginx
```
$ kubectl run nginx --image=nginx --port=80 --replicas=2
```

Expose nginx deployment with `ClusterIP` service
```
$ kubectl expose deploy nginx --port=80
```

Deploy nginx ingress resource
```
$ cat <<EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: nginx-ingress
  namespace: default
spec:
  rules:
    - host: nginx.k8s.zone
      http:
        paths:
          - backend:
              serviceName: nginx
              servicePort: 80
            path: /
EOF
```

Get load balancer ip address
```
$ kubectl get svc -n kube-system | grep LoadBalancer | tr -s ' ' | cut -d' ' -f4
192.168.33.240
```

Set `nginx.k8s.zone` resolution in host machine `/etc/hosts` file
```
$ echo "192.168.33.240    nginx.k8s.zone" | sudo tee -a /etc/hosts
```

Access nginx at `http://nginx.k8s.zone` on host machine

### helm example
#### Prometheus deployment

Deploy prometheus
```
$ helm upgrade \
  --install \
  --set server.ingress.enabled=true \
  --set server.ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
  --set server.ingress.hosts={"prometheus.k8s.zone"} \
  --set server.persistentVolume.storageClass=nfs-client \
  --set alertmanager.persistentVolume.storageClass=nfs-client \
  --set nodeExporter.tolerations[0].key=node-role.kubernetes.io/master \
  --set nodeExporter.tolerations[0].operator=Exists \
  --set nodeExporter.tolerations[0].effect=NoSchedule \
  prometheus \
  stable/prometheus
```

Get load balancer ip address
```
$ kubectl get svc -n kube-system | grep LoadBalancer | tr -s ' ' | cut -d' ' -f4
192.168.33.240
```

Set `prometheus.k8s.zone` resolution in host machine `/etc/hosts` file
```
$ echo "192.168.33.240    prometheus.k8s.zone" | sudo tee -a /etc/hosts
```

Access prometheus at `http://prometheus.k8s.zone` on host machine

## Delete cluster
Delete cluster when it is no longer needed
```
$ ./cluster.sh delete
```

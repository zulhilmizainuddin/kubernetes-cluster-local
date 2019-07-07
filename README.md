# kubernetes-cluster-local
Automatically provision multi node Kubernetes cluster locally using Vagrant, Ubuntu, Ansible and Kubeadm

## Prerequisite
Install the following components into local machine
- [Vagrant](https://www.vagrantup.com/intro/getting-started/install.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Note
1) A Kubernetes cluster with a single `master` and two `worker` nodes will be provisioned
2) `Weave Net` will be deployed as the pod network
3) `kubectl` will be installed and configured in the `master` node
4) `helm` will be installed and configured in the `master` node
5) `tiller` will be deployed and initialized in the `master` node
6) `NFS` server will be configured in the `master` node
7) `NFS` client with `StorageClass` of `nfs-client` will be deployed for dynamic provisioning of `PersistentVolume`s
8) `nginx-ingress` will be deployed as the ingress controller

## Provision cluster
Install roles from Ansible Galaxy
```
$ ansible-galaxy install -r requirements.yml
```

Export Ansible environment variables for caching in your terminal
```
$ export ANSIBLE_CACHE_PLUGIN=yaml
$ export ANSIBLE_CACHE_PLUGIN_CONNECTION=.cache
```

Automatically provision multi node Kubernetes cluster
```
$ vagrant up
```

## SSH into master node
SSH into master node after Kubernetes cluster provisioning has completed
```
$ vagrant ssh master
```

## Deployment example

### kubectl example
#### Nginx deployment

Deploy nginx
```
$ kubectl run nginx --image=nginx --port=80 --replicas=2
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
    - host: nginx.k8s.local
      http:
        paths:
          - backend:
              serviceName: nginx
              servicePort: 80
            path: /
EOF
```

Set hostname resolution in /etc/hosts
```
$ echo "192.168.33.10    nginx.k8s.local" | sudo tee -a /etc/hosts
```

Access nginx at `http://nginx.k8s.local:<node-port>`

### helm example
#### Prometheus deployment

Deploy prometheus
```
$ helm install \
  --set server.ingress.enabled=true \
  --set server.ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
  --set server.ingress.hosts={"prometheus.k8s.local"} \
  --set server.persistentVolume.storageClass=nfs-client \
  stable/prometheus
```

Set hostname resolution in /etc/hosts
```
$ echo "192.168.33.10    prometheus.k8s.local" | sudo tee -a /etc/hosts
```

Access prometheus at `http://prometheus.k8s.local:<node-port>`
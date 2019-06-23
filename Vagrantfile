# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-18.04"

  config.vm.define "master" do |master|
    master.vm.provider "virtualbox" do |vb|
      vb.cpus = "2"
      vb.memory = "2048"
    end

    master.vm.hostname = "master"

    MASTER_PRIVATE_NETWORK_IP = "192.168.33.10"
    master.vm.network "private_network", ip: MASTER_PRIVATE_NETWORK_IP

    master.vm.provision "ansible" do |ansible|
      ansible.playbook = "provisioning/master-playbook.yml"

      ansible.extra_vars = {
        private_network_ip: MASTER_PRIVATE_NETWORK_IP,
        private_network_iface: "eth1"
      }
    end
  end

  NUMBER_OF_NODES = 2
  (1..NUMBER_OF_NODES).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.provider "virtualbox" do |vb|
        vb.cpus = "1"
        vb.memory = "1024"
      end

      node.vm.hostname = "node#{i}"

      node_private_network_ip = "192.168.33.2#{i}"
      node.vm.network "private_network", ip: node_private_network_ip

      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "provisioning/nodes-playbook.yml"

        ansible.extra_vars = {
          private_network_ip: node_private_network_ip
      } 
      end
    end
  end

end

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
  config.vm.network "public_network", bridge: "wlp35s0"

  config.vm.define "master" do |master|
    master.vm.provider "virtualbox" do |vb|
      vb.cpus = "2"
      vb.memory = "2048"
    end

    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.33.10"

    master.vm.provision "ansible" do |ansible|
      ansible.become = true
      ansible.playbook = "provisioning/master-playbook.yml"
    end
  end

  (1..2).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.provider "virtualbox" do |vb|
        vb.cpus = "1"
        vb.memory = "1024"
      end

      node.vm.hostname = "node#{i}"
      node.vm.network "private_network", ip: "192.168.33.2#{i}"
    end
  end

end

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  cluster = {
    :master => {
      :box => "bento/ubuntu-18.04",
      :cpu => 2,
      :memory => 2048,
      :ansible => {
        :playbook => "provisioning/master-playbook.yml",
        :limit => ["master"]
      },
      :nodes => [
        {
          :id => "master",
          :hostname => "master.k8s.zone",
          :ip => "192.168.33.10"
        }
      ]
    },
    :worker => {
      :box => "bento/ubuntu-18.04",
      :cpu => 1,
      :memory => 1024,
      :ansible => {
        :playbook => "provisioning/nodes-playbook.yml",
        :limit => ["node1", "node2"]
      },
      :nodes => [
        {
          :id => "node1",
          :hostname => "node1.k8s.zone",
          :ip => "192.168.33.21"
        },
        {
          :id => "node2",
          :hostname => "node2.k8s.zone",
          :ip => "192.168.33.22"
        }
      ]
    },
    :dnsserver => {
      :hostname => "master.k8s.zone",
      :ip => "192.168.33.10",
      :domain => "k8s.zone"
    }
  }

  def provision_node(config, cluster, role)
    setup = cluster[role]

    setup[:nodes].each_with_index do |node, index|
      config.vm.define node[:id] do |machine|
        
        machine.vm.box = setup[:box]

        machine.vm.provider "virtualbox" do |vb|
          vb.cpus = setup[:cpu]
          vb.memory = setup[:memory]
        end

        machine.vm.hostname = node[:hostname]

        machine.vm.network "private_network", ip: node[:ip]

        if index == setup[:nodes].length - 1
          machine.vm.provision "ansible" do |ansible|
            ansible.playbook = setup[:ansible][:playbook]
            ansible.galaxy_role_file = "requirements.yml"
            ansible.limit = setup[:ansible][:limit]
  
            ansible.extra_vars = {
              private_network_ip: node[:ip],
              k8s_cluster_nodes: cluster[:master][:nodes] + cluster[:worker][:nodes],
              k8s_cluster_dns_server: cluster[:dnsserver]
            }
          end
        end

      end
    end
  end

  provision_node(config, cluster, :master)
  provision_node(config, cluster, :worker)

end
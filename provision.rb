module Provision
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
              k8s_cluster_nodes: cluster[:master][:nodes] + cluster[:worker][:nodes],
              k8s_cluster_dns_server: cluster[:dnsserver],
              k8s_cluster_nfs_server: cluster[:nfsserver],
              k8s_cluster_load_balancer: cluster[:loadbalancer]
            }
          end
        end

      end
    end
  end
end
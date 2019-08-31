CLUSTER = {
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
  },
  :nfsserver => {
    :ip => "192.168.33.10"
  },
  :loadbalancer => {
    :iprange => {
      :from => "192.168.33.240",
      :to => "192.168.33.250"
    }
  }
}
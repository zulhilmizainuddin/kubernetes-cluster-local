# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative "config"
require_relative "provision"

include Provision

Vagrant.configure("2") do |config|

  provision_node(config, CLUSTER, :master)
  provision_node(config, CLUSTER, :worker)

end
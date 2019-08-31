# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative "config"
require_relative "provision"

include Provision

Vagrant.configure("2") do |config|

  box_type = ENV['BOX_TYPE'] == 'prebuilt' ? :prebuilt : :scratch

  provision_node(config, CLUSTER, :master, box_type)
  provision_node(config, CLUSTER, :worker, box_type)

end
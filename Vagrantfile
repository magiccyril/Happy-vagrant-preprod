# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #####################
  ## The Vagrant Box ##
  #####################

  config.vm.box = "hashicorp/precise32"
  config.vm.network "private_network", type: "dhcp"

  #######################
  ## Virtualbox tweaks ##
  #######################

  config.vm.provider "virtualbox" do |vb|
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  ###############
  ## Provision ##
  ###############
  config.vm.provision :shell, :inline => "
      sh /vagrant/vagrant-scripts/provision-web-php.sh;
  "

end


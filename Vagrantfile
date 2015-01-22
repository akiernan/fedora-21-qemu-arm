# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "opscode-fedora-21"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_fedora-21_chef-provisionerless.box"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1536
  end

  config.vm.provision "shell", path: "privileged.sh"

  config.ssh.forward_agent = true

end

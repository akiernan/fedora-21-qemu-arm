# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "opscode-fedora-21"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1536
    vb.customize ["modifyvm", :id, "--audio", "dsound", "--audiocontroller", "hda"]
  end


  config.vm.provision "shell", path: "privileged.sh"
  config.vm.provision "shell", privileged: false, path: "unprivileged.sh"

end

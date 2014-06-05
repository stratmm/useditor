# berkshelf 2.0.14

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "useditor"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.
  [2345].each do |p|
    config.vm.network :forwarded_port, guest: p, host: p
  end

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "192.168.56.50"

  # Share an additional folder to the guest VM
  config.vm.synced_folder ".", "/vagrant", :type => "nfs"

  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    # vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  # Bootstrap to Docker
  config.vm.provision :shell, path: "script/vagrant/bootstrap", :privileged => true

  # Build docker containers
  config.vm.provision :shell, path: "script/vagrant/docker_build", :privileged => true

  # Start containers
  config.vm.provision :shell, path: "script/vagrant/docker_start", :privileged => true

  # Seed the App
  config.vm.provision :shell, path: "script/vagrant/app", :privileged => true

end

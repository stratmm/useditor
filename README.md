# Useditor

[![Code Climate](https://codeclimate.com/github/stratmm/useditor.png)](https://codeclimate.com/github/stratmm/useditor)[![Coverage Status](https://coveralls.io/repos/stratmm/useditor/badge.png)](https://coveralls.io/r/stratmm/useditor)[![Dependency Status](https://gemnasium.com/stratmm/useditor.svg)](https://gemnasium.com/stratmm/useditor)


This gem is the submission for a technical test.  It provides a command line utility that demonstrates a small number of image handing concepts.  The setter of the test will be fully aware of the criteria.

# Vagrant / Docker based Development Environment
The development environment for this project is based on two key components:

The project is hosted in a Virtual Box Vagrant VM.  The Vagrantfile provisions a vanilla Ubuntu 14.04 trusty host and installs Docker.

Docker containers are used to run any supporting services and the development project itself.  This project was taken from one of my own larger systems and therefore contains all the plumbing to host service containers which would typincally be systems like ElasticSearch, MYSQL and so on.  None of these are required here, therefore the only continer is use is the Useditor gem itself.

## Setting up the development environment
Ensure you have Vangrant and Virtual box installed with recent versions.

Clone thos repo into a folder

From that folder execute
```
vagrant up
```
On a MAC you might be asked for your password to connect the NFS share needed by the VM.

The Vagrant provision will do the following:
* create the Vagrant VM
* install docker
* build the Useditor docker container.

This process may take some time depending on your computer and internet connection; go make a coffee.
### Accessing the VM
To use the VM you should
```
vagrant ssh
sudo bash
cd /vagrant
```

All work on the development environment is done as root.

### Developing
The project folder will be shared in the Vagrant machine as /vagrant.

### Rebuilding the devlopment container
Changes to anything but source files (for instance: ```bundle update```) will not be persisted when the development container terminates.  This is one of the key advantages of docker, in that your development environment always starts in a known state.  In these circumstances you must rebuild the development container to make the changes permanent.

When in the VM, in the ```/vagrant``` folder and in a sudo shell
```
script/vagrant/docker_build
```

### Running the development container
```
script/vagrant/docker_web
```
This will start the development container and present a command line with the full development environment in place.

Running ```rspec``` will execute the test suite.

The project folder on your host is also shared with the container, therefore source changes made on your host will immediatly be reflected in the container.


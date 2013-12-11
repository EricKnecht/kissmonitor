# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

#Controls where kissmonitor is mounted inside the VM
KISSM_MOUNT = "/opt/kissmonitor" 

#We add this to the system's cron on-boot
CRON_FILE =  "*/5 * * * * root cd #{KISSM_MOUNT}; #{KISSM_MOUNT}/bin/kissm monitor --config #{KISSM_MOUNT}/config.sample.yaml"

#I <3 vagrant
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  ubuntu_lts_box = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
  centos_box = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"

  config.vm.define :ubuntu do |ubuntu|
    ubuntu.vm.box = "ubuntu"
    ubuntu.vm.box_url = ubuntu_lts_box
    ubuntu.vm.synced_folder ".", KISSM_MOUNT
    ubuntu.vm.synced_folder ".", "/vagrant", :disabled => true #disable default share
    ubuntu.vm.hostname = 'kissmonitor-demo-ubuntu'

    setup_kissm ubuntu
  end

   config.vm.define :centos do |centos|
    centos.vm.box = "centos"
    centos.vm.box_url = centos_box
    centos.vm.synced_folder ".", KISSM_MOUNT
    centos.vm.synced_folder ".", "/vagrant", :disabled => true #disable default share
    centos.vm.hostname = 'kissmonitor-demo-centos'
    centos.vm.provision :shell, :inline => "sudo yum -q -y install ruby-devel"
    setup_kissm centos
  end

  def setup_kissm box
    box.vm.provision :shell, :inline => "sudo gem install bundler"
    box.vm.provision :shell, :inline => "cd #{KISSM_MOUNT} && bundle install --quiet"
    box.vm.provision :shell, :inline => "echo '#{CRON_FILE}' > /etc/cron.d/kissmonitor"
  end

end

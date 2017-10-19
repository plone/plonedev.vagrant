# -*- mode: ruby -*-
# vi: set ft=ruby :

UI_URL = "https://launchpad.net/plone/5.0/5.1rc1/+download/Plone-5.1rc1-UnifiedInstaller.tgz"
UI_OPTIONS = "standalone --password=admin"

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/xenial32"
#    config.ssh.insert_key = false

    config.vm.network :forwarded_port, guest: 8080, host: 8080

    config.vm.provider "virtualbox" do |vb|
        #vb.customize ["modifyvm", :id, "--memory", "1024"]
        vb.customize ["modifyvm", :id, "--name", "plonedev" ]
    end

    config.vm.provision "shell", inline: "apt-get update"
    config.vm.provision "shell", inline: "apt-get install -y build-essential python-dev libjpeg-dev libxml2-dev libxslt-dev git libz-dev libssl-dev wv poppler-utils putty-tools"

    # Create a Putty-style keyfile for Windows users
    config.vm.provision :shell do |shell|
        shell.path = "manifests/host_setup.sh"
        shell.args = RUBY_PLATFORM
    end

    # install Plone
        config.vm.provision :shell do |shell|
        shell.path = "manifests/install_plone.sh"
        shell.args = UI_URL + " '" + UI_OPTIONS + "'"
    end
end

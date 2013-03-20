# -*- mode: ruby -*-
# vi: set ft=ruby :

UI_URL = "https://launchpad.net/plone/4.3/4.3rc1/+download/Plone-4.3rc1-UnifiedInstaller-r2.tgz"
UI_OPTIONS = "standalone --password=admin"

Vagrant::Config.run do |config|
    config.vm.box = "precise32"
    config.vm.box_url = "http://files.vagrantup.com/precise32.box"

    config.vm.forward_port 8080, 8080

    # Run apt-get update as a separate step in order to avoid
    # package install errors
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file  = "aptgetupdate.pp"
    end

    # ensure we have the packages we need
    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file  = "plone.pp"
    end

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

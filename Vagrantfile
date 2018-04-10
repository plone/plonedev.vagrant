# -*- mode: ruby -*-
# vi: set ft=ruby :

PACKAGES = "build-essential python-dev libjpeg-dev libxml2-dev libxslt-dev git libz-dev libssl-dev wv poppler-utils"
UI_URL = "https://launchpad.net/plone/5.1/5.1.1/+download/Plone-5.1.1-UnifiedInstaller.tgz"
UI_OPTIONS = "standalone --password=admin"


# We use this provisioner to write the vbox_host.cfg ansible inventory file,
# which makes it easier to use ansible-playbook directly.
module AnsibleInventory
    class Plugin < Vagrant.plugin("2")
        name "write_vbox_cfg"

        config(:write_vbox_cfg, :provisioner) do
            Config
        end

        provisioner(:write_vbox_cfg) do
            Provisioner
        end
    end

    class Provisioner < Vagrant.plugin("2", :provisioner)
        def provision
          # get the output ov vagrant ssh-config <machine>
          require 'open3'
          stdin, stdout, stderr, wait_thr = Open3.popen3('vagrant', 'ssh-config')
          output = stdout.gets(nil)
          stdout.close
          stderr.gets(nil)
          stderr.close
          exit_code = wait_thr.value.exitstatus
          if exit_code == 0
            # parse out the key variables
            /HostName (?<host>.+)/ =~ output
            /Port (?<port>.+)/ =~ output
            /User (?<user>.+)/ =~ output
            /IdentityFile (?<keyfile>.+)/ =~ output
            # write an ansible inventory file
            contents = "XXXX ansible_ssh_port=#{port} ansible_ssh_host=#{host} ansible_ssh_user=#{user} ansible_ssh_private_key_file=#{keyfile} ansible_ssh_extra_args='-o StrictHostKeyChecking=no'\n"
            File.open("vbox_host.cfg", "w") do |aFile|
              aFile.puts(contents)
            end
          end
          result = exit_code
        end
    end
end


Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/xenial32"
#    config.ssh.insert_key = false

    config.vm.network :forwarded_port, guest: 8080, host: 8080

    config.vm.provider "virtualbox" do |vb|
        #vb.customize ["modifyvm", :id, "--memory", "1024"]
        vb.customize ["modifyvm", :id, "--name", "plonedev" ]
    end

    myhost.vm.provision "write_vbox_cfg"

    config.vm.provision "shell", inline: "apt-get update"
    config.vm.provision "shell", inline: "apt-get install -y " + PACKAGES

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

# -*- mode: ruby -*-
# vi: set ft=ruby :

PACKAGES = "build-essential python-dev libjpeg-dev libxml2-dev libxslt-dev git libz-dev libssl-dev wv poppler-utils dos2unix"
UI_URL = "https://launchpad.net/plone/5.1/5.1.4/+download/Plone-5.1.4-UnifiedInstaller.tgz"
UI_OPTIONS = "standalone --password=admin"

# We use this provisioner to write a DOS cmd file with our ssh config as variables.
module SSHConfig
    class Plugin < Vagrant.plugin("2")
        name "write_ssh_config_cmd"

        provisioner(:write_ssh_config_cmd) do
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
            # convert to dos drivespec
            keyfile = keyfile.sub(/^.cygdrive.(.)/, '\1:')
            # write an ansible inventory file
            contents = "set ssh_port=#{port}\nset ssh_host=#{host}\nset ssh_user=#{user}\nset ssh_private_key_file='#{keyfile}'\nset ssh_extra_args='-o StrictHostKeyChecking=no'\n"
            File.open("ssh_config.cmd", "w") do |aFile|
              aFile.puts(contents)
            end
          end
          result = exit_code
        end
    end
end


Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/xenial32"

    config.vm.network :forwarded_port, guest: 8080, host: 8080

    config.vm.provider "virtualbox" do |vb|
        #vb.customize ["modifyvm", :id, "--memory", "1024"]
        vb.customize ["modifyvm", :id, "--name", "plonedev" ]
    end

    if RUBY_PLATFORM.include? 'mingw' then
      config.vm.provision "write_ssh_config_cmd"
    end

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

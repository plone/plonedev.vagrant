PloneDev.Vagrant
================

PloneDev.Vagrant is a kit for setting up an easy to use development environment for Plone in a hosted virtual machine.

The kit uses the VirtualBox for the virtual machine and the Vagrant box setup system.
It should run on any host machine for which Vagrant is available; that includes Windows Vista+, OS X and Linux.
Both VirtualBox and Vagrant are open-source.

The PloneDev.Vagrant kit is meant to be easy to setup and use.
Plone's key development files are set up to be accessible and editable with host-based editors.
Host commands are provided to run Plone and buildout.
So little or no knowledge of the VirtualBox guest environment (which happens to be Ubuntu Linux) should be required.

Installation
------------

1. Install VirtualBox: https://www.virtualbox.org

2. Install Vagrant: http://www.vagrantup.com

3. If you are using Windows, install the Putty ssh kit: http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html. Install all the binaries, or at least putty.exe and plink.exe.

4. Download and unpack PloneDev-Vagrant https://github.com/plone/plonedev.vagrant/archive/master.zip.

5. Open a command prompt; change directory into the plonedev.vagrant-master directory. Run "vagrant up".

6. Go for lunch or a long coffee break. "vagrant up" is going to download a virtual box kit (unless you already happen to have a match installed), download Plone, install Plone, and set up some convenience scripts. On Windows, it will also generate an ssh key pair that's usable with Putty.

7. Look to see if the install ran well. The last thing you should see in the command window is a success message from the Plone Unified Installer. The virtual machine will be running at this point.

While running "vagrant up", feel free to ignore messages like "stdin: is not a tty" and "warning: Could not retrieve fact fqdn". They have no significance in this context.

Troubleshooting
~~~~~~~~~~~~~~~

  "Vagrant has detected that you have a version of VirtualBox installed
  that is not supported. Please install one of the supported versions
  listed below to use Vagrant: 4.0, 4.1, 4.2"

You may get this on older versions of Vagrant, upgrade to 1.2.2-1 https://github.com/mitchellh/vagrant/issues/1856

You should consider to download Vagrant from http://www.vagrantup.com/downloads.html, this will get you the latest version.

Commands key
~~~~~~~~~~~~

There are two versions of each command example in the instructions that follow. The version beginning with `c:\...>` is for Windows users. The version beginning with `$` is for OS X, Linux, BSD and Unix users. All commands are executed from the directory containing your Vagrantfile

Using the Vagrant-installed VirtualBox
--------------------------------------

You may now start and stop the virtual machine by issuing command in the same directory:

Windows::

    c:\...> vagrant suspend

OS X, Linux::

    $ vagrant suspend


stops the virtual machine, saving an image of its state so that you may later restart with:

Windows::

    c:\...> vagrant resume

OS X, Linux::

    $ vagrant resume

Run "vagrant" with no command line arguments to see what else you can do.

Finally, you may remove the VirtualBox (deleting its image) with the command:

Windows::

    c:\...> vagrant destroy

OS X, Linux::

    $ vagrant destroy

Running Plone and buildout
--------------------------

To run buildout, just issue the command "buildout" (buildout.sh on a Unix-workalike host). This will run buildout; add command line arguments as desired:

Windows::

    c:\...> buildout -c develop.cfg

OS X, Linux::

    $ ./buildout.sh -c develop.cfg

To start Plone in the foreground (so its messages run to the command window), use the command:

Windows::

    c:\...> plonectl fg

OS X, Linux::

    $ ./plonectl.sh fg

Plone will be connected to port 8080 on the host machine, so that you should be able to crank up a web browser, point it at http://localhost:8080 and see Zope/Plone.

Plone is installed with an administrative user with id "admin" and password "admin".

Stop foreground Plone by using the site-setup maintenance stop button or by just pressing ctrl-c.

If you use ctrl-c, you've got a little cleanup to do. Plone will still be running on the virtual box. Kill it with the command:

Windows::

    c:\...> kill_plone

OS X, Linux::

    $ ./kill_plone.sh

You may also use start|stop|status|run arguments with plonectl.

Editing Plone configuration and source files
--------------------------------------------

After running "vagrant up", you should have a plone subdirectory. In it, you'll find your buildout configuration files and a "src" directory. These are the matching items from a normal Plone installation. You may add development packages to the src directory and edit all the files.

All of this is happening in a directory that is shared with the guest operating system, and the .cfg files and src directory are linked back to the working copy of Plone on the guest machine.

Using the VirtualBox directly
-----------------------------

How you get a command prompt on your "guest" machine will depend on your host operating system. On Unix workalikes, use the command::

    $ vagrant ssh

If your host OS is Windows, use::

    c:\...> putty_ssh

The "putty_ssh" command runs the Putty SSH program using command line parameters that connect to the virtual machine at port 2222 and use a special ssh key created for putty. That key, by the way, is created and stored in a way that is not password-protected, so it should not be regarded as adequately secured for any sensitive purpose.

For Windows users, we also have a convenience wrapper around pscp, the putty version of secure copy. To copy from the host to the guest::

    c:\...> putty_scp myfile.cfg vagrant@localhost:.

Or, the guest to the host::

    c:\...> putty_scp -r vagrant@localhost:Plone/zinstance/var .

The "vagrant@localhost:" specifies the vagrant user on the guest machine.

Running mr.bob
--------------

plonedev.vagrant's trick for making the src files editable from the host poses some problems when you try to run mr.bob. Normally, to run mr.bob to create a new package, you'd do the following::

    c:\...> putty_ssh (or "vagrant ssh" on a Linux/BSD/OSX machine)
    vagrant@...: cd Plone/zinstance/src
    vagrant@...: ../bin/mrbob -O my.newpackage bobtemplates:plone_addon

However, "../bin/mrbob" won't work in this context because the src directory is actually in another location (symbolically linked back into the buildout).

So, plonedev.vagrant sets up a shell alias "mrbob" that loads mrbob from ~/Plone/zinstance/bin/mrbob. So, instead of "../bin/mrbob", just use "mrbob"::

    vagrant@...: mrbob -O my.newpackage bobtemplates:plone_addon

What doesn't work
-----------------

Using "plonectl debug" from the host side isn't going to work. However, you may use your ssh command to get a guest OS prompt and run it there. You'll just need to know a little about how to operate at a Linux "bash" command prompt.

The same is true for running ZopeSkel to generate a package skeleton, or doing anything else that requires command-line interaction.

A different version of Plone or Linux?
--------------------------------------

Want to install a different version of Plone? Just edit Vagrantfile to specify a different Unified Installer URL. Do that before running "vagrant up" for the first time. You may do the same thing to specify a different VirtualBox.

What's under the hood
---------------------

VirtualBox provides the virtual machine facilities. Vagrant makes setting it up, including port forwarding and shared folders, convenient. Vagrant also provides a wrapper around the Puppet and shell provisioning system.

The guest operating system is the most recent Ubuntu LTS (14.04, Trusty Tahr), 32-bit (so that it will run on a 32- or 64-bit host).

After setting up the operating system, Vagrant's provisioning system is used to load the required system packages, download the Plone Unified Installer, run the install, and set up the convenience scripts and share directory.

Problems or suggestions?
------------------------

File a ticket at https://github.com/plone/plonedev.vagrant/issues.

Steve McMahon, steve@dcn.org

License
-------

Code included with this kit is licensed under the MIT Licence, http://opensource.org/licenses/MIT. Documentation is CC Attribution Unported, http://creativecommons.org/licenses/by/3.0/.


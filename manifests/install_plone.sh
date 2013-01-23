#!/bin/sh

PLONE_MAJOR=4.3
PLONE_MINOR=4.3b1

UI_NAME=Plone-${PLONE_MINOR}-UnifiedInstaller
PLONE_TARBALL=${UI_NAME}.tgz
UI_URL=https://launchpad.net/plone/${PLONE_MAJOR}/${PLONE_MINOR}/+download/${PLONE_TARBALL}

AS_VAGRANT="sudo -u vagrant"

if [ ! -f $PLONE_TARBALL ]; then
    echo Downloading Plone Unified Installer
    $AS_VAGRANT wget -q $UI_URL
    if [ $? -gt 0 ]; then
        # remove partial download
        rm $PLONE_TARBALL
        echo Download of Plone Unified Installer unsuccessful.
        echo Plone install failed
        exit 1
    fi
fi

if [ ! -d $UI_NAME ]; then
    $AS_VAGRANT tar xf $PLONE_TARBALL
    if [ $? -gt 0 ]; then
        # remove partial download
        rm $PLONE_TARBALL
        rm -r $UI_NAME
        echo Unpack of Plone Unified Installer unsuccessful.
        echo Plone install failed
        exit 1
    fi
fi

if [ ! -d Plone ]; then
    cd $UI_NAME
    echo Running Plone Unified Installer
    $AS_VAGRANT ./install.sh standalone --password=admin --target=/home/vagrant/Plone
    if [ $? -gt 0 ]; then
        # remove partial install
        rm -r Plone
        echo Plone install failed
        exit 1
    fi
fi

if [ ! -d /vagrant/plone ]; then
    echo Moving commonly edited source files into shared directory
    echo and linking them back to Plone instance.
    $AS_VAGRANT mkdir /vagrant/plone
fi

for fn in src buildout.cfg base.cfg
do
    if [ ! -f /vagrant/plone/$fn ]; then
        echo $fn
        mv Plone/zinstance/$fn /vagrant/plone
        $AS_VAGRANT ln -s /vagrant/plone/$fn Plone/zinstance
    fi
done

for script in /vagrant/manifests/*.sh
do
    if [ ! -f `basename $script` ]; then
        $AS_VAGRANT cp $script .
        chmod 755 *.sh
    fi
done
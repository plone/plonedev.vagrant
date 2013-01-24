#!/bin/sh

PLONE_MAJOR=4.3
PLONE_MINOR=4.3b2

UI_OPTIONS="standalone --password=admin"

UI_NAME=Plone-${PLONE_MINOR}-UnifiedInstaller
PLONE_TARBALL=${UI_NAME}.tgz
UI_URL=https://launchpad.net/plone/${PLONE_MAJOR}/${PLONE_MINOR}/+download/${PLONE_TARBALL}

AS_VAGRANT="sudo -u vagrant"
SHARED_DIR="/vagrant"
SHARED_FILES="src buildout.cfg base.cfg develop.cfg"
VHOME="/home/vagrant"

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
    $AS_VAGRANT ./install.sh ${UI_OPTIONS} --target=${VHOME}/Plone
    if [ $? -gt 0 ]; then
        # remove partial install
        rm -r Plone
        echo Plone install failed
        exit 1
    fi
    cd ${VHOME}

    # put .cfg and src into the shared directory,
    # and link back to them.
    if [ ! -d ${SHARED_DIR}/plone ]; then
        echo Moving commonly edited source files into shared directory
        echo and linking them back to Plone instance.
        $AS_VAGRANT mkdir ${SHARED_DIR}/plone
        for fn in $SHARED_FILES
            do
                if [ ! -e ${SHARED_DIR}/plone/$fn ]; then
                    echo $fn
                    mv Plone/zinstance/$fn ${SHARED_DIR}/plone
                    $AS_VAGRANT ln -s ${SHARED_DIR}/plone/$fn Plone/zinstance
                fi
            done
    fi
fi

for script in ${SHARED_DIR}/manifests/guest_scripts/*
do
    if [ ! -f `basename $script` ]; then
        $AS_VAGRANT cp $script .
        chmod 755 *.sh
    fi
done

for script in ${SHARED_DIR}/manifests/host_scripts/*
do
    if [ ! -f `basename $script` ]; then
        $AS_VAGRANT cp $script ${SHARED_DIR}/plone
        chmod 755 *.sh
    fi
done
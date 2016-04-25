#!/bin/sh

# usage: ./install_plone.sh UI_URL UI_OPTIONS

UI_URL=$1
UI_OPTIONS=$2

AS_VAGRANT="sudo -u vagrant -H"
SHARED_DIR="/vagrant"
SHARED_FILES="src buildout.cfg base.cfg develop.cfg"
VHOME="/home/vagrant"
UI_GLOB="Plone-*-UnifiedInstaller*"

if [ ! -f ${UI_GLOB}*.tgz ]; then
    echo Downloading Plone Unified Installer from $UI_URL
    $AS_VAGRANT wget -q $UI_URL
    if [ $? -gt 0 ]; then
        # remove partial download
        rm ${UI_GLOB}*.tgz
        echo Download of Plone Unified Installer unsuccessful.
        echo Plone install failed
        exit 1
    fi
fi

if [ ! -d $UI_GLOB ]; then
    $AS_VAGRANT tar xf ${UI_GLOB}*.tgz
    if [ $? -gt 0 ]; then
        # remove partial download
        rm ${UI_GLOB}
        echo Unpack of Plone Unified Installer unsuccessful.
        echo Plone install failed
        exit 1
    fi
fi

if [ ! -d Plone ]; then
    cd ${UI_GLOB}
    echo Running Plone Unified Installer
    $AS_VAGRANT ./install.sh ${UI_OPTIONS} --target=${VHOME}/Plone
    if [ $? -gt 0 ]; then
        # remove partial install
        rm -r Plone
        echo Plone install failed
        exit 1
    fi
    cd ~vagrant/Plone/zinstance
    echo Building developer components
    sudo -u vagrant bin/buildout -c develop.cfg 2> /dev/null
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
# code above will skip .* files
if [ ! -f .bash_aliases ]; then
    $AS_VAGRANT cp ${SHARED_DIR}/manifests/guest_scripts/.bash_aliases .
fi

#!/bin/sh

# usage: ./install_plone.sh

AS_VAGRANT="sudo -u vagrant"
SHARED_DIR="/vagrant"
INSTALL_TARGET="buildout.coredev"
VHOME="/home/vagrant"
COREDEV_D="/home/vagrant/${INSTALL_TARGET}"
COREDEV_URL="https://github.com/plone/${INSTALL_TARGET}.git"
MY_PYTHON="Python-2.7"
PYTHON_VB="/home/vagrant/$MY_PYTHON"

if [ ! `which virtualenv` ]; then
    echo "Installing virtualenv..."
    pip install virtualenv
    if [ ! `which virtualenv` ]; then
        echo "Failed to install virtualenv."
        exit 1
    fi
fi

cd $VHOME
if [ ! -d $MY_PYTHON ]; then
    echo "Creating a Python virtualenv..."
    $AS_VAGRANT virtualenv -q $PYTHON_VB
    if [ ! -x $PYTHON_VB ]; then
        echo "Failed to create virtualenv for Python"
        exit 1
    fi
fi

if [ ! -d $INSTALL_TARGET ]; then
    echo "Getting a clone of ${INSTALL_TARGET} from github"
    $AS_VAGRANT git clone $COREDEV_URL
    if [ ! -d ${INSTALL_TARGET} ]; then
        echo "Failed to checkout buildout.coredev"
        exit 1
    fi
    cd $COREDEV_D
    if [ ! -f bootstrap.py ]; then
        echo "bootstrap.py missing. This is a bad checkout."
        exit 1
    fi
    echo "Bootstrapping buildout..."
    $AS_VAGRANT ${PYTHON_VB}/bin/python bootstrap.py --distribute 2> /dev/null
    if [ ! -x bin/buildout ]; then
        echo "bin/buildout missing. bootstrap failed."
        exit 1
    fi
fi

# put .cfg and src into the shared directory,
# and link back to them.
if [ ! -d ${SHARED_DIR}/${INSTALL_TARGET} ]; then
    echo Moving commonly edited source files into shared directory
    echo and linking them back to coredev instance.
    echo ${SHARED_DIR}/${INSTALL_TARGET}
    $AS_VAGRANT mkdir ${SHARED_DIR}/${INSTALL_TARGET}
fi

for fn in ${COREDEV_D}/*.cfg; do
    bn=`basename $fn`
    if [ ! -f ${SHARED_DIR}/${INSTALL_TARGET}/$bn ]; then
        mv ${COREDEV_D}/$bn ${SHARED_DIR}/${INSTALL_TARGET}
        $AS_VAGRANT ln -s ${SHARED_DIR}/${INSTALL_TARGET}/$bn $COREDEV_D
    fi
done

# copy and link back to src
if [ ! -d ${SHARED_DIR}/${INSTALL_TARGET}/src ]; then
    if [ -d ${COREDEV_D}/src ]; then
        $AS_VAGRANT mv ${COREDEV_D}/src ${SHARED_DIR}/${INSTALL_TARGET}
    else
        $AS_VAGRANT mkdir ${SHARED_DIR}/${INSTALL_TARGET}/src
    fi
    $AS_VAGRANT ln -s ${SHARED_DIR}/${INSTALL_TARGET}/src $COREDEV_D
fi


cd "${VHOME}"
for script in ${SHARED_DIR}/manifests/guest_scripts/*; do
    if [ ! -f `basename $script` ]; then
        $AS_VAGRANT cp $script .
        chmod 755 *.sh
    fi
done

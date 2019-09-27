#!/bin/bash
set -e
DIR_BASE=$(cd ${BASH_SOURCE[0]%/*} && pwd)
RELEASE_VERSION="3.29.0"
FILE_RELEASE_VERSION="3290000"
_REQUIRED_YUM_PACKAGES="rpm-build libtool pkgconfig"
SPEC_FILE=sqlite3.spec


if [ "$RELEASE_VERSION" == "" ]; then
      echo "First argument must be release version to compile"; exit 1
fi
set -e
if [ -f ".${SPEC_FILE}" ]; then
      unlink .${SPEC_FILE}
fi

cp ${SPEC_FILE}.template .${SPEC_FILE}
sed -i "s/__RELEASE_VERSION__/${RELEASE_VERSION}/g" .${SPEC_FILE}
sed -i "s/__FILE_RELEASE_VERSION__/${FILE_RELEASE_VERSION}/g" .${SPEC_FILE}

sudo yum -y install $_REQUIRED_YUM_PACKAGES

mkdir -p ~/rpmbuild/SOURCES

wget -4 https://www.sqlite.org/2019/sqlite-autoconf-${FILE_RELEASE_VERSION}.tar.gz -O ~/rpmbuild/SOURCES/sqlite-autoconf-${FILE_RELEASE_VERSION}.tar.gz
cDir=$(pwd)
cd /tmp
rm -rf sqlite*

tar zxf ~/rpmbuild/SOURCES/sqlite-autoconf-${FILE_RELEASE_VERSION}.tar.gz

ls |grep sqlite


mv sqlite-autoconf-$FILE_RELEASE_VERSION sqlite3-$RELEASE_VERSION


tar -czf ~/rpmbuild/SOURCES/sqlite3-${RELEASE_VERSION}.tar.gz sqlite3-$RELEASE_VERSION

ls -al ~/rpmbuild/SOURCES/sqlite3-${RELEASE_VERSION}.tar.gz

cd $cDir
rpmbuild -bb .${SPEC_FILE}

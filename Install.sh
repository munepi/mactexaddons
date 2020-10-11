#!/bin/bash

export MACTEXADDONS_PREFIX=${PREFIX:-/usr/local}

if [ -d ${MACTEXADDONS_PREFIX} ]; then
    echo E: already exists: ${MACTEXADDONS_PREFIX}
    exit 1
fi

# Gooooo!
mkdir -p ${MACTEXADDONS_PREFIX}
cp -a Work/* ${MACTEXADDONS_PREFIX}/

# # setup ghostscript for CID/TTF CJK fonts
# perl $(dirname $0)/cjk-gs-integrate.pl --force \
#      --output ${MACTEXADDONS_PREFIX}/share/ghostscript/9.25/Resource/

echo $(basename $0): done

exit

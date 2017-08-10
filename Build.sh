#!/bin/bash -x

set -e

. $(dirname $0)/libmactexaddons.sh

mactexaddonsPrep
mactexaddonsBuild
mactexaddonsPack
# mactexaddonsPackSource
mactexaddonsClean

exit

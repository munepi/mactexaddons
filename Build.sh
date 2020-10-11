#!/bin/bash -x

set -e

. $(dirname $0)/libmactexaddons.sh

mactexaddonsClean
mactexaddonsPrep
mactexaddonsBuild
mactexaddonsPack
mactexaddonsClean

exit

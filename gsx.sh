#!/bin/bash

GHOSTSCRIPT_PREFIX=$(cd $(dirname $0)/../; pwd)

__gs=${GHOSTSCRIPT_PREFIX}/bin/gs-X11

$__gs \
    -I ${GHOSTSCRIPT_PREFIX}/share/ghostscript/9.53.3/Resource/Init \
    -I ${GHOSTSCRIPT_PREFIX}/share/ghostscript/9.53.3/Resource/Font \
    -I ${GHOSTSCRIPT_PREFIX}/share/ghostscript/9.53.3/lib \
    -I ${GHOSTSCRIPT_PREFIX}/share/ghostscript/9.53.3/fonts \
    -I ${GHOSTSCRIPT_PREFIX}/share/ghostscript/fonts \
    $@

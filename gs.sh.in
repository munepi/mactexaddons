#!/bin/bash

GHOSTSCRIPT_PREFIX=${MACTEXADDONS_PREFIX:-@@MACTEXADDONS_PREFIX@@}

__gs=${GHOSTSCRIPT_PREFIX}/bin/gs-noX11

$__gs \
    -I ${GHOSTSCRIPT_PREFIX}/share/ghostscript/9.53.3/Resource/Init \
    -I ${GHOSTSCRIPT_PREFIX}/share/ghostscript/9.53.3/Resource/Font \
    -I ${GHOSTSCRIPT_PREFIX}/share/ghostscript/9.53.3/lib \
    -I ${GHOSTSCRIPT_PREFIX}/share/ghostscript/9.53.3/fonts \
    -I ${GHOSTSCRIPT_PREFIX}/share/ghostscript/fonts \
    $@

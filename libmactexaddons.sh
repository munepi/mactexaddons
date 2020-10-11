#!/bin/bash

GSVER=9.53.3
GSSHAREDIR=ghostscript-${GSVER}-share
NKFTARBALL=nkf-2.1.5.high_sierra.bottle.tar.gz

__tar="/usr/local/bin/gtar --owner 0 --group 0"


mactexaddonsPrep(){
    for x in wget pixz curl shasum pkgutil pax; do
        which ${x} >/dev/null
    done

    ## Ghostscript-9.16.pkg supported standard structure of GNU/GS.
    # wget -N https://pages.uoregon.edu/koch/Ghostscript-${GSVER}-Full.pkg
    shasum -c Ghostscript-${GSVER}-Full.pkg.sha1sum

    return 0
}

mactexaddonsClean(){
    rm -rf Temp Work || return 1
    find . -name "*~" -delete

    return 0
}

mactexaddonsBuild(){
    local __pax="pax" #-v

    mactexaddonsClean || return 1
    mkdir -p Work || return 1

    rm -rf Temp || return 1
    # pkgutil --expand Ghostscript-${GSVER}.pkg Temp || return 1
    mkdir Temp
    xar --exclude Resources -xvf Ghostscript-${GSVER}-Full.pkg -C Temp
    $__pax --insecure -rz -f ./Temp/Ghostscript-9.53.3-libgs-Start.pkg/Payload -s ',^./,./Work/,'
    $__pax --insecure -rz -f ./Temp/Ghostscript-9.53.3-Start.pkg/Payload -s ',^./,./Work/,'

    find Work//usr/local/share/ -type l -delete
    cp -a ${GSSHAREDIR}/* Work//usr/local/share/ || return 1
    mv Work//usr/local/* Work/
    rm -rf Work//usr/local/

    # install wrapper for each gs-noX11, gs-x11
    for x in gs gsx; do
        cp -a ${x}.sh Work/bin/${x}
        chmod +x Work/bin/${x}
    done

    ## nkf
    $__tar -C Work -xf ${NKFTARBALL} || return 1
    cp -afv Work/nkf/2.1.5/{bin,share} Work/
    rm -rf Work/nkf/

    ## run cjk-gs-integrate.pl when installing mactexaddons!!
    # ## generate the Ghostscript FontSpec files for the Hiragino fonts
    # ## bundled on Mac OS X
    # mkhirafontspec Work/share/ghostscript/${GSVER}/Resource/Font
    # mkhiracidfonts Work/share/ghostscript/${GSVER}/Resource/CIDFont

    return 0
}

mactexaddonsPack(){
    local PKGNAME=mactexaddons-$(date +%Y%m%d)

    rm -rf ${PKGNAME}
    mkdir -p ${PKGNAME}

    cp -a Work Install.sh ${PKGNAME}/

    $__tar -cf - ${PKGNAME} | pixz -9 -p 4 >${PKGNAME}.tar.xz
    shasum ${PKGNAME}.tar.xz > ${PKGNAME}.tar.xz.sha1sum

    rm -rf ${PKGNAME}

    return 0
}

mactexaddonsTest(){
    return 0
}


#
# settings for Hiragino fonts
#
FontList=(
    ## Morisawa NewCID
    Ryumin-Light,Japan
    GothicBBB-Medium,Japan
    FutoMinA101-Bold,Japan
    FutoGoB101-Bold,Japan
    Jun101-Light,Japan
    ## Screen Hiragino bundled in OS X
    HiraKakuPro-W3,Japan
    HiraKakuPro-W6,Japan
    HiraKakuStd-W8,Japan
    HiraMaruPro-W4,Japan
    HiraMinPro-W3,Japan
    HiraMinPro-W6,Japan
    HiraKakuProN-W3,Japan
    HiraKakuProN-W6,Japan
    HiraKakuStdN-W8,Japan
    HiraMaruProN-W4,Japan
    HiraMinProN-W3,Japan
    HiraMinProN-W6,Japan
    # HiraginoSansGB-W3,GB
    # HiraginoSansGB-W6,GB
    # HiraginoSansCNS-W3,CNS
    # HiraginoSansCNS-W6,CNS
    ## Jiyukobo Yu bundled in OS X
    YuGo-Bold,Japan
    YuGo-Medium,Japan
    YuMin-Demibold,Japan
    YuMin-Medium,Japan
)

EncodeList_Japan=(
    2004-H
    2004-V
    78-EUC-H
    78-EUC-V
    78-H
    78-RKSJ-H
    78-RKSJ-V
    78-V
    78ms-RKSJ-H
    78ms-RKSJ-V
    83pv-RKSJ-H
    90ms-RKSJ-H
    90ms-RKSJ-V
    90msp-RKSJ-H
    90msp-RKSJ-V
    90pv-RKSJ-H
    90pv-RKSJ-V
    Add-H
    Add-RKSJ-H
    Add-RKSJ-V
    Add-V
    Adobe-Japan1-0
    Adobe-Japan1-1
    Adobe-Japan1-2
    Adobe-Japan1-3
    Adobe-Japan1-4
    Adobe-Japan1-5
    Adobe-Japan1-6
    EUC-H
    EUC-V
    Ext-H
    Ext-RKSJ-H
    Ext-RKSJ-V
    Ext-V
    H
    Hankaku
    Hiragana
    Identity-H
    Identity-V
    Katakana
    NWP-H
    NWP-V
    RKSJ-H
    RKSJ-V
    Roman
    UniJIS-UCS2-H
    UniJIS-UCS2-HW-H
    UniJIS-UCS2-HW-V
    UniJIS-UCS2-V
    UniJIS-UTF16-H
    UniJIS-UTF16-V
    UniJIS-UTF32-H
    UniJIS-UTF32-V
    UniJIS-UTF8-H
    UniJIS-UTF8-V
    UniJIS2004-UTF16-H
    UniJIS2004-UTF16-V
    UniJIS2004-UTF32-H
    UniJIS2004-UTF32-V
    UniJIS2004-UTF8-H
    UniJIS2004-UTF8-V
    UniJISPro-UCS2-HW-V
    UniJISPro-UCS2-V
    UniJISPro-UTF8-V
    UniJISX0213-UTF32-H
    UniJISX0213-UTF32-V
    UniJISX02132004-UTF32-H
    UniJISX02132004-UTF32-V
    V
    WP-Symbol
)

EncodeList_GB=(
    Adobe-GB1-0
    Adobe-GB1-1
    Adobe-GB1-2
    Adobe-GB1-3
    Adobe-GB1-4
    Adobe-GB1-5
    GB-EUC-H
    GB-EUC-V
    GB-H
    GB-RKSJ-H
    GB-V
    GBK-EUC-H
    GBK-EUC-V
    GBK2K-H
    GBK2K-V
    GBKp-EUC-H
    GBKp-EUC-V
    GBT-EUC-H
    GBT-EUC-V
    GBT-H
    GBT-RKSJ-H
    GBT-V
    GBTpc-EUC-H
    GBTpc-EUC-V
    GBpc-EUC-H
    GBpc-EUC-V
    Identity-H
    Identity-V
    UniGB-UCS2-H
    UniGB-UCS2-V
    UniGB-UTF16-H
    UniGB-UTF16-V
    UniGB-UTF32-H
    UniGB-UTF32-V
    UniGB-UTF8-H
    UniGB-UTF8-V
)

EncodeList_CNS=(
    Adobe-CNS1-0
    Adobe-CNS1-1
    Adobe-CNS1-2
    Adobe-CNS1-3
    Adobe-CNS1-4
    Adobe-CNS1-5
    Adobe-CNS1-6
    B5-H
    B5-V
    B5pc-H
    B5pc-V
    CNS-EUC-H
    CNS-EUC-V
    CNS1-H
    CNS1-V
    CNS2-H
    CNS2-V
    ETHK-B5-H
    ETHK-B5-V
    ETen-B5-H
    ETen-B5-V
    ETenms-B5-H
    ETenms-B5-V
    HKdla-B5-H
    HKdla-B5-V
    HKdlb-B5-H
    HKdlb-B5-V
    HKgccs-B5-H
    HKgccs-B5-V
    HKm314-B5-H
    HKm314-B5-V
    HKm471-B5-H
    HKm471-B5-V
    HKscs-B5-H
    HKscs-B5-V
    Identity-H
    Identity-V
    UniCNS-UCS2-H
    UniCNS-UCS2-V
    UniCNS-UTF16-H
    UniCNS-UTF16-V
    UniCNS-UTF32-H
    UniCNS-UTF32-V
    UniCNS-UTF8-H
    UniCNS-UTF8-V
)

EncodeList_Korea=(
    Adobe-Korea1-0
    Adobe-Korea1-1
    Adobe-Korea1-2
    Identity-H
    Identity-V
    KSC-EUC-H
    KSC-EUC-V
    KSC-H
    KSC-Johab-H
    KSC-Johab-V
    KSC-RKSJ-H
    KSC-V
    KSCms-UHC-H
    KSCms-UHC-HW-H
    KSCms-UHC-HW-V
    KSCms-UHC-V
    KSCpc-EUC-H
    KSCpc-EUC-V
    UniKS-UCS2-H
    UniKS-UCS2-V
    UniKS-UTF16-H
    UniKS-UTF16-V
    UniKS-UTF32-H
    UniKS-UTF32-V
    UniKS-UTF8-H
    UniKS-UTF8-V
)

## mkgsfontspec [fontname] [encode] > [fontspec]
mkgsfontspec(){
    local fontname=$1
    local encode=$2
	cat <<EOT
%%!PS-Adobe-3.0 Resource-Font
%%%%DocumentNeededResources: ${encode} (CMap)
%%%%IncludeResource: ${encode} (CMap)
%%%%BeginResource: Font (${fontname}-${encode})
(${fontname}-${encode})
(${encode}) /CMap findresource
[(${fontname}) /CIDFont findresource]
composefont
pop
%%%%EndResource
%%%%EOF
EOT
}

## mkhirafontspec [fontspec dir]
mkhirafontspec(){
    local FONTSPECDIR=$1

    mkdir -p $FONTSPECDIR

    for i in ${FontList[@]}; do
        fnt=$(echo $i | cut -f1 -d",")
        enc=$(echo $i | cut -f2 -d",")

        case $enc in
    	    Japan)	enclist="${EncodeList_Japan[@]}";;
	    GB)	enclist="${EncodeList_GB[@]}";;
	    CNS)	enclist="${EncodeList_CNS[@]}";;
	    Korea)	enclist="${EncodeList_Korea[@]}";;
	    *)	exit 1;;
        esac

        for j in $enclist; do
    	    mkgsfontspec ${fnt} ${j} > ${FONTSPECDIR}/${fnt}-${j}
        done
    done

    return 0
}

## mkhiracidfonts [cidfonts dir]
mkhiracidfonts(){
    local CIDFONTSDIR=$1

    mkdir -p $CIDFONTSDIR
    (cd $CIDFONTSDIR
        ln -s "/Library/Fonts/ヒラギノ明朝 Pro W3.otf" HiraMinPro-W3 ||:
        ln -s "/Library/Fonts/ヒラギノ明朝 Pro W6.otf" HiraMinPro-W6 ||:
        ln -s "/Library/Fonts/ヒラギノ丸ゴ Pro W4.otf" HiraMaruPro-W4 ||:
        ln -s "/Library/Fonts/ヒラギノ角ゴ Pro W3.otf" HiraKakuPro-W3 ||:
        ln -s "/Library/Fonts/ヒラギノ角ゴ Pro W6.otf" HiraKakuPro-W6 ||:
        ln -s "/Library/Fonts/ヒラギノ角ゴ Std W8.otf" HiraKakuStd-W8 ||:
        ln -s "/System/Library/Fonts/ヒラギノ明朝 ProN W3.otf" HiraMinProN-W3 ||:
        ln -s "/System/Library/Fonts/ヒラギノ明朝 ProN W6.otf" HiraMinProN-W6 ||:
        ln -s "/Library/Fonts/ヒラギノ丸ゴ ProN W4.otf" HiraMaruProN-W4 ||:
        ln -s "/System/Library/Fonts/ヒラギノ角ゴ ProN W3.otf" HiraKakuProN-W3 ||:
        ln -s "/System/Library/Fonts/ヒラギノ角ゴ ProN W6.otf" HiraKakuProN-W6 ||:
        ln -s "/Library/Fonts/ヒラギノ角ゴ StdN W8.otf" HiraKakuStdN-W8 ||:
        ln -s "/Library/Fonts/Yu Gothic Bold.otf" YuGo-Bold ||:
        ln -s "/Library/Fonts/Yu Gothic Medium.otf" YuGo-Medium ||:
        ln -s "/Library/Fonts/Yu Mincho Demibold.otf" YuMin-Demibold ||:
        ln -s "/Library/Fonts/Yu Mincho Medium.otf" YuMin-Medium ||:
    )

    return 0
}

# end of file

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"

TEXLIVE_MODULE_CONTENTS="luacode luainputenc lualatex-doc lualatex-math lualibs luamplib luaotfload luasseq luatexbase luatextra collection-luatex
"
TEXLIVE_MODULE_DOC_CONTENTS="luacode.doc luainputenc.doc lualatex-doc.doc lualatex-math.doc lualibs.doc luamplib.doc luaotfload.doc luasseq.doc luatexbase.doc luatextra.doc "
TEXLIVE_MODULE_SRC_CONTENTS="luacode.source luainputenc.source lualatex-doc.source lualatex-math.source lualibs.source luamplib.source luaotfload.source luasseq.source luatexbase.source luatextra.source "
inherit  texlive-module
DESCRIPTION="TeXLive LuaTeX packages"

LICENSE="GPL-2 FDL-1.1 GPL-2 LPPL-1.3 public-domain "
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2011
>=dev-tex/luatex-0.45

"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/luaotfload/mkluatexfontdb.lua"

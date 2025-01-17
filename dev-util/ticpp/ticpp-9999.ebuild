# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit subversion

ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk/"
MY_PV=cvs

DESCRIPTION="A completely new interface to TinyXML that uses MANY of the C++ strengths"
HOMEPAGE="http://code.google.com/p/ticpp/"
SRC_URI=""

LICENSE="MIT"
KEYWORDS=""
SLOT="0"
IUSE="debug doc"

DEPEND="dev-util/premake:4
	doc? ( app-doc/doxygen )"
RDEPEND=""

src_prepare() {
	premake4 gmake || die

	sed -i "s:\$(ARCH)::g" TiCPP.make || die
}

src_compile() {
	local myconf
	use !debug && myconf="config=release"
	emake ${myconf}

	if use doc ; then
		sed -i -e '/GENERATE_HTMLHELP/s:YES:NO:' dox || die
		doxygen dox || die
	fi
}

src_install () {
	insinto /usr/include/ticpp
	doins *.h

	if use debug ; then
		dolib lib/libticppd.a
	else
		dolib lib/libticpp.a
	fi

	dodoc {changes,readme,tutorial_gettingStarted,tutorial_ticpp}.txt

	use doc && dohtml -r docs/*
}

# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

PYTHON_USE_WITH="sqlite"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"

inherit multilib python versionator

MY_P=${PN}-"$(replace_version_separator 2 '-')"
DESCRIPTION="Web Application Attack and Audit Framework"
HOMEPAGE="http://w3af.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc gtk"

RDEPEND=">=dev-python/fpconst-0.7.2
	dev-python/lxml
	dev-python/nltk
	dev-python/pybloomfiltermmap
	dev-python/pyopenssl
	dev-python/pyPdf
	dev-python/python-cluster
	dev-python/pyyaml
	dev-python/simplejson
	dev-python/soappy
	dev-python/pysvn
	|| (
		net-analyzer/gnu-netcat
		net-analyzer/netcat
		net-analyzer/netcat6 )
	>=net-analyzer/scapy-2
	gtk? ( media-gfx/graphviz
		>dev-python/pygtk-2.0
		dev-python/pygtksourceview )"

S=${WORKDIR}/${PN}

src_prepare(){
	rm -r extlib/{cluster,fpconst-0.7.2,pyPdf,SOAPpy,yaml} || die
	sed -i 's,extlib.pyPdf.,,' core/data/parsers/pdfParser.py || die
	rm readme/{GPL,INSTALL} || die
	rm plugins/attack/payloads/code/netcat || die #bug 349780
	find "${S}" -type d -name .svn -exec rm -R {} +
}

src_install() {
	insinto /usr/$(get_libdir)/w3af
	doins -r core extlib locales plugins profiles scripts tools w3af_gui w3af_console || die
	fperms +x /usr/$(get_libdir)/w3af/w3af_{gui,console} || die
	dobin "${FILESDIR}"/w3af_console || die
	if use gtk ; then
		dobin "${FILESDIR}"/w3af_gui || die
	fi
	#use flag doc is here because doc is bigger than 3 Mb
	if use doc ; then
		insinto /usr/share/doc/${PF}/
		doins -r readme/* || die
	fi
}

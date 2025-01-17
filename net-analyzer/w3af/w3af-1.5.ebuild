# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit multilib python-single-r1

DESCRIPTION="Web Application Attack and Audit Framework"
HOMEPAGE="http://w3af.sourceforge.net/"
SRC_URI="https://github.com/andresriancho/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc gtk"

#w3af seems to ship sqlmap? maybe we should split this out...

QA_PREBUILT="usr/$(get_libdir)/${PN}/plugins/attack/db/sqlmap/udf/mysql/linux/32/lib_mysqludf_sys.so
	usr/$(get_libdir)/${PN}/plugins/attack/db/sqlmap/udf/mysql/linux/64/lib_mysqludf_sys.so
	usr/$(get_libdir)/${PN}/plugins/attack/db/sqlmap/udf/postgresql/linux/*/8.2/lib_postgresqludf_sys.so
	usr/$(get_libdir)/${PN}/plugins/attack/db/sqlmap/udf/postgresql/linux/*/8.3/lib_postgresqludf_sys.so
	usr/$(get_libdir)/${PN}/plugins/attack/db/sqlmap/udf/postgresql/linux/*/8.4/lib_postgresqludf_sys.so
	usr/$(get_libdir)/${PN}/plugins/attack/db/sqlmap/udf/postgresql/linux/*/9.0/lib_postgresqludf_sys.so"

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

src_prepare(){
	rm doc/{GPL,INSTALL} || die
}

src_install() {
	insinto /usr/$(get_libdir)/${PN}
	doins -r core locales plugins profiles scripts tools w3af_gui w3af_console || die
	fperms +x /usr/$(get_libdir)/${PN}/${PN}_{gui,console} || die
	dobin "${FILESDIR}"/${PN}_console || die
	if use gtk ; then
		dobin "${FILESDIR}"/${PN}_gui || die
	else
		rm "${ED}"/usr/$(get_libdir)/${PN}/w3af_gui
	fi
	#use flag doc is here because doc is bigger than 3 Mb
	if use doc ; then
		insinto /usr/share/doc/${PF}/
		doins -r doc/* || die
	fi
	python_fix_shebang "${ED}"usr/$(get_libdir)/${PN}
}

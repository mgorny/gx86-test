# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit apache-module

KEYWORDS="~amd64 ppc x86"

DESCRIPTION="An Apache2 module providing an embedded Tcl interpreter"
HOMEPAGE="http://tcl.apache.org/mod_tcl/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="Apache-1.1"
SLOT="0"
IUSE=""

DEPEND="dev-lang/tcl"
RDEPEND="${DEPEND}"

APXS2_ARGS="-c -Wl,-ltcl -DHAVE_TCL_H ${PN}.c tcl_cmds.c tcl_misc.c"

APACHE2_MOD_CONF="27_${PN}"
APACHE2_MOD_DEFINE="TCL"

DOCFILES="AUTHORS INSTALL NEWS README test_script.tm"

need_apache2_2

src_compile() {
	mv -f "tcl_core.c" "${PN}.c"
	apache-module_src_compile
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="GNU Autoconf, Automake and Libtool"
HOMEPAGE="http://sources.redhat.com/autobook/"
SRC_URI="http://sources.redhat.com/autobook/${P}.tar.gz
	examples? (
		http://sources.redhat.com/autobook/foonly-2.0.tar.gz
		http://sources.redhat.com/autobook/small-2.0.tar.gz
		http://sources.redhat.com/autobook/hello-2.0.tar.gz
		http://sources.redhat.com/autobook/convenience-2.0.tar.gz
	)"

LICENSE="OPL"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 m68k ppc s390 sh x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

src_install() {
	dohtml * || die
	if use examples ; then
		local d
		for d in {convenience,foonly,hello,small}-2.0 ; do
			insinto /usr/share/doc/${PF}/${d}
			doins -r "${WORKDIR}"/${d}/* || die "doins ${d} failed"
		done
	fi
}

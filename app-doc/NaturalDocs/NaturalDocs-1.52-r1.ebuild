# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit perl-module

DESCRIPTION="Extensible, multi-language source code documentation generator"
HOMEPAGE="http://www.naturaldocs.org/"
SRC_URI="mirror://sourceforge/naturaldocs/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"

IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
		app-arch/unzip"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/${PN}
	doins -r Styles Info JavaScript

	insinto /etc/${PN}
	doins -r Config/*
	dosym /etc/${PN} /usr/share/${PN}/Config

	perlinfo
	insinto ${VENDOR_LIB}
	doins -r Modules/NaturalDocs
	dodir /usr/share/${PN}/Modules
	dosym ${VENDOR_LIB}/NaturalDocs /usr/share/${PN}/Modules/NaturalDocs

	exeinto /usr/share/${PN}
	doexe ${PN}

	# Symlink the Perl script into /usr/bin
	dodir /usr/bin
	dosym /usr/share/${PN}/${PN} /usr/bin/${PN}

	# Documentation
	dohtml -r Help/*
	dosym /usr/share/doc/${PF}/html /usr/share/${PN}/Help
}

pkg_preinst() {
	if [[ -e /usr/share/${PN}/Config && ! -L /usr/share/${PN}/Config ]] ; then
		mkdir -p /etc/${PN}
		mv /usr/share/${PN}/Config/* /etc/${PN}/
		rm -rf /usr/share/${PN}/Config
	fi
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit oasis

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Syntax extension writing inline benchmarks"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV%.*}.00/individual/${MY_P}.tar.gz
	http://dev.gentoo.org/~aballier/distfiles/${MY_P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-ml/type-conv-${PV}:=
	dev-ml/pa_ounit:="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

OASIS_BUILD_DOCS=1

inherit oasis

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Jane Street Capital's asynchronous execution library (unix)"
HOMEPAGE="http://www.janestreet.com/ocaml"
SRC_URI="http://ocaml.janestreet.com/ocaml-core/${PV}/individual/${MY_P}.tar.gz
	http://dev.gentoo.org/~aballier/distfiles/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/ocaml-4.00.0:=
	>=dev-ml/bin-prot-109.15.00:=
	>=dev-ml/comparelib-109.27.00:=
	>=dev-ml/herelib-109.15.00:=
	>=dev-ml/pa_ounit-109.27.00:=
	>=dev-ml/pipebang-109.15.00:=
	>=dev-ml/core-${PV}:=
	>=dev-ml/async_kernel-${PV}:=
	>=dev-ml/sexplib-109.20.00:=
	>=dev-ml/fieldslib-109.20.00:=
	dev-ml/pa_test:=
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

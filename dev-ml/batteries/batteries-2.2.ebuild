# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit oasis

DESCRIPTION="The community-maintained foundation library for your OCaml projects"
HOMEPAGE="http://batteries.forge.ocamlcore.org/"
SRC_URI="https://forge.ocamlcore.org/frs/download.php/1363/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-ml/camomile:="
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit dev-ml/iTeML )"

DOCS=( "ChangeLog" "FAQ" "README.folders" "README.md" )

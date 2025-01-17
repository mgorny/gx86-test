# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

KMNAME="kde-runtime"
KMMODULE="plasma"
DECLARATIVE_REQUIRED="always"
inherit kde4-meta

DESCRIPTION="Script engine and package tool for plasma"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kactivities '' 4.13)
"
RDEPEND="${DEPEND}"

RESTRICT=test
# bug 443748

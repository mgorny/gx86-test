# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit versionator

DESCRIPTION="A virtual for PyPy Python implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0/$(get_version_component_range 1-2 ${PV})"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 ncurses sqlite"

RDEPEND="
	|| (
		>=dev-python/pypy-${PV}:${SLOT}[bzip2?,ncurses?,sqlite?,ssl(+)]
		>=dev-python/pypy-bin-${PV}:${SLOT}[sqlite?]
	)"

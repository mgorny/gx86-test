# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit base

DESCRIPTION="mutrace is a mutex tracer/profiler"
HOMEPAGE="http://0pointer.de/blog/projects/mutrace.html"
SRC_URI="http://0pointer.de/public/${P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm"
IUSE=""

DEPEND="sys-devel/binutils"
RDEPEND="${DEPEND}"

DOCS="README GPL2 GPL3 LGPL3"

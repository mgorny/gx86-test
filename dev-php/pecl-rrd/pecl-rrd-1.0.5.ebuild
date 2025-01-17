# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="RRDtool bindings for PHP"
LICENSE="BSD"

SLOT="0"

DEPEND=">=net-analyzer/rrdtool-1.4.5-r1[graph]"
RDEPEND="${DEPEND}"

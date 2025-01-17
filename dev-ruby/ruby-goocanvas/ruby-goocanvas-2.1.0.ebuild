# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby binding of GooCanvas"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="${RDEPEND}
	x11-libs/goocanvas:2.0"
DEPEND="${DEPEND}
	x11-libs/goocanvas:2.0"

ruby_add_bdepend "dev-ruby/pkg-config
	dev-ruby/rcairo"

ruby_add_rdepend ">=dev-ruby/ruby-gtk2-${PV}"

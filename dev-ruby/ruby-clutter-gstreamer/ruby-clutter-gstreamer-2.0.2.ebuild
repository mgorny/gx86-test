# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Clutter bindings"
KEYWORDS="~amd64 ~ppc"
IUSE=""

RUBY_S=ruby-gnome2-all-${PV}/clutter-gstreamer

DEPEND="${DEPEND} media-libs/clutter-gst"
RDEPEND="${RDEPEND} media-libs/clutter-gst"

ruby_add_rdepend ">=dev-ruby/ruby-clutter-${PV}
	>=dev-ruby/ruby-gstreamer-${PV}"

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_install() {
	each_fakegem_install
}

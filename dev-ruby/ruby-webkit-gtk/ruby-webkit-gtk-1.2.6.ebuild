# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
USE_RUBY="ruby19"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby WebKitGtk bindings"
KEYWORDS="~amd64 ~ppc"
IUSE=""

DEPEND="${DEPEND} net-libs/webkit-gtk:3"
RDEPEND="${RDEPEND} net-libs/webkit-gtk:3"

RUBY_S="ruby-gnome2-all-${PV}/webkit-gtk"

ruby_add_bdepend ">=dev-ruby/ruby-glib2-${PV}"
ruby_add_rdepend ">=dev-ruby/ruby-gobject-introspection-${PV}
	>=dev-ruby/ruby-gtk3-${PV}"

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_install() {
	each_fakegem_install
}

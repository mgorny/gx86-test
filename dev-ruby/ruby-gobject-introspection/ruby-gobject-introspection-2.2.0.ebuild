# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

RUBY_S=ruby-gnome2-all-${PV}/gobject-introspection

DESCRIPTION="Ruby GObjectIntrosprction bindings"
KEYWORDS="~amd64 ~ppc"
IUSE=""

DEPEND="${DEPEND} dev-libs/gobject-introspection"
RDEPEND="${RDEPEND} dev-libs/gobject-introspection"

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}"

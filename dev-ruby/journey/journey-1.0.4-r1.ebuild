# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

inherit ruby-fakegem versionator

DESCRIPTION="Journey is a router.  It routes requests"
HOMEPAGE="https://github.com/rails/journey"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x64-macos ~x86-solaris"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/hoe )"
ruby_add_bdepend "test? ( dev-ruby/hoe
	dev-ruby/json
	dev-ruby/minitest )"

RUBY_PATCHES=( "${FILESDIR}"/${P}-fix-tests.patch )

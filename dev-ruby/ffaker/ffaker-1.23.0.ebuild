# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Faster Faker, generates dummy data"
HOMEPAGE="https://github.com/emmanueloga/ffaker"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

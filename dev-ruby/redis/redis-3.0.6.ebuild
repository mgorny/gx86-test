# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20"

MY_P="redis-rb-${PV}"
RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_TASK_TEST="run"
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem

DESCRIPTION="A Ruby client library for Redis"
HOMEPAGE="https://github.com/redis/redis-rb"
SRC_URI="https://github.com/redis/redis-rb/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

DEPEND="test? ( dev-db/redis )"

RUBY_S="${MY_P}"

all_ruby_prepare() {
	# call me impatient, but this way we don't need netcat
	sed -i \
		-e '/test_subscribe_past_a_timeout/,+18d' \
		test/publish_subscribe_test.rb || die "sed failed"

	# Version 3.0.6 downloads and compiles redis-server to test against.
	# This patch reverts it to the way 3.0.5 does it, using the local server.
	# https://github.com/redis/redis-rb/commit/351a1294fe33f79c23495b7568045e9f484918f2
	epatch "${FILESDIR}/${P}-local-redis-server.patch"
}

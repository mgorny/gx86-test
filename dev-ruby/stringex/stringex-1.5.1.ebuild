# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19"

RUBY_FAKEGEM_DOC_DIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Extensions for Ruby's String class"
HOMEPAGE="http://github.com/rsl/stringex"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

# we could rely on activerecord[sqlite3], but since we do not remove the
# sqlite3 adapter from activerecord when building -sqlite3, it's easier
# to just add another dependency, so the user doesn't have to change the
# USE flags at all.
ruby_add_bdepend "
	test? (
		dev-ruby/activerecord
		dev-ruby/sqlite3
		dev-ruby/redcloth
		dev-ruby/test-unit:2
	)"

each_ruby_test() {
	# rake seems to break this
	ruby-ng_testrb-2 -Ilib test/*_test.rb || die "tests failed"
}

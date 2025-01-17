# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="AUTHORS CHANGES README.md"

inherit ruby-fakegem

DESCRIPTION="Ronn converts simple, human readable textfiles to roff for terminal display, and also to HTML"
HOMEPAGE="http://github.com/rtomayko/ronn/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE=""

ruby_add_rdepend "
	>=dev-ruby/hpricot-0.8.2
	>=dev-ruby/mustache-0.7.0
	>=dev-ruby/rdiscount-1.5.8"

all_ruby_prepare() {
	# Avoid test failing due to changes in hash handling in ruby 1.8.7:
	# https://github.com/rtomayko/ronn/issues/56
	sed -i -e '81 s:^:#:' test/test_ronn.rb || die
}

each_ruby_prepare() {
	# Make sure that we always use the right interpreter during tests.
	sed -i -e "/output/ s:ronn:${RUBY} bin/ronn:" test/test_ronn.rb
}

all_ruby_compile() {
	PATH="${S}/bin:${PATH}" rake man || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/ronn.1 man/ronn-format.7
}

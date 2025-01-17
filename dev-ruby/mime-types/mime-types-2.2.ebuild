# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Provides a mailcap-like MIME Content-Type lookup for Ruby"
HOMEPAGE="https://github.com/halostatue/mime-types/"

LICENSE="MIT Artistic GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

all_ruby_prepare() {
	# Handle minitest ourselves to avoid bundler dependency.
	sed -i -e '2igem "minitest", "~> 5.0"; require "minitest/autorun"' test/test_*.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb test/test_*.rb || die
}

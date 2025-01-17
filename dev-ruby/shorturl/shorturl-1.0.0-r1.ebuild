# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 jruby"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="ChangeLog.txt README.rdoc TODO.rdoc"

inherit ruby-fakegem eutils

DESCRIPTION="A very simple library to use URL shortening services such as TinyURL or RubyURL"
HOMEPAGE="http://shorturl.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~x86-macos"
IUSE=""

# All tests require network connectivity.
RESTRICT="test"

each_ruby_test() {
	${RUBY} -Ilib:test test/ts_all.rb || die "tests failed"
}

all_ruby_install() {
	all_fakegem_install

	pushd doc &>/dev/null
	dohtml -r .
	popd &>/dev/null
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README"

RUBY_FAKEGEM_EXTRAINSTALL="resources"

inherit ruby-fakegem

DESCRIPTION="A plugin system based only on rubygems that uses dependencies only"
# Hosted by mongrel's rubyforge
HOMEPAGE="http://mongrel.rubyforge.org/"

LICENSE="mongrel"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

each_ruby_test() {
	${RUBY} -Ilib test/test_plugins.rb || die "tests failed"
}

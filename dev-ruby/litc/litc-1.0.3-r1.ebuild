# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 jruby"

RUBY_FAKEGEM_TASK_DOC="rerdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A tiny ruby module for Amazon EC2 intance metadata"
HOMEPAGE="http://github.com/bkaney/litc"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_bdepend "test? ( dev-ruby/shoulda dev-ruby/fakeweb )"

all_ruby_prepare() {
	# Don't check dependencies since we provide slightly different packages.
	sed -i -e '/check_dependencies/d' Rakefile || die

	sed -i -e '/ruby-debug/ s:^:#:' test/helper.rb || die
}

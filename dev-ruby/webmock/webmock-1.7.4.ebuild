# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2

USE_RUBY="ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST="test spec NO_CONNECTION=true"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Allows stubbing HTTP requests and setting expectations on HTTP requests"
HOMEPAGE="http://github.com/bblimke/webmock"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/addressable-2.2.5 >=dev-ruby/crack-0.1.7"

ruby_add_bdepend "test? (
	dev-ruby/rspec:2
	>=dev-ruby/httpclient-2.1.5.2
	)"

# These are not supported for jruby.
USE_RUBY="ruby19" ruby_add_bdepend "test? ( >=dev-ruby/patron-0.4.9-r1 >=dev-ruby/em-http-request-0.2.14 )"

all_ruby_prepare() {
	# Remove bundler support
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# There is now optional support for curb and typhoeus which we don't
	# have in Gentoo yet.
	sed -i -e '/\(curb\|typhoeus\)/d' spec/spec_helper.rb || die
	rm spec/curb_spec.rb spec/typhoeus_hydra_spec.rb || die
}

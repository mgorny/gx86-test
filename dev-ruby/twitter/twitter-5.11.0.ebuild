# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby wrapper around the Twitter API"
HOMEPAGE="http://sferik.github.com/twitter/"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/addressable-2.3
	>=dev-ruby/buftok-0.2.0
	>=dev-ruby/equalizer-0.0.9
	=dev-ruby/faraday-0*
	>=dev-ruby/faraday-0.9.0
	>=dev-ruby/http-0.6.0:0.6
	>=dev-ruby/http_parser_rb-0.6.0
	>=dev-ruby/json-1.8
	>=dev-ruby/memoizable-0.4.0
	>=dev-ruby/naught-1.0
	=dev-ruby/simple_oauth-0*
	>=dev-ruby/simple_oauth-0.2"

ruby_add_bdepend "test? (
	dev-ruby/rspec:2
	dev-ruby/webmock
	)
	doc? ( dev-ruby/yard )"

all_ruby_prepare() {
#	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die "Unable to remove bundler code."

	sed -i -e '/\(simplecov\|coveralls\)/ s:^:#:' spec/helper.rb || die
}

each_ruby_test() {
	CI=true ${RUBY} -S rspec spec || die
}

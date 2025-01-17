# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md UPGRADE.md"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Typhoeus runs HTTP requests in parallel while cleanly encapsulating
handling logic."
HOMEPAGE="http://rubygems.org/gems/typhoeus/"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/ethon-0.7.1"

ruby_add_bdepend "test? ( dev-ruby/json >=dev-ruby/faraday-0.9 >=dev-ruby/sinatra-1.3 )"

all_ruby_prepare() {
	sed -e '/bundler/I s:^:#:' -i Rakefile spec/spec_helper.rb || die
}

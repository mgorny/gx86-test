# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="cucumber"
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="aruba.gemspec"

inherit ruby-fakegem

DESCRIPTION="Cucumber steps for driving out command line applications"
HOMEPAGE="https://github.com/cucumber/aruba"
LICENSE="MIT"

KEYWORDS="alpha amd64 arm hppa ia64 ~ppc ~ppc64 sparc x86"
SLOT="0"
IUSE=""

DEPEND="${DEPEND} test? ( sys-devel/bc )"
RDEPEND="${RDEPEND}"

ruby_add_rdepend "
	>=dev-ruby/childprocess-0.3.6 =dev-ruby/childprocess-0.3*
	>=dev-ruby/rspec-expectations-2.7:2
	>=dev-util/cucumber-1.1.1"

ruby_add_bdepend "test? ( >=dev-ruby/rspec-2.7:2 >=dev-ruby/bcat-0.6.1 )"

all_ruby_prepare() {
	# Remove bundler-related code.
	sed -i -e '/[Bb]undler/d' Rakefile || die
	rm Gemfile || die

	# Remove references to git ls-files.
	sed -i -e '/git ls-files/d' aruba.gemspec || die
}

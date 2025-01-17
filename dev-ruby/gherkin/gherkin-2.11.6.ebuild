# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
USE_RUBY="ruby19"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

inherit ruby-fakegem

DESCRIPTION="Fast Gherkin lexer and parser based on Ragel"
HOMEPAGE="https://github.com/cucumber/gherkin"
LICENSE="MIT"
SRC_URI="https://github.com/cucumber/gherkin/archive/v${PV}.tar.gz -> ${P}-git.tgz"

KEYWORDS="alpha amd64 arm hppa ia64 ~ppc ~ppc64 sparc x86"
SLOT="0"
IUSE="doc test"

DEPEND="${DEPEND} dev-util/ragel"
RDEPEND="${RDEPEND}"

ruby_add_bdepend "
	dev-ruby/rake-compiler
	test? (
		>=dev-ruby/builder-2.1.2
		>=dev-util/cucumber-1.1.3
		>=dev-ruby/rspec-2.6.0
		>=dev-ruby/term-ansicolor-1.0.5
	)
	doc? ( >=dev-ruby/yard-0.7.4 )"

ruby_add_rdepend ">=dev-ruby/json-1.7.6"

all_ruby_prepare() {
	# Remove Bundler-related things.
	sed -i -e '/[Bb]undler/d' Rakefile spec/spec_helper.rb features/support/env.rb || die
	rm Gemfile || die

	# Don't use compile dependencies to avoid building again for specs.
	sed -i -e '/:compile/d' Rakefile

	# Remove feature that depends on direct access to the cucumber
	# source. We could probably set this up by downloading the source
	# and unpacking it, but skipping this now in the interest of time.
	rm features/pretty_formatter.feature || die

	# We need to remove these tasks during bootstrapping since it tries
	# to load cucumber already but we can be sure it isn't installed
	# yet. Also remove other rake tasks for which we may not yet have
	# dependencies.
	if ! use test ; then
		rm tasks/cucumber.rake tasks/rspec.rake || die "Unable to remove rake tasks."
	fi

	# Avoid dependency on yard if USE=-doc
	if ! use doc ; then
		rm tasks/apidoc.rake || die
	fi

	# Avoid implicit dependency on git
	sed -i -e 's/git ls-files/echo/' gherkin.gemspec || die
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc ; then
		yard || die
	fi
}

each_ruby_compile() {
	${RUBY} -I lib -S rake -rrake/clean -f tasks/compile.rake compile || die
}

each_ruby_test() {
	${RUBY} -I lib -S rake spec || die "Specs failed"
	CUCUMBER_HOME="${HOME}" RUBYLIB=lib ${RUBY} -S cucumber features || die "Cucumber features failed"
}

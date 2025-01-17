# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19"

# Documentation task depends on sdoc which we currently don't have.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="cucumber.gemspec"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="http://github.com/aslakhellesoy/cucumber/wikis"
LICENSE="Ruby"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="examples test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/rspec-2.13.0
		>=dev-ruby/nokogiri-1.5.2
		>=dev-ruby/spork-0.9.0
		>=dev-ruby/syntax-1.0.0
		>=dev-util/aruba-0.5.2
		dev-ruby/bundler
		=dev-util/${P}
	)"

ruby_add_rdepend "
	>=dev-ruby/builder-2.1.2
	>=dev-ruby/diff-lcs-1.1.3
	>=dev-ruby/gherkin-2.12.0
	>=dev-ruby/multi_json-1.3.0
"

all_ruby_prepare() {
	# Remove development dependencies from the gemspec that we don't
	# need or can't satisfy.
	sed -i -e '/\(spork\|simplecov\|bcat\|kramdown\|yard\|capybara\|rack-test\|ramaze\|sinatra\|webrat\)/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Make sure spork is run in the right interpreter
	sed -i -e 's/#{Spork::BINARY}/-S #{Spork::BINARY}/' features/support/env.rb || die

	# Avoid json, they most likely fail due to multi_json weirdness.
	rm features/json_formatter.feature || die

	# Avoid dependency on git
	sed -i -e '/git ls-files/d' cucumber.gemspec || die
}

each_ruby_test() {
	${RUBY} -Ilib -S rspec spec || die "Specs failed"
	RUBYLIB=lib ${RUBY} -Ilib bin/cucumber features || die "Features failed"
}

all_ruby_install() {
	all_fakegem_install

	if use examples; then
		cp -pPR examples "${D}/usr/share/doc/${PF}" || die "Failed installing example files."
	fi
}

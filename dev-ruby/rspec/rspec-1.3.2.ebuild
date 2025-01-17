# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
USE_RUBY="ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST="spec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc TODO.txt Ruby1.9.rdoc Upgrade.rdoc"

RUBY_FAKEGEM_BINWRAP="spec"

RUBY_FAKEGEM_GEMSPEC="rspec.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="http://rspec.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

# it's actually optional, but tests fail if it's not installed and
# some other package might fail tests, so require it anyway.
ruby_add_rdepend ">=dev-ruby/diff-lcs-1.1.2"

RDEPEND="!<dev-ruby/rspec-rails-${PV}"

# don't require test dependencies for jruby since we cannot run them
# for now (fakefs doesn't work).
#
# We should add nokogiri here to make sure that we test as much as
# possible, but since it's yet unported to 1.9 and the nokogiri-due
# tests fail for sure, we'll be waiting on it.
USE_RUBY="ruby19" \
	ruby_add_bdepend "test? (
		>=dev-ruby/hoe-2.0.0
		dev-ruby/zentest
		>=dev-ruby/syntax-1.0
		>=dev-ruby/fakefs-0.2.1 )"
USE_RUBY="ruby19" ruby_add_bdepend "test? ( =dev-ruby/test-unit-1.2.3 )"

all_ruby_prepare() {
	# Avoid dependency on git.
	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Replace reference to /tmp to our temporary directory to avoid
	# sandbox-related failure.
	sed -i \
		-e "s:/tmp:${T}:" \
		spec/spec/runner/command_line_spec.rb || die

	# Avoid unneeded dependency on bundler
	sed -i -e '/[Bb]undler/ s:^:#:' Rakefile || die

	# Support ruby 1.9.3
	cp spec/spec/runner/formatter/html_formatted-1.9.2.html spec/spec/runner/formatter/html_formatted-1.9.3.html || die
	cp spec/spec/runner/formatter/text_mate_formatted-1.9.2.html spec/spec/runner/formatter/text_mate_formatted-1.9.3.html || die

	# Drop heckle dependency.
	rm spec/spec/runner/heckler_spec.rb spec/spec/runner/heckle_runner_spec.rb || die
	sed -i -e '381,398 s:^:#:' spec/spec/runner/option_parser_spec.rb || die

	# Remove broken spec.opts related tests. These were always broken
	# because they don't set up state properly, but only with
	# >=fakefs-0.4.2 this started throwing exceptions, bug 340385.
	sed -i -e '/implicitly loading spec/,/^  end/ s:^:#:' spec/spec/runner/option_parser_spec.rb || die

}

src_test() {
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"
	ruby-ng_src_test
}

each_ruby_test() {
	case ${RUBY} in
		*jruby)
			ewarn "Tests for JRuby are disabled because dev-ruby/fakefs does not currently support"
			ewarn "JRuby properly and it's needed to run the tests."
			;;
		*)
			each_fakegem_test
			;;
	esac
}

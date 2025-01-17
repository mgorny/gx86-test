# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 jruby"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_BINWRAP="thor"

inherit ruby-fakegem

DESCRIPTION="A scripting framework that replaces rake and sake"
HOMEPAGE="http://whatisthor.com/"

SRC_URI="http://github.com/erikhuda/${PN}/archive/v${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc"

ruby_add_bdepend "
	test? (
		>=dev-ruby/fakeweb-1.3
		dev-ruby/childlabor
	)"

all_ruby_prepare() {
	# Remove rspec default options (as we might not have the last
	# rspec).
	rm .rspec || die

	# Remove Bundler
	#rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Thorfile || die

	# Remove mandatory coverage collection using simplecov which is not
	# packaged.
	sed -i -e '/require .simplecov/,/SimpleCov.start/ s:^:#:' spec/helper.rb || die

	# Avoid a spec that requires UTF-8 support, so LANG=C still works,
	# bug 430402
	sed -i -e '/uses maximum terminal width/,/end/ s:^:#:' spec/shell/basic_spec.rb || die
}

each_ruby_prepare() {
	# Skip two failing specs on thor. Our jruby 1.6 is too old to file
	# bugs against and the next thor version will no longer work with
	# this version altogether.
	case ${RUBY} in
		*jruby)
			sed -i -e '/works with glob characters in the path/,/end/ s:^:#:' \
				spec/actions/directory_spec.rb || die
			;;
	esac
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

USE_RUBY="ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="rails init.rb VERSION VERSION_NAME"

inherit ruby-fakegem

DESCRIPTION="An extension of CSS3, adding nested rules, variables, mixins, selector inheritance, and more"
HOMEPAGE="http://sass-lang.com/"
LICENSE="MIT"

KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "doc? ( >=dev-ruby/yard-0.5.3 )"

ruby_add_rdepend ">=dev-ruby/listen-0.7.2:0 !!<dev-ruby/haml-3.1"

# tests could use `less` if we had it

all_ruby_prepare() {
	rm -rf vendor/listen

	# Don't require maruku as markdown provider but let yard decide.
	sed -i -e '/maruku/d' .yardopts || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*jruby)
			# Test fails on jruby for us, upstream can't
			# reproduce. Avoiding it since it only affects debug
			# information in the CSS file.
			# https://github.com/nex3/sass/issues/563
			sed -i -e '24s/filename_fn//' test/sass/plugin_test.rb || die
			;;
		*)
			;;
	esac
}

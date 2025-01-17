# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

USE_RUBY="ruby19 ruby20 jruby"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="docs/div_syntax.md docs/entity_test.md
	docs/markdown_syntax.md docs/maruku.md docs/math.md docs/other_stuff.md
	docs/proposal.md"

inherit ruby-fakegem

DESCRIPTION="A Markdown-superset interpreter written in Ruby"
HOMEPAGE="https://github.com/bhollis/maruku"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="highlight"

ruby_add_rdepend "highlight? ( dev-ruby/syntax )"

all_ruby_prepare() {
	sed -i -e '/[Ss]imple[Cc]ov/ s:^:#:' spec/spec_helper.rb || die
}

pkg_postinst() {
	elog
	elog "You need to emerge app-text/texlive and dev-texlive/texlive-latexextra if"
	elog "you want to use --pdf with Maruku. You may also want to emerge"
	elog "dev-texlive/texlive-latexrecommended to enable LaTeX syntax highlighting."
	elog
}

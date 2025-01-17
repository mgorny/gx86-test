# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md AUTHORS CONTRIBUTERS"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Yet-another-markdown-parser but fast, pure Ruby, using a strict syntax definition"
HOMEPAGE="http://kramdown.rubyforge.org/"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="latex"

LATEX_DEPS="latex? ( dev-texlive/texlive-latex dev-texlive/texlive-latexextra )"
RDEPEND+=" ${LATEX_DEPS}"
DEPEND+=" test? ( ${LATEX_DEPS} app-text/htmltidy )"

ruby_add_bdepend "doc? ( dev-ruby/rdoc )
	test? ( >=dev-ruby/coderay-1.0.0
		>=dev-ruby/prawn-1.2.1
		dev-ruby/prawn-table
		>=dev-ruby/stringex-1.5.1 )"

all_ruby_prepare() {
	if ! use latex; then
		# Remove latex tests. They will fail gracefully when latex isn't
		# present at all, but not when components are missing (most
		# notable ucs.sty).
		sed -i -e '/latex -v/,/^  end/ s:^:#:' test/test_files.rb || die
	fi
}

all_ruby_install() {
	all_fakegem_install

	doman man/man1/kramdown.1
}

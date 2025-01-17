# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19"

RUBY_FAKEGEM_DOCDIR="htmldoc/rdoc"
RUBY_FAKEGEM_EXTRADOC="AUTHORS THANKS"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="A template-based static website generator"
HOMEPAGE="http://webgen.gettalong.org"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="builder highlight markdown"

ruby_add_bdepend "doc? ( dev-ruby/rdoc )
	test? ( dev-ruby/kramdown
		dev-ruby/rdiscount )"

ruby_add_rdepend ">=dev-ruby/cmdparse-2.0.0
	dev-ruby/systemu
	dev-ruby/kramdown
	builder? ( >=dev-ruby/builder-2.1.0 )
	highlight? ( >=dev-ruby/coderay-0.8.312 )
	markdown? ( dev-ruby/maruku )"

all_ruby_install() {
	all_fakegem_install

	doman man/man1/webgen.1
}

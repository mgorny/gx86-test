# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOCS="README.markdown CONTRIBUTING.md CHANGELOG.md doc"
RUBY_FAKEGEM_TASK_TEST="test:unit"
inherit multilib ruby-fakegem

SRC_URI="https://github.com/vmg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="A Ruby wrapper for Upskirt"
HOMEPAGE="https://github.com/vmg/redcarpet"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/nokogiri )"

all_ruby_prepare() {
	sed -i -e '/bundler/d' -e 's/=> :compile//'  Rakefile || die
	rm test/benchmark.rb
}

each_ruby_configure() {
	${RUBY} -Cext/redcarpet extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/${PN}
	cp ext/${PN}/*$(get_modname) lib || die
}

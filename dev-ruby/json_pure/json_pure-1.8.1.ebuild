# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

USE_RUBY="ruby19 ruby20"
RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="a JSON implementation in pure Ruby"
HOMEPAGE="http://flori.github.com/json"

LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

ruby_add_bdepend "test? (
	dev-ruby/sdoc
	dev-ruby/permutation
)"

each_ruby_configure() {
	${RUBY} -Cext/json/ext/generator extconf.rb || die
	${RUBY} -Cext/json/ext/parser extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/json/ext/generator
	emake V=1 -Cext/json/ext/parser
	cp ext/json/ext/generator/generator$(get_modname) lib/ || die
	cp ext/json/ext/parser/parser$(get_modname) lib/ || die
}

each_ruby_test() {
	env JSON=pure ${RUBY} -S rake test_pure || die
	env JSON=ext  ${RUBY} -S rake test_ext || die
}

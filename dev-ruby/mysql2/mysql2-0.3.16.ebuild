# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

# Tests require a live MySQL database but should all pass.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit multilib ruby-fakegem

DESCRIPTION="A modern, simple and very fast Mysql library for Ruby - binding to libmysql"
HOMEPAGE="https://github.com/brianmario/mysql2"

LICENSE="MIT"
SLOT="0.3"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="${DEPEND} virtual/mysql[-static]"
RDEPEND="${RDEPEND} virtual/mysql[-static]"

each_ruby_configure() {
	${RUBY} -Cext/mysql2 extconf.rb --with-mysql-config "${EPREFIX}/usr/bin/mysqlconfig" || die
}

each_ruby_compile() {
	emake V=1 -Cext/mysql2 || die
	cp ext/mysql2/mysql2$(get_modname) lib/mysql2/ || die
}

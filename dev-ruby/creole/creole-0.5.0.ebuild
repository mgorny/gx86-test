# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGES README.creole"

inherit ruby-fakegem

DESCRIPTION="Creole-to-HTML converter for Creole, the lightweight markup language"
HOMEPAGE="https://github.com/minad/creole"
SRC_URI="https://github.com/minad/creole/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bacon )"

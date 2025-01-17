# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"
RUBY_FAKEGEM_EXTRADOC="README.markdown"
RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Easy and customizable generation of forged data"
HOMEPAGE="https://github.com/sevenwire/forgery"
SRC_URI="https://github.com/sevenwire/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' Rakefile spec/spec_helper.rb || die
}

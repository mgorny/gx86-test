# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md README.md"
RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="Statefully split input data by a specifiable token"
HOMEPAGE="https://github.com/sferik/buftok"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
}

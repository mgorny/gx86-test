# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

DESCRIPTION="JSON Parser/Constructor for Lua"
HOMEPAGE="http://www.eharning.us/wiki/luajson/"
SRC_URI="https://github.com/harningt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~x86"
IUSE="test"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
	dev-lua/lpeg"
DEPEND="test? ( dev-lua/luafilesystem )"

# lunit not in the tree yet
RESTRICT="test"

# nothing to compile
src_compile() { :; }

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install
	dodoc README docs/ReleaseNotes-${PV}.txt docs/LuaJSON.txt
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="ChangeLog README.html README-Mac-OSX.txt"

inherit multilib ruby-fakegem

DESCRIPTION="An interface between Ruby and the ImageMagick(TM) image processing library"
HOMEPAGE="http://rmagick.rubyforge.org/"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~ppc64 ~x86 ~x86-macos"
IUSE="doc"

# hdri causes extensive changes in the imagemagick internals, and
# rmagick is not ready to deal with those, see bug 184356.
RDEPEND+=" >=media-gfx/imagemagick-6.4.9:=[-hdri]"
DEPEND+=" >=media-gfx/imagemagick-6.4.9:=[-hdri]"

each_ruby_configure() {
	${RUBY} -Cext/RMagick extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -Cext/RMagick V=1
}

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_newins ext/RMagick/RMagick2$(get_modname) lib/RMagick2$(get_modname)
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*

	if use doc ; then
		dohtml -r doc
	fi
}

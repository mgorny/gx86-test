# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"
USE_RUBY="ruby19 jruby"

inherit ruby-ng

DESCRIPTION="Dictionary files for PRIME input method"
HOMEPAGE="http://taiyaki.org/prime/"
SRC_URI="http://prime.sourceforge.jp/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

each_ruby_configure() {
	econf --with-rubydir="$(ruby_rbconfig_value 'sitelibdir')" || die
}

each_ruby_compile() {
	emake || die
}

each_ruby_install() {
	emake DESTDIR="${D}" install || die
}

all_ruby_install() {
	dodoc AUTHORS ChangeLog NEWS README || die
}

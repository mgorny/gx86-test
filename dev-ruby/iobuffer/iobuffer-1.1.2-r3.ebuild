# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
# jruby: mkmf
# rbx: Kernel(Autoload)#allocate (method_missing)
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit multilib ruby-fakegem

GITHUB_USER="tarcieri"

DESCRIPTION="IO::Buffer is a fast byte queue which is primarily intended for non-blocking I/O applications"
HOMEPAGE="http://github.com/tarcieri/iobuffer"
SRC_URI="http://github.com/${GITHUB_USER}/iobuffer/tarball/v${PV} -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

RUBY_S="${GITHUB_USER}-${PN}-*"

all_ruby_prepare() {
	rm .rspec lib/.gitignore Gemfile* || die
}

each_ruby_configure() {
	${RUBY} -C ext extconf.rb || die
	sed -i -e "s/^ldflags  = /ldflags = $\(LDFLAGS\) /" ext/Makefile || die
}

each_ruby_compile() {
	emake -C ext V=1
	cp ext/iobuffer_ext$(get_modname) lib/ || die
}

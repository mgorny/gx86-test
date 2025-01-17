# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# ebuild generated by hackport 0.3.1.9999

CABAL_FEATURES="bin" # test-suite" broken
inherit haskell-cabal

DESCRIPTION="manage files with git, without checking their contents into git"
HOMEPAGE="http://git-annex.branchable.com/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="dbus doc inotify s3 test"
RESTRICT=test # don't seem to like our git environment much, does not ship all files

RDEPEND=">=dev-vcs/git-1.7.7" # TODO: add more deps?
DEPEND="${RDEPEND}
		test? ( dev-haskell/hunit
			dev-haskell/testpack
		)
		dev-haskell/bloomfilter
		>=dev-haskell/cabal-1.8
		dev-haskell/dataenc
		dev-haskell/edit-distance
		dev-haskell/extensible-exceptions
		dev-haskell/hslogger
		dev-haskell/http
		dev-haskell/ifelse
		dev-haskell/json[generic]
		dev-haskell/lifted-base
		dev-haskell/missingh
		dev-haskell/monad-control
		>=dev-haskell/mtl-2.1.1
		>=dev-haskell/network-2.0
		dev-haskell/pcre-light
		>=dev-haskell/quickcheck-2.1
		dev-haskell/safesemaphore
		dev-haskell/sha
		dev-haskell/text
		dev-haskell/transformers-base
		dev-haskell/utf8-string
		>=dev-lang/ghc-7.4.1

		dbus? ( >=dev-haskell/dbus-0.10.3 )
		inotify? ( dev-haskell/hinotify )
		s3? ( dev-haskell/hs3 )

		dev-lang/perl
		doc? ( www-apps/ikiwiki net-misc/rsync )"
# dev-lang/perl is to build the manpages
# www-apps/ikiwiki and net-misc/rsync used to build the rest of the docs

src_prepare() {
	#epatch "${FILESDIR}"/${P}-no-tf.patch
	echo 'mans: $(mans)' >>"${S}"/Makefile

	# there is no kqueue on linux, but should be on freebsd and solaris(?)
	cabal_chdeps \
		'testpack' 'testpack, SafeSemaphore' \
		'if (! os(windows) && ! os(solaris))' 'if (! os(windows) && ! os(linux))'
}

src_configure() {
	haskell-cabal_src_configure \
		--flag=-Assistant \
		$(cabal_flag dbus Dbus) \
		--flag=-DNS \
		$(cabal_flag inotify Inotify) \
		--flag=-Pairing \
		$(cabal_flag s3 S3) \
		--flag=-Webapp \
		--flag=-WebDAV \
		--flag=-XMPP
}

src_compile() {
	haskell-cabal_src_compile
	use doc && emake docs
	emake mans
}

src_test() {
	export GIT_CONFIG=${T}/temp-git-config
	git config user.email "git@src_test"
	git config user.name "Mr. ${P} The Test"

	emake test
}

src_install() {
	haskell-cabal_src_install
	dosym git-annex /usr/bin/git-annex-shell # standard make install does more, than needed

	emake install-mans DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
	use doc && emake install-docs DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
	mv "${ED}"/usr/share/doc/{${PN},${PF}}
	dodoc CHANGELOG README
}

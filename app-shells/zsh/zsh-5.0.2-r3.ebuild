# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# doc package for -dev version exists?
doc_available=true

inherit eutils flag-o-matic multilib prefix

MY_PV=${PV/_p/-dev-}
S=${WORKDIR}/${PN}-${MY_PV}

zsh_ftp="ftp://ftp.zsh.org/pub"

if [[ ${PV} != "${MY_PV}" ]] ; then
	ZSH_URI="${zsh_ftp}/development/${PN}-${MY_PV}.tar.bz2"
	if ${doc_available} ; then
		ZSH_DOC_URI="${zsh_ftp}/development/${PN}-${MY_PV}-doc.tar.bz2"
	else
		ZSH_DOC_URI="${zsh_ftp}/${PN}-${PV%_*}-doc.tar.bz2"
	fi
else
	ZSH_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
		${zsh_ftp}/${P}.tar.bz2"
	ZSH_DOC_URI="${zsh_ftp}/${PN}-${PV%_*}-doc.tar.bz2"
fi

DESCRIPTION="UNIX Shell similar to the Korn shell"
HOMEPAGE="http://www.zsh.org/"
SRC_URI="${ZSH_URI}
	doc? ( ${ZSH_DOC_URI} )"

LICENSE="ZSH gdbm? ( GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="caps debug doc examples gdbm maildir pcre static unicode"

RDEPEND="
	>=sys-libs/ncurses-5.1
	static? ( >=sys-libs/ncurses-5.7-r4[static-libs] )
	caps? ( sys-libs/libcap )
	pcre? ( >=dev-libs/libpcre-3.9
		static? ( >=dev-libs/libpcre-3.9[static-libs] ) )
	gdbm? ( sys-libs/gdbm )
"
DEPEND="sys-apps/groff
	${RDEPEND}"
PDEPEND="
	examples? ( app-doc/zsh-lovers )
"

src_prepare() {
	# fix zshall problem with soelim
	ln -s Doc man1
	mv Doc/zshall.1 Doc/zshall.1.soelim
	soelim Doc/zshall.1.soelim > Doc/zshall.1

	epatch "${FILESDIR}"/${PN}-init.d-gentoo-r1.diff
	epatch "${FILESDIR}"/${PN}-fix-parameter-modifier-crash.patch
	epatch "${FILESDIR}"/${PN}-5.0.2-texinfo-5.1.patch

	cp "${FILESDIR}"/zprofile-1 "${T}"/zprofile || die
	eprefixify "${T}"/zprofile || die
	if use prefix ; then
		sed -i -e 's|@ZSH_PREFIX@||' -e '/@ZSH_NOPREFIX@/d' "${T}"/zprofile || die
	else
		sed -i -e 's|@ZSH_NOPREFIX@||' -e '/@ZSH_PREFIX@/d' -e 's|""||' "${T}"/zprofile || die
	fi
}

src_configure() {
	local myconf=

	if use static ; then
		myconf+=" --disable-dynamic"
		append-ldflags -static
	fi
	if use debug ; then
		myconf+=" \
			--enable-zsh-debug \
			--enable-zsh-mem-debug \
			--enable-zsh-mem-warning \
			--enable-zsh-secure-free \
			--enable-zsh-hash-debug"
	fi

	if [[ ${CHOST} == *-darwin* ]]; then
		myconf+=" --enable-libs=-liconv"
		append-ldflags -Wl,-x
	fi

	econf \
		--bindir="${EPREFIX}"/bin \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--enable-etcdir="${EPREFIX}"/etc/zsh \
		--enable-fndir="${EPREFIX}"/usr/share/zsh/${PV%_*}/functions \
		--enable-site-fndir="${EPREFIX}"/usr/share/zsh/site-functions \
		--enable-function-subdirs \
		--with-term-lib="ncursesw ncurses" \
		--with-tcsetpgrp \
		$(use_enable maildir maildir-support) \
		$(use_enable pcre) \
		$(use_enable caps cap) \
		$(use_enable unicode multibyte) \
		$(use_enable gdbm ) \
		${myconf}

	if use static ; then
		# compile all modules statically, see Bug #27392
		# removed cap and curses because linking failes
		sed -i \
			-e "s,link=no,link=static,g" \
			-e "/^name=zsh\/cap/s,link=static,link=no," \
			-e "/^name=zsh\/curses/s,link=static,link=no," \
			"${S}"/config.modules || die
		if ! use gdbm ; then
			sed -i '/^name=zsh\/db\/gdbm/s,link=static,link=no,' \
				"${S}"/config.modules || die
		fi
	fi
}

src_test() {
	local i
	addpredict /dev/ptmx
	for i in C02cond.ztst Y01completion.ztst Y02compmatch.ztst Y03arguments.ztst ; do
		rm "${S}"/Test/${i} || die
	done
	emake check
}

src_install() {
	emake DESTDIR="${D}" install install.info

	insinto /etc/zsh
	doins "${T}"/zprofile

	keepdir /usr/share/zsh/site-functions
	insinto /usr/share/zsh/${PV%_*}/functions/Prompts
	newins "${FILESDIR}"/prompt_gentoo_setup-1 prompt_gentoo_setup

	# install miscellaneous scripts; bug #54520
	local i
	sed -i -e "s:/usr/local/bin/perl:${EPREFIX}/usr/bin/perl:g" \
		-e "s:/usr/local/bin/zsh:${EPREFIX}/bin/zsh:g" "${S}"/{Util,Misc}/* || die
	for i in Util Misc ; do
		insinto /usr/share/zsh/${PV%_*}/${i}
		doins ${i}/*
	done

	dodoc ChangeLog* META-FAQ NEWS README config.modules

	if use doc ; then
		pushd "${WORKDIR}/${PN}-${PV%_*}" >/dev/null
		dohtml -r Doc/*
		insinto /usr/share/doc/${PF}
		doins Doc/zsh.{dvi,pdf}
		popd >/dev/null
	fi

	docinto StartupFiles
	dodoc StartupFiles/z*
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		# should link to http://www.gentoo.org/doc/en/zsh.xml
		echo
		elog "If you want to enable Portage completions and Gentoo prompt,"
		elog "emerge app-shells/zsh-completion and add"
		elog "	autoload -U compinit promptinit"
		elog "	compinit"
		elog "	promptinit; prompt gentoo"
		elog "to your ~/.zshrc"
		echo
		elog "Also, if you want to enable cache for the completions, add"
		elog "	zstyle ':completion::complete:*' use-cache 1"
		elog "to your ~/.zshrc"
		echo
		elog "Note that a system zprofile startup file is installed. This will override"
		elog "PATH and possibly other variables that a user may set in ~/.zshenv."
		elog "Custom PATH settings and similar overridden variables can be moved to ~/.zprofile"
		elog "or other user startup files that are sourced after the system zprofile."
		echo
		elog "If PATH must be set in ~/.zshenv to affect things like non-login ssh shells,"
		elog "one method is to use a separate path-setting file that is conditionally sourced"
		elog "in ~/.zshenv and also sourced from ~/.zprofile. For more information, see the"
		elog "zshenv example in ${EROOT}/usr/share/doc/${PF}/StartupFiles/."
		echo
	fi
}

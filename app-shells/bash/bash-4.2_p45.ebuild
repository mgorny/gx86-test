# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="1"

inherit eutils flag-o-matic toolchain-funcs multilib

# Official patchlevel
# See ftp://ftp.cwru.edu/pub/bash/bash-4.2-patches/
PLEVEL=${PV##*_p}
MY_PV=${PV/_p*}
MY_PV=${MY_PV/_/-}
MY_P=${PN}-${MY_PV}
[[ ${PV} != *_p* ]] && PLEVEL=0
patches() {
	local opt=$1 plevel=${2:-${PLEVEL}} pn=${3:-${PN}} pv=${4:-${MY_PV}}
	[[ ${plevel} -eq 0 ]] && return 1
	eval set -- {1..${plevel}}
	set -- $(printf "${pn}${pv/\.}-%03d " "$@")
	if [[ ${opt} == -s ]] ; then
		echo "${@/#/${DISTDIR}/}"
	else
		local u
		for u in ftp://ftp.cwru.edu/pub/bash mirror://gnu/${pn} ; do
			printf "${u}/${pn}-${pv}-patches/%s " "$@"
		done
	fi
}

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://tiswww.case.edu/php/chet/bash/bashtop.html"
SRC_URI="mirror://gnu/bash/${MY_P}.tar.gz $(patches)"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="afs bashlogger examples mem-scramble +net nls plugins +readline vanilla"

DEPEND=">=sys-libs/ncurses-5.2-r2
	readline? ( >=sys-libs/readline-6.2 )
	nls? ( virtual/libintl )"
RDEPEND="${DEPEND}
	!<sys-apps/portage-2.1.6.7_p1
	!<sys-apps/paludis-0.26.0_alpha5"
# we only need yacc when the .y files get patched (bash42-005)
DEPEND+=" virtual/yacc"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if is-flag -malign-double ; then #7332
		eerror "Detected bad CFLAGS '-malign-double'.  Do not use this"
		eerror "as it breaks LFS (struct stat64) on x86."
		die "remove -malign-double from your CFLAGS mr ricer"
	fi
	if use bashlogger ; then
		ewarn "The logging patch should ONLY be used in restricted (i.e. honeypot) envs."
		ewarn "This will log ALL output you enter into the shell, you have been warned."
	fi
}

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd "${S}"

	# Include official patches
	[[ ${PLEVEL} -gt 0 ]] && epatch $(patches -s)

	# Clean out local libs so we know we use system ones
	rm -rf lib/{readline,termcap}/*
	touch lib/{readline,termcap}/Makefile.in # for config.status
	sed -ri -e 's:\$[(](RL|HIST)_LIBSRC[)]/[[:alpha:]]*.h::g' Makefile.in || die

	# Avoid regenerating docs after patches #407985
	sed -i -r '/^(HS|RL)USER/s:=.*:=:' doc/Makefile.in || die
	touch -r . doc/*

	epatch "${FILESDIR}"/${PN}-4.2-execute-job-control.patch #383237
	epatch "${FILESDIR}"/${PN}-4.2-parallel-build.patch
	epatch "${FILESDIR}"/${PN}-4.2-no-readline.patch
	epatch "${FILESDIR}"/${PN}-4.2-speed-up-read-N.patch

	epatch_user
}

src_compile() {
	local myconf=

	# For descriptions of these, see config-top.h
	# bashrc/#26952 bash_logout/#90488 ssh/#24762
	append-cppflags \
		-DDEFAULT_PATH_VALUE=\'\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"\' \
		-DSTANDARD_UTILS_PATH=\'\"/bin:/usr/bin:/sbin:/usr/sbin\"\' \
		-DSYS_BASHRC=\'\"/etc/bash/bashrc\"\' \
		-DSYS_BASH_LOGOUT=\'\"/etc/bash/bash_logout\"\' \
		-DNON_INTERACTIVE_LOGIN_SHELLS \
		-DSSH_SOURCE_BASHRC \
		$(use bashlogger && echo -DSYSLOG_HISTORY)

	# Don't even think about building this statically without
	# reading Bug 7714 first.  If you still build it statically,
	# don't come crying to us with bugs ;).
	#use static && export LDFLAGS="${LDFLAGS} -static"
	use nls || myconf="${myconf} --disable-nls"

	# Historically, we always used the builtin readline, but since
	# our handling of SONAME upgrades has gotten much more stable
	# in the PM (and the readline ebuild itself preserves the old
	# libs during upgrades), linking against the system copy should
	# be safe.
	# Exact cached version here doesn't really matter as long as it
	# is at least what's in the DEPEND up above.
	export ac_cv_rl_version=6.2

	# Force linking with system curses ... the bundled termcap lib
	# sucks bad compared to ncurses.  For the most part, ncurses
	# is here because readline needs it.  But bash itself calls
	# ncurses in one or two small places :(.

	use plugins && append-ldflags -Wl,-rpath,/usr/$(get_libdir)/bash
	tc-export AR #444070
	econf \
		--with-installed-readline=. \
		--with-curses \
		$(use_with afs) \
		$(use_enable net net-redirections) \
		--disable-profiling \
		$(use_enable mem-scramble) \
		$(use_with mem-scramble bash-malloc) \
		$(use_enable readline) \
		$(use_enable readline history) \
		$(use_enable readline bang-history) \
		${myconf}
	emake || die

	if use plugins ; then
		emake -C examples/loadables all others || die
	fi
}

src_install() {
	emake install DESTDIR="${D}" || die

	dodir /bin
	mv "${D}"/usr/bin/bash "${D}"/bin/ || die
	dosym bash /bin/rbash

	insinto /etc/bash
	doins "${FILESDIR}"/{bashrc,bash_logout}
	insinto /etc/skel
	for f in bash{_logout,_profile,rc} ; do
		newins "${FILESDIR}"/dot-${f} .${f}
	done

	local sed_args=(
		-e "s:#${USERLAND}#@::"
		-e '/#@/d'
	)
	if ! use readline ; then
		sed_args+=( #432338
			-e '/^shopt -s histappend/s:^:#:'
			-e 's:use_color=true:use_color=false:'
		)
	fi
	sed -i \
		"${sed_args[@]}" \
		"${D}"/etc/skel/.bashrc \
		"${D}"/etc/bash/bashrc || die

	if use plugins ; then
		exeinto /usr/$(get_libdir)/bash
		doexe $(echo examples/loadables/*.o | sed 's:\.o::g') || die
		insinto /usr/include/bash-plugins
		doins *.h builtins/*.h examples/loadables/*.h include/*.h \
			lib/{glob/glob.h,tilde/tilde.h}
	fi

	if use examples ; then
		for d in examples/{functions,misc,scripts,scripts.noah,scripts.v2} ; do
			exeinto /usr/share/doc/${PF}/${d}
			insinto /usr/share/doc/${PF}/${d}
			for f in ${d}/* ; do
				if [[ ${f##*/} != PERMISSION ]] && [[ ${f##*/} != *README ]] ; then
					doexe ${f}
				else
					doins ${f}
				fi
			done
		done
	fi

	doman doc/*.1
	dodoc README NEWS AUTHORS CHANGES COMPAT Y2K doc/FAQ doc/INTRO
	dosym bash.info /usr/share/info/bashref.info
}

pkg_preinst() {
	if [[ -e ${ROOT}/etc/bashrc ]] && [[ ! -d ${ROOT}/etc/bash ]] ; then
		mkdir -p "${ROOT}"/etc/bash
		mv -f "${ROOT}"/etc/bashrc "${ROOT}"/etc/bash/
	fi

	if [[ -L ${ROOT}/bin/sh ]]; then
		# rewrite the symlink to ensure that its mtime changes. having /bin/sh
		# missing even temporarily causes a fatal error with paludis.
		local target=$(readlink "${ROOT}"/bin/sh)
		local tmp=$(emktemp "${ROOT}"/bin)
		ln -sf "${target}" "${tmp}"
		mv -f "${tmp}" "${ROOT}"/bin/sh
	fi
}

pkg_postinst() {
	# If /bin/sh does not exist, provide it
	if [[ ! -e ${ROOT}/bin/sh ]]; then
		ln -sf bash "${ROOT}"/bin/sh
	fi
}

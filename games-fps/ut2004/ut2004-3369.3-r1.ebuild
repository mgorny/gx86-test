# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils multilib games

MY_P="ut2004-lnxpatch${PV%.*}-2.tar.bz2"
DESCRIPTION="Editor's Choice Edition plus Mega Pack for the critically-acclaimed first-person shooter"
HOMEPAGE="http://www.unrealtournament2004.com/"
SRC_URI="mirror://3dgamers/unrealtourn2k4/${MY_P}
	http://speculum.twistedgamer.com/pub/0day.icculus.org/${PN}/${MY_P}
	http://treefort.icculus.org/${PN}/${MY_P}
	http://sonic-lux.net/data/mirror/ut2004/${MY_P}
	mirror://gentoo/ut2004-v${PV/./-}-linux-dedicated.7z"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="mirror strip"

UIDEPEND="=virtual/libstdc++-3.3
	virtual/opengl
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	media-libs/libsdl
	media-libs/openal"
RDEPEND="sys-libs/glibc
	games-fps/ut2004-data
	games-fps/ut2004-bonuspack-ece
	games-fps/ut2004-bonuspack-mega
	dedicated? ( !games-server/ut2004-ded )
	opengl? ( ${UIDEPEND} )
	!dedicated? ( !opengl? ( ${UIDEPEND} ) )"
DEPEND="app-arch/p7zip"

S=${WORKDIR}/UT2004-Patch
dir=${GAMES_PREFIX_OPT}/${PN}

# The executable pages are required #114733
QA_EXECSTACK_x86="${dir:1}/System/ut2004-bin
	${dir:1}/System/ucc-bin"

src_prepare() {
	cd "${S}"/System

	# These files are owned by ut2004-bonuspack-mega
	rm -f Manifest.in{i,t} Packages.md5

	rm -f ucc-bin*

	if use amd64 ; then
		mv -f ut2004-bin-linux-amd64 ut2004-bin || die
	else
		rm -f ut2004-bin-linux-amd64
	fi

	cd "${WORKDIR}"/ut2004-ucc-bin-09192008
	if use amd64 ; then
		mv -f ucc-bin-linux-amd64 "${S}"/System/ucc-bin || die
	else
		mv -f ucc-bin "${S}"/System/ || die
	fi

	if use dedicated && ! use opengl ; then
		rm -f "${S}"/System/ut2004-bin
	fi
}

src_install() {
	insinto "${dir}"
	doins -r * || die "doins failed"
	fperms +x "${dir}"/System/ucc-bin || die "fperms ucc-bin failed"

	if use opengl || ! use dedicated ; then
		fperms +x "${dir}"/System/ut2004-bin || die "fperms ut2004-bin failed"

		dosym /usr/$(get_libdir)/libopenal.so "${dir}"/System/openal.so \
			|| die "dosym openal failed"
		dosym /usr/$(get_libdir)/libSDL-1.2.so.0 "${dir}"/System/libSDL-1.2.so.0 \
			|| die "dosym sdl failed"

		games_make_wrapper ut2004 ./ut2004 "${dir}" "${dir}"
		make_desktop_entry ut2004 "Unreal Tournament 2004"
	fi

	if use dedicated ; then
		games_make_wrapper ut2004-ded "./ucc-bin server" "${dir}"/System
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	# Here is where we check for the existence of a cdkey...
	# If we don't find one, we ask the user for it
	if [[ -f ${dir}/System/cdkey ]] ; then
		einfo "A cdkey file is already present in ${dir}/System"
	else
		ewarn "You MUST run this before playing the game:"
		ewarn "emerge --config =${CATEGORY}/${PF}"
		ewarn "That way you can [re]enter your cdkey."
	fi
	elog "Starting with 3369, the game supports render-to-texture. To enable"
	elog "it, you will need the Nvidia drivers of at least version 7676 and"
	elog "you should edit the following:"
	elog 'Set "UseRenderTargets=True" in the "[OpenGLDrv.OpenGLRenderDevice]"'
	elog 'section of your UT2004.ini or Default.ini and set "bPlayerShadows=True"'
	elog 'and "bBlobShadow=False" in the "[UnrealGame.UnrealPawn]" section of'
	elog 'your User.ini or DefUser.ini.'
}

pkg_postrm() {
	ewarn "This package leaves a cdkey file in ${dir}/System that you need"
	ewarn "to remove to completely get rid of this game's files."
}

pkg_config() {
	ewarn "Your CD key is NOT checked for validity here so"
	ewarn "make sure you type it in correctly."
	ewarn "If you CTRL+C out of this, the game will not run!"
	echo
	einfo "CD key format is: XXXXX-XXXXX-XXXXX-XXXXX"
	while true ; do
		einfo "Please enter your CD key:"
		read CDKEY1
		einfo "Please re-enter your CD key:"
		read CDKEY2
		if [[ -z ${CDKEY1} ]] || [[ -z ${CDKEY2} ]] ; then
			echo "You entered a blank CD key. Try again."
		else
			if [[ ${CDKEY1} == ${CDKEY2} ]] ; then
				echo "${CDKEY1}" | tr [:lower:] [:upper:] > "${dir}"/System/cdkey
				einfo "Thank you!"
				break
			else
				eerror "Your CD key entries do not match. Try again."
			fi
		fi
	done
}

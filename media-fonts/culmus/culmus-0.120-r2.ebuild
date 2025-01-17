# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit font

# Maintainer: also check culmus.conf file in ${P}.tar.gz

MY_A_P=AncientSemiticFonts-0.06-1
# The Type 1 fonts are just a stripped version of TrueType fonts and they are
# not updated unless there is a meaningful change and we need them for
# culmus-latex, see bug #350657
TYPE1_PV=0.105

DESCRIPTION="Hebrew Type1 fonts"
HOMEPAGE="http://culmus.sourceforge.net/"

FANCY_FONTS="journal hillel anka comix gan ozrad ktav-yad dorian gladia"
FANCY_YG_FONTS="ShmuelCLM MakabiYG"
TAAMEY_FONTS="TaameyDavidCLM TaameyFrankCLM KeterAramTsova KeterYG"

SRC_URI="mirror://sourceforge/culmus/${P}.tar.gz
	mirror://sourceforge/culmus/${PN}-type1-${TYPE1_PV}.tar.gz
	fontforge? ( mirror://sourceforge/culmus/${PN}-src-${PV}.tar.gz )
	ancient? ( !fontforge? ( mirror://sourceforge/culmus/${MY_A_P}.TTF.tgz )
		fontforge? ( mirror://sourceforge/culmus/${MY_A_P}.tgz ) )"
SRC_URI+=" fancy? ( $(printf "http://culmus.sourceforge.net/fancy/%s.tar.gz " ${FANCY_FONTS}) )"
SRC_URI+=" fancy? ( $(printf "http://culmus.sourceforge.net/fancy-yg/%s.zip " ${FANCY_YG_FONTS}) )"
SRC_URI+=" taamey? ( $(printf "http://culmus.sourceforge.net/taamim/%s.zip " ${TAAMEY_FONTS}) )"

# Some fonts are available in otf format too. Do we need them?
#	http://culmus.sourceforge.net/fancy/anka-otf.zip
#	http://culmus.sourceforge.net/fancy/hillel-otf.zip
#	http://culmus.sourceforge.net/fancy/journal-otf.zip

LICENSE="|| ( GPL-2 LICENSE-BITSTREAM ) ancient? ( MIT ) fancy? ( GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="ancient fancy fontforge taamey"

FONT_CONF=( "${FILESDIR}/65-culmus.conf" )

RDEPEND="!media-fonts/culmus-ancient"
DEPEND="${RDEPEND}
	fontforge? ( media-gfx/fontforge )"

S=${WORKDIR}
# Put all fonts, generated or not here
FONT_S=${S}/FONTS

src_unpack() {
	unpack ${P}.tar.gz # For type1 fonts...
	unpack ${PN}-type1-${TYPE1_PV}.tar.gz
	use fontforge && unpack ${PN}-src-${PV}.tar.gz

	use ancient && unpack ${MY_A_P}$(use fontforge || echo .TTF).tgz

	if use fancy; then
		unpack $(printf "%s.tar.gz " ${FANCY_FONTS})
		unpack $(printf "%s.zip " ${FANCY_YG_FONTS})
		mv TTF/* .
	fi

	if use taamey; then
		for font in ${TAAMEY_FONTS}; do
			mkdir ${font}
			pushd ${font}
			unpack ${font}.zip
			popd >/dev/null
		done
	fi
}

src_compile() {
	mkdir -p "${FONT_S}"
	if use fontforge; then
		pushd ${P}
		mv *.afm *.pfa "${FONT_S}"
		rm *.ttf
		popd >/dev/null

		pushd ${PN}-type1-${TYPE1_PV}
		mv *.afm *.pfa "${FONT_S}"
		popd >/dev/null

		pushd ${PN}-src-${PV}
		for f in *.sfd; do
			"${WORKDIR}"/${PN}-src-${PV}/GenerateTTF.pe ${f} "${FONT_S}" || die
		done
		popd >/dev/null

		if use ancient; then
			pushd ${MY_A_P}/src
			export FONTFORGE_LANGUAGE=ff
			make clean
			make all || die "Failed to build fonts"
			mv *.ttf "${FONT_S}"
			popd >/dev/null
		fi

		if use taamey; then
			for font in ${TAAMEY_FONTS}; do
				rm -rf ${font}/TTF
				pushd ${font}/SFD
				for f in *.sfd; do
					"${WORKDIR}"/${PN}-src-${PV}/GenerateTTF.pe ${f} "${FONT_S}" || die
				done
				popd >/dev/null
			done
		fi
	else
		pushd ${P}
		mv *.afm *.pfa *.ttf "${FONT_S}"
		popd >/dev/null

		pushd ${PN}-type1-${TYPE1_PV}
		mv *.afm *.pfa "${FONT_S}"
		popd >/dev/null

		if use ancient; then
			pushd ${MY_A_P}$(use fontforge || echo .TTF)/fonts
			mv *.ttf "${FONT_S}"
			popd >/dev/null
		fi

		if use taamey; then
			for font in ${TAAMEY_FONTS}; do
				pushd ${font}/TTF
				mv *.ttf "${FONT_S}"
				popd >/dev/null
			done
		fi
	fi

	use fancy && mv *.afm *.pfa *.ttf "${FONT_S}"
}

src_install() {
	FONT_SUFFIX="pfa $(use fancy && echo afm ttf)" \
		font_src_install

	rm -rf "${FONT_S}"
	find "${WORKDIR}" -name '*.ttf' -o -name '*.pfa' -o -name '*.pfm' |
		while read font; do
			ewarn "QA: missed font file: ${font}"
		done

	pushd ${PN}$(use fontforge && echo -src)-${PV}
	dodoc CHANGES || die
	popd >/dev/null

	if use ancient; then
		pushd "${WORKDIR}/${MY_A_P}$(use fontforge || echo .TTF)/"
		newdoc CHANGES{,.ancient} || die
		newdoc README{,.ancient} || die
		popd >/dev/null
	fi

	if use taamey; then
		for font in ${TAAMEY_FONTS}; do
			pushd ${font}
			[[ -f ChangeLog ]] && { newdoc ChangeLog{,.${font}} || die; }
			newdoc README{,.${font}} || die
			insinto /usr/share/doc/${PF}/${font}
			doins -r Samples
			popd >/dev/null
		done
	fi
}

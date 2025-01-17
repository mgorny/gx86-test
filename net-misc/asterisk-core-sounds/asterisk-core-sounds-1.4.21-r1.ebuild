# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

DESCRIPTION="Core sounds for asterisk"
HOMEPAGE="http://www.asterisk.org/"
LINGUAS="^en fr es ru" # ^ is used to indicate to the loops below to NOT set this as an optional
CODECS="alaw g722 g729 +gsm siren7 siren14 sln16 ulaw wav"

SRC_URI=""
IUSE=""
for c in ${CODECS}; do
	[[ "${c}" != +* ]] && IUSE+=" ${c}"
done
for l in ${LINGUAS}; do
	[[ "${l}" != ^* ]] && IUSE+=" linguas_${l}" && SRC_URI+=" linguas_${l}? ("
	for c in ${CODECS}; do
		[[ "${c}" != +* ]] &&
		SRC_URI+=" ${c#+}? ( http://downloads.asterisk.org/pub/telephony/sounds/releases/${PN}-${l#^}-${c#+}-${PV}.tar.gz )" ||
		SRC_URI+=" http://downloads.asterisk.org/pub/telephony/sounds/releases/${PN}-${l#^}-${c#+}-${PV}.tar.gz"
	done
	[[ "${l}" = ^* ]] || SRC_URI+=" )"
done

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=net-misc/asterisk-1.4"

S="${WORKDIR}"

src_unpack() {
	local ar

	for ar in ${A}; do
		l="${ar#${PN}-}"
		l=${l%%-*}
		c="${ar#${PN}-*-}"
		c=${c%%-*}
		ebegin "Unpacking ${c} audio files for \"${l}\""
			[ -d "${WORKDIR}/${l}" ] || mkdir "${WORKDIR}/${l}" || die "Error creating unpack directory"
			tar xf "${DISTDIR}/${ar}" -C "${WORKDIR}/${l}" || die "Error unpacking ${ar}"
		eend $?
	done
}

src_install() {
	for l in ${LINGUAS}; do
		if [[ "${l}" = ^* ]] || use linguas_${l}; then
			l="${l#^}"
			ebegin "Installing documentation for \"${l}\""
				dodoc ${l}/CHANGES-${PN%-sounds}-${l}-${PV} ${l}/${PN#asterisk-}-${l}.txt
				rm ${l}/CHANGES-${PN%-sounds}-${l}-${PV} ${l}/${PN#asterisk-}-${l}.txt
			eend $?
		fi
	done

	diropts -m 0770 -o asterisk -g asterisk
	insopts -m 0660 -o asterisk -g asterisk

	ebegin "Installing audio files"
		dodir /var/lib/asterisk/sounds
		insinto /var/lib/asterisk/sounds
		doins -r .
	eend $?
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

inherit multilib unpacker

DESCRIPTION="Binary plugins from Google Chrome for use in Chromium"
HOMEPAGE="http://www.google.com/chrome"

case ${PV} in
	*_alpha*|9999*)
		SLOT="unstable"
		CHROMEDIR="opt/google/chrome-${SLOT}"
		MY_PV=${PV/_alpha/-}
		;;
	*_beta*)
		SLOT="beta"
		CHROMEDIR="opt/google/chrome-${SLOT}"
		MY_PV=${PV/_beta/-}
		;;
	*_p*)
		SLOT="stable"
		CHROMEDIR="opt/google/chrome"
		MY_PV=${PV/_p/-}
		;;
	*)
		die "Invalid value for \${PV}: ${PV}"
		;;
esac

MY_PN="google-chrome-${SLOT}"
MY_P="${MY_PN}_${MY_PV}"

if [[ ${PV} != 9999* ]]; then
SRC_URI="
	amd64? (
		https://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_amd64.deb
	)
	x86? (
		https://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_i386.deb
	)
"
KEYWORDS="~amd64 ~x86"
fi

LICENSE="google-chrome"
IUSE="+flash"
RESTRICT="bindist mirror strip"

for x in 0 beta stable unstable; do
	if [[ ${SLOT} != ${x} ]]; then
		RDEPEND+=" !${CATEGORY}/${PN}:${x}"
	fi
done

S="${WORKDIR}/${CHROMEDIR}"
QA_PREBUILT="*"

pkg_nofetch() {
	eerror "Please wait 24 hours and sync your portage tree before reporting fetch failures."
}

if [[ ${PV} == 9999* ]]; then
src_unpack() {
	local base="https://dl.google.com/linux/direct"
	local debarch=${ARCH/x86/i386}
	wget -O google-chrome.deb "${base}/google-chrome-${SLOT}_current_${debarch}.deb" || die
	unpack_deb ./google-chrome.deb
}
fi

src_install() {
	local version flapper

	insinto /usr/$(get_libdir)/chromium-browser/

	if use flash; then
		doins -r PepperFlash

		# Since this is a live ebuild, we're forced to, unfortuantely,
		# dynamically construct the command line args for Chromium.
		version=$(sed -n 's/.*"version": "\(.*\)",.*/\1/p' PepperFlash/manifest.json)
		flapper="${ROOT}usr/$(get_libdir)/chromium-browser/PepperFlash/libpepflashplayer.so"
		echo -n "CHROMIUM_FLAGS=\"\${CHROMIUM_FLAGS} " > pepper-flash
		echo -n "--ppapi-flash-path=$flapper " >> pepper-flash
		echo "--ppapi-flash-version=$version\"" >> pepper-flash

		insinto /etc/chromium/
		doins pepper-flash
	fi
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="A simple password checker, used by any software in need of user authentication"
KEYWORDS=" ~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug pam"

RDEPEND="
	pam? (
		>=kde-base/kdebase-pam-7
		virtual/pam
	)
"

src_prepare() {
	kde4-meta_src_prepare

	use pam && epatch "${FILESDIR}/${PN}-4.4.2-no-SUID-no-GUID.patch"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with pam)
	)

	kde4-meta_src_configure
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="5"

IUSE=""
MODS="apache"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for apache"

KEYWORDS=""
DEPEND="${DEPEND}
	sec-policy/selinux-kerberos
"
RDEPEND="${DEPEND}"

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.5 *-jython"
MY_PACKAGE="News"

inherit twisted versionator

DESCRIPTION="Twisted News is an NNTP server and programming library"

KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="=dev-python/twisted-core-$(get_version_component_range 1-2)*
	=dev-python/twisted-mail-$(get_version_component_range 1-2)*"
RDEPEND="${DEPEND}"

PYTHON_MODNAME="twisted/news twisted/plugins"

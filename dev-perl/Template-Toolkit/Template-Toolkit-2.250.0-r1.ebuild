# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=ABW
MODULE_VERSION=2.25
inherit perl-module

DESCRIPTION="The Template Toolkit"

SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~ppc-aix ~x86-fbsd ~x86-solaris"
IUSE="xml gd mysql postgres latex vim-syntax"

RDEPEND="dev-perl/text-autoformat
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	>=dev-perl/AppConfig-1.56"
DEPEND="${RDEPEND}"
PDEPEND="dev-perl/text-autoformat
	vim-syntax? ( app-vim/tt2-syntax )
	xml? ( dev-perl/Template-XML )
	gd? ( dev-perl/Template-GD )
	mysql? ( dev-perl/Template-DBI )
	latex? ( dev-perl/Template-Latex )
	postgres? ( dev-perl/Template-DBI )"

myconf=(
	TT_XS_ENABLE=y
	TT_XS_DEFAULT=y
	TT_QUIET=y
	TT_ACCEPT=y
)

SRC_TEST=do

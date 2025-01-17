# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

SLOT="0"
IUSE=""
DESCRIPTION="HTML editing"
SRC_URI="http://ftp.xemacs.org/packages/hm--html-menus-${PV}-pkg.tar.gz"
PKG_CAT="standard"

RDEPEND="app-xemacs/dired
app-xemacs/xemacs-base
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages

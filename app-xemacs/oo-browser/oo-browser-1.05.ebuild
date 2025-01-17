# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

SLOT="0"
IUSE=""
DESCRIPTION="The Multi-Language Object-Oriented Code Browser"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/hyperbole
app-xemacs/gnus
app-xemacs/sh-script
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages

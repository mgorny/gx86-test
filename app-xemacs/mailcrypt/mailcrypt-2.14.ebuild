# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

SLOT="0"
IUSE=""
DESCRIPTION="Support for messaging encryption with PGP"
PKG_CAT="standard"

RDEPEND="app-xemacs/mail-lib
app-xemacs/fsf-compat
app-xemacs/xemacs-base
app-xemacs/cookie
app-xemacs/gnus
app-xemacs/mh-e
app-xemacs/rmail
app-xemacs/vm
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages

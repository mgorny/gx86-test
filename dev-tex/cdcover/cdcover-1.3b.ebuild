# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit latex-package

S=${WORKDIR}/cdcover
DESCRIPTION="LaTeX package used to create CD case covers"
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/cd-cover/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~sparc"
IUSE=""

# checksum from official ftp site changes frequently so we mirror it

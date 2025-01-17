# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} pypy pypy2_0 )

inherit distutils-r1

DESCRIPTION="Basic functions for handling mime-types in python"
HOMEPAGE="http://code.google.com/p/mimeparse"
SRC_URI="http://mimeparse.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86"
IUSE="test"

# tests fail for python3
python_test() {
	"${PYTHON}" mimeparse_test.py || die
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

KDE_HANDBOOK="optional"
DECLARATIVE_REQUIRED="always"
OPENGL_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="MathML-based graph calculator for KDE"
HOMEPAGE="http://www.kde.org/applications/education/kalgebra
http://edu.kde.org/kalgebra"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep analitza opengl?)
	$(add_kdebase_dep libkdeedu)
	opengl? ( virtual/glu )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with opengl OpenGL)
	)

	kde4-base_src_configure
}

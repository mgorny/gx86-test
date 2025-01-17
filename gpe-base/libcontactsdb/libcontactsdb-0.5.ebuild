# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

GPE_TARBALL_SUFFIX="bz2"

inherit gpe

DESCRIPTION="Database access library for GPE calendar"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE="doc"
GPE_DOCS="ChangeLog"
GPECONF="${GPECONF} $(use_enable doc gtk-doc)"

RDEPEND="${RDEPEND}
	gpe-base/libgpepimc
	=dev-db/sqlite-2.8*"

DEPEND="${DEPEND}
	${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.2 )
	dev-util/gtk-doc-am"

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit distutils-r1 fdo-mime versionator

DESCRIPTION="A Python-extensible molecular graphics system"
HOMEPAGE="http://www.pymol.org/"
SRC_URI="
	http://dev.gentoo.org/~jlec/distfiles/${PN}-1.7.0.0.png.xz
	http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz
"
#	mirror://sourceforge/project/${PN}/${PN}/$(get_version_component_range 1-2)/${PN}-v${PV}.tar.bz2

LICENSE="PSF-2.2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="apbs web"

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pmw[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	media-libs/freetype:2
	media-libs/glew
	media-libs/libpng
	media-video/mpeg-tools
	sys-libs/zlib
	media-libs/freeglut
	apbs? (
		sci-chemistry/apbs
		sci-chemistry/pdb2pqr
		sci-chemistry/pymol-apbs-plugin[${PYTHON_USEDEP}]
	)
	web? ( !dev-python/webpy[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P}/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-fix-broken-label-scaling-on-Linux.patch
)

python_prepare_all() {
	sed \
		-e "s:\"/usr:\"${EPREFIX}/usr:g" \
		-e "/ext_comp_args/s:=\[.*\]$:= \[\]:g" \
		-e "/import/s:argparse:argparseX:g" \
		-i setup.py || die

	rm ./modules/pmg_tk/startup/apbs_tools.py || die

	sed \
		-e "s:/opt/local:${EPREFIX}/usr:g" \
		-e '/ext_comp_args/s:\[.*\]:[]:g' \
		-i setup.py || die

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install --pymol-path="${EPREFIX}/usr/share/pymol"
}

python_install_all() {
	distutils-r1_python_install_all

	python_export python2_7 EPYTHON

	# These environment variables should not go in the wrapper script, or else
	# it will be impossible to use the PyMOL libraries from Python.
	cat >> "${T}"/20pymol <<- EOF
		PYMOL_PATH="$(python_get_sitedir)/${PN}"
		PYMOL_DATA="${EPREFIX}/usr/share/pymol/data"
		PYMOL_SCRIPTS="${EPREFIX}/usr/share/pymol/scripts"
	EOF

	doenvd "${T}"/20pymol

	newicon "${WORKDIR}"/${PN}-1.7.0.0.png ${PN}.png
	make_desktop_entry pymol PyMol ${PN} "Graphics;Education;Science;Chemistry" "MimeType=chemical/x-pdb;"

	if ! use web; then
		rm -rf "${D}/$(python_get_sitedir)/web" || die
	fi

	rm -f "${ED}"/usr/share/${PN}/LICENSE || die
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

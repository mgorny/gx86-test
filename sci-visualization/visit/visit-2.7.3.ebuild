# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="A software that delivers parallel interactive visualizations"
HOMEPAGE="https://wci.llnl.gov/codes/visit/home.html"
SRC_URI="http://portal.nersc.gov/svn/visit/trunk/releases/${PV}/${PN}${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cgns debug hdf5 netcdf silo tcmalloc threads"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	tcmalloc? ( dev-util/google-perftools )
	cgns? ( sci-libs/cgnslib )
	hdf5? ( sci-libs/hdf5 )
	netcdf? ( sci-libs/netcdf )
	silo? ( sci-libs/silo )
	>=sci-libs/vtk-6.0.0[imaging,python,rendering,${PYTHON_USEDEP}]
	sys-libs/zlib"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}${PV}/src"
PATCHES=(
	"${FILESDIR}/${P}-findpython.patch"
	"${FILESDIR}/${P}-findsilo.patch"
	"${FILESDIR}/${P}-findvtk.patch"
	"${FILESDIR}/${P}-vtklibs.patch"
	"${FILESDIR}/${P}-dont_symlink_visit_dir.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/opt/visit
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_DIR="${EPREFIX}/usr"
		-DVISIT_PYTHON_SKIP_INSTALL=true
		-DVISIT_VTK_SKIP_INSTALL=true
		-DQT_BIN="${EPREFIX}/usr/bin"
		-DVISIT_ZLIB_DIR="${EPREFIX}/usr"
		$(cmake-utils_use threads VISIT_THREAD)
	)
	if use hdf5; then
		mycmakeargs+=( -DHDF5_DIR="${EPREFIX}/usr" )
	fi
	if use tcmalloc; then
		mycmakeargs+=( -DTCMALLOC_DIR="${EPREFIX}/usr" )
	fi
	if use cgns; then
		mycmakeargs+=( -DCGNS_DIR="${EPREFIX}/usr" )
	fi
	if use silo; then
		mycmakeargs+=( -DSILO_DIR="${EPREFIX}/usr" )
	fi
	if use netcdf; then
		mycmakeargs+=( -DNETCDF_DIR="${EPREFIX}/usr" )
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	PACKAGES_DIR="${ROOT}opt/visit/${PV}/linux-$(arch)/lib/site-packages"
	cd "${ED}${PACKAGES_DIR}"
	for i in *; do
		dosym "${PACKAGES_DIR}/${i}" "$(python_get_sitedir)/$i"
	done

	cat > "${T}"/99visit <<- EOF
		PATH=${EPREFIX}/opt/visit/bin
		LDPATH=${EPREFIX}/opt/visit/${PV}/linux-$(arch)/lib/
	EOF
	doenvd "${T}"/99visit
}

pkg_postinst () {
	ewarn "Remember to run "
	ewarn "env-update && source /etc/profile"
	ewarn "if you want to use visit in already opened session"
}
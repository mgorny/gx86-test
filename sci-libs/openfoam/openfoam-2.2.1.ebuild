# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit eutils versionator multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-2)
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Open Field Operation and Manipulation - CFD Simulation Toolbox"
HOMEPAGE="http://www.openfoam.org"
SRC_URI="http://downloads.sourceforge.net/foam/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="2.2"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples opendx src"

RDEPEND="!=sci-libs/openfoam-bin-${MY_PV}*
	!=sci-libs/openfoam-kernel-${MY_PV}*
	!=sci-libs/openfoam-meta-${MY_PV}*
	!=sci-libs/openfoam-solvers-${MY_PV}*
	!=sci-libs/openfoam-utilities-${MY_PV}*
	!=sci-libs/openfoam-wmake-${MY_PV}*
	sci-libs/parmetis
	sci-libs/parmgridgen
	sci-libs/scotch
	virtual/mpi
	opendx? ( sci-visualization/opendx )"
DEPEND="${DEPEND}
	doc? ( app-doc/doxygen[dot] )"

S=${WORKDIR}/${MY_P}
INSDIR="/usr/$(get_libdir)/${MY_PN}/${MY_P}"

pkg_setup() {
	# just to be sure the right profile is selected (gcc-config)
	if ! version_is_at_least 4.3 $(gcc-version) ; then
		die "${PN} requires >=sys-devel/gcc-4.3 to compile."
	fi

	elog
	elog "In order to use ${MY_PN} you should add the following line to ~/.bashrc :"
	elog
	elog "alias startOF$(delete_all_version_separators ${MY_PV})='source ${INSDIR}/etc/bashrc'"
	elog
	elog "And everytime you want to use OpenFOAM you have to execute startOF$(delete_all_version_separators ${MY_PV})"
	ewarn
	ewarn "FoamX is deprecated since ${MY_PN}-1.5! "
	ewarn
}

src_configure() {
	if has_version sys-cluster/mpich2 ; then
		export WM_MPLIB=MPICH
	elif has_version sys-cluster/openmpi ; then
		export WM_MPLIB=OPENMPI
	else
		die "You need one of the following mpi implementations: openmpi or mpich2"
	fi

	sed -i -e "s|WM_MPLIB:=OPENMPI|WM_MPLIB:="${WM_MPLIB}"|" etc/bashrc
	sed -i -e "s|setenv WM_MPLIB OPENMPI|setenv WM_MPLIB "${WM_MPLIB}"|" etc/cshrc

	sed -i -e "s|^foamInstall=\$HOME|foamInstall=/usr/$(get_libdir)|" etc/bashrc
	sed -i -e "s|^set foamInstall = \$HOME|set foamInstall = /usr/$(get_libdir)|" etc/cshrc
}

src_compile() {

	WM_NCOMPPROCS=`echo $MAKEOPTS | sed 's/-j\([0-9][0-9]*\)/\1/'`
	if [ -n "$WM_NCOMPPROCS" ] ; then
		export WM_NCOMPPROCS
	else
		export WM_NCOMPPROCS=1
	fi
	elog "Building on $WM_NCOMPPROCS cores"

	export FOAM_INST_DIR=${WORKDIR}
	source etc/bashrc

	find wmake -name dirToString | xargs rm -rf
	find wmake -name wmkdep | xargs rm -rf

	if use doc ; then
		./Allwmake doc || die "could not build"
	else
		./Allwmake || die "could not build"
	fi
}

src_test() {
	cd bin
	./foamInstallationTest
}

src_install() {
	insinto ${INSDIR}
	doins -r etc

	use examples && doins -r tutorials

	use src && doins -r src

	insopts -m0755
	doins -r bin applications platforms wmake

	dodoc README.html doc/Guides-a4/*.pdf

	if use doc ; then
		dohtml -r doc/Doxygen
	fi
}

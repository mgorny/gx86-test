# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3,3_4} )

inherit autotools-utils flag-o-matic python-r1

DESCRIPTION="POSIX 1003.1e capabilities"
HOMEPAGE="http://people.redhat.com/sgrubb/libcap-ng/"
SRC_URI="http://people.redhat.com/sgrubb/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~arm-linux ~x86-linux"
IUSE="python static-libs"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	python? ( >=dev-lang/swig-2 )"

src_prepare() {
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die

	autotools-utils_src_prepare

	use sparc && replace-flags -O? -O0
}

src_configure() {
	local myeconfargs=(
		--without-python
	)

	# set up the library build
	autotools-utils_src_configure

	if use python; then
		python_parallel_foreach_impl \
			autotools-utils_src_configure --with-python
	fi
}

src_compile() {
	autotools-utils_src_compile

	if use python; then
		python_compile() {
			local CFLAGS=${CFLAGS}

			python_is_python3 || CFLAGS+=" -fno-strict-aliasing"

			emake "${@}" \
				-C "${BUILD_DIR}"/bindings/python
		}

		# help build system find the right objects
		python_foreach_impl python_compile \
			VPATH="${BUILD_DIR}"/bindings/python \
			LIBS="${BUILD_DIR}"/src/libcap-ng.la
	fi
}

src_test() {
	if [[ "${EUID}" -eq 0 ]]; then
		ewarn "Skipping tests due to root permissions."
		return
	fi

	autotools-utils_src_test

	if use python; then
		python_foreach_impl \
			autotools-utils_src_compile -C bindings/python check \
			VPATH="${BUILD_DIR}"/bindings/python:"${S}"/bindings/python/test
	fi
}

src_install() {
	autotools-utils_src_install

	if use python; then
		python_foreach_impl \
			autotools-utils_src_install -C bindings/python \
			VPATH="${BUILD_DIR}"/bindings/python
	fi
}

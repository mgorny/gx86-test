# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy pypy2_0 )
inherit eutils multilib pax-utils python-any-r1 versionator

BINHOST="http://pypy.aliceinwire.net/pypy-bin/"

DESCRIPTION="A fast, compliant alternative implementation of the Python language (binary package)"
HOMEPAGE="http://pypy.org/"
SRC_URI="https://www.bitbucket.org/pypy/pypy/downloads/pypy-${PV}-src.tar.bz2
	amd64? (
		jit? ( shadowstack? (
			${BINHOST}/${P}-amd64+bzip2+jit+ncurses+shadowstack.tar.xz
				-> ${P}-r1-amd64+bzip2+jit+ncurses+shadowstack.tar.xz
		) )
		jit? ( !shadowstack? (
			${BINHOST}/${P}-amd64+bzip2+jit+ncurses.tar.xz
				-> ${P}-r1-amd64+bzip2+jit+ncurses.tar.xz
		) )
		!jit? ( !shadowstack? (
			${BINHOST}/${P}-amd64+bzip2+ncurses.tar.xz
				-> ${P}-r1-amd64+bzip2+ncurses.tar.xz
		) )
	)
	x86? (
		sse2? (
			jit? ( shadowstack? (
				${BINHOST}/${P}-x86+bzip2+jit+ncurses+shadowstack+sse2.tar.xz
					-> ${P}-r1-x86+bzip2+jit+ncurses+shadowstack+sse2.tar.xz
			) )
			jit? ( !shadowstack? (
				${BINHOST}/${P}-x86+bzip2+jit+ncurses+sse2.tar.xz
					-> ${P}-r1-x86+bzip2+jit+ncurses+sse2.tar.xz
			) )
			!jit? ( !shadowstack? (
				${BINHOST}/${P}-x86+bzip2+ncurses+sse2.tar.xz
					-> ${P}-r1-x86+bzip2+ncurses+sse2.tar.xz
			) )
		)
		!sse2? (
			!jit? ( !shadowstack? (
				${BINHOST}/${P}-x86+bzip2+ncurses.tar.xz
					-> ${P}-r1-x86+bzip2+ncurses.tar.xz
			) )
		)
	)"

# Supported variants
REQUIRED_USE="!jit? ( !shadowstack )
	x86? ( !sse2? ( !jit !shadowstack ) )"

LICENSE="MIT"
SLOT="0/$(get_version_component_range 1-2 ${PV})"
KEYWORDS="~amd64 ~x86"
IUSE="doc +jit shadowstack sqlite sse2 test tk"

# yep, world would be easier if people started filling subslots...
RDEPEND="
	app-arch/bzip2:0
	dev-libs/expat:0
	dev-libs/libffi:0
	dev-libs/openssl:0
	sys-libs/glibc:2.2
	sys-libs/ncurses:5
	sys-libs/zlib:0
	sqlite? ( dev-db/sqlite:3 )
	tk? ( dev-lang/tk:0 )
	!dev-python/pypy:0"
DEPEND="app-arch/xz-utils
	doc? ( dev-python/sphinx )
	test? ( ${RDEPEND} )"
PDEPEND="app-admin/python-updater"

S=${WORKDIR}/pypy-${PV}-src

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/1.9-scripts-location.patch"
	epatch "${FILESDIR}/1.9-distutils.unixccompiler.UnixCCompiler.runtime_library_dir_option.patch"
	epatch "${FILESDIR}/2.1-distutils-fix_handling_of_executables_and_flags.patch"

	epatch_user
}

src_compile() {
	# Tadaam! PyPy compiled!
	mv "${WORKDIR}"/${P}*/pypy-c . || die
	mv "${WORKDIR}"/${P}*/include/*.h include/ || die
	mv pypy/module/cpyext/include/*.h include/ || die

	use doc && emake -C pypy/doc/ html
	#needed even without jit :( also needed in both compile and install phases
	pax-mark m pypy-c
}

src_test() {
	# (unset)
	local -x PYTHONDONTWRITEBYTECODE

	./pypy-c ./pypy/test_all.py --pypy=./pypy-c lib-python || die
}

src_install() {
	einfo "Installing PyPy ..."
	insinto "/usr/$(get_libdir)/pypy"
	doins -r include lib_pypy lib-python pypy-c
	fperms a+x ${INSDESTTREE}/pypy-c
	#needed even without jit :(
	pax-mark m "${ED%/}${INSDESTTREE}/pypy-c"
	dosym ../$(get_libdir)/pypy/pypy-c /usr/bin/pypy
	dodoc README.rst

	if ! use sqlite; then
		rm -r "${ED%/}${INSDESTTREE}"/lib-python/*2.7/sqlite3 \
			"${ED%/}${INSDESTTREE}"/lib_pypy/_sqlite3.py \
			"${ED%/}${INSDESTTREE}"/lib-python/*2.7/test/test_sqlite.py || die
	fi
	if ! use tk; then
		rm -r "${ED%/}${INSDESTTREE}"/lib-python/*2.7/{idlelib,lib-tk} \
			"${ED%/}${INSDESTTREE}"/lib_pypy/_tkinter \
			"${ED%/}${INSDESTTREE}"/lib-python/*2.7/test/test_{tcl,tk,ttk*}.py || die
	fi

	# Install docs
	use doc && dohtml -r pypy/doc/_build/html/

	einfo "Generating caches and byte-compiling ..."

	python_export pypy EPYTHON PYTHON PYTHON_SITEDIR
	local PYTHON=${ED%/}${INSDESTTREE}/pypy-c

	echo "EPYTHON='${EPYTHON}'" > epython.py
	python_domodule epython.py

	# Note: call portage helpers before this line.
	# PYTHONPATH confuses them and will result in random failures.

	local -x PYTHONPATH="${ED%/}${INSDESTTREE}/lib_pypy:${ED%/}${INSDESTTREE}/lib-python/2.7"

	# Generate Grammar and PatternGrammar pickles.
	"${PYTHON}" -c "import lib2to3.pygram, lib2to3.patcomp; lib2to3.patcomp.PatternCompiler()" \
		|| die "Generation of Grammar and PatternGrammar pickles failed"

	# Generate cffi cache
	"${PYTHON}" -c "import _curses" || die "Failed to import _curses (cffi)"
	"${PYTHON}" -c "import syslog" || die "Failed to import syslog (cffi)"
	if use sqlite; then
		"${PYTHON}" -c "import _sqlite3" || die "Failed to import _sqlite3 (cffi)"
	fi
	if use tk; then
		"${PYTHON}" -c "import _tkinter" || die "Failed to import _tkinter (cffi)"
	fi

	# compile the installed modules
	python_optimize "${ED%/}${INSDESTTREE}"
}

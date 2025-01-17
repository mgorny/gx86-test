# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )
DISTUTILS_SINGLE_IMPL=true

inherit distutils-r1 readme.gentoo virtualx

DESCRIPTION="The highly caffeinated git GUI"
HOMEPAGE="http://git-cola.github.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="
	dev-python/jsonpickle[${PYTHON_USEDEP}]
	dev-python/pyinotify[${PYTHON_USEDEP}]
	dev-python/PyQt4[${PYTHON_USEDEP}]
	dev-vcs/git"
DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
	sys-devel/gettext
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		sys-apps/net-tools
		)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.3-disable-tests.patch
	"${FILESDIR}"/${PN}-1.9.1-system-ssh-askpass.patch
	)

pkg_pretend() {
	if use test && [[ -z "$(hostname -d)" ]] ; then
		die "Test will fail if no domain is set"
	fi
}

python_prepare_all() {
	rm share/git-cola/bin/*askpass* || die

	# unfinished translate framework
	rm test/i18n_test.py || die

	# don't install docs into wrong location
	sed -i \
		-e '/doc/d' \
		setup.py || die "sed failed"

	sed -i \
		-e  "s|'doc', 'git-cola'|'doc', '${PF}'|" \
		cola/resources.py || die "sed failed"

	distutils-r1_python_prepare_all
}

python_compile_all() {
	cd share/doc/${PN}/
	if use doc ; then
		emake all
	else
		sed \
			-e '/^install:/s:install-html::g' \
			-e '/^install:/s:install-man::g' \
			-i Makefile || die
	fi
}

src_install() {
	distutils-r1_src_install
}

python_install_all() {
	cd share/doc/${PN}/ || die
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}/usr/share/doc/${PF}" \
		prefix="${EPREFIX}/usr" \
		install

	python_fix_shebang "${D}/usr/share/git-cola/bin/git-xbase"
	python_optimize "${D}/usr/share/git-cola/lib/cola"

	if ! use doc ; then
		HTML_DOCS=( "${FILESDIR}"/index.html )
	fi

	distutils-r1_python_install_all
	readme.gentoo_create_doc
	docompress /usr/share/doc/${PF}/git-cola.txt
}

python_test() {
	PYTHONPATH="${S}:${S}/build/lib:${PYTHONPATH}" LC_ALL="C" \
		VIRTUALX_COMMAND="nosetests --verbose --with-doctest \
		--with-id --exclude=jsonpickle --exclude=json" \
		virtualmake
}

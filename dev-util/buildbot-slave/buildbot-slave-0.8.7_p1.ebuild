# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
DISTUTILS_SRC_TEST="trial buildslave"
DISTUTILS_DISABLE_TEST_DEPENDENCY="1"

inherit distutils readme.gentoo user

DESCRIPTION="BuildBot Slave Daemon"
HOMEPAGE="http://trac.buildbot.net/ http://code.google.com/p/buildbot/ http://pypi.python.org/pypi/buildbot-slave"

MY_PV="${PV/_p/p}"
MY_P="${PN}-${MY_PV}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-interix ~amd64-linux"
IUSE="test"

RDEPEND="dev-python/setuptools
	dev-python/twisted-core
	!!<dev-util/buildbot-0.8.1
	!<dev-util/buildbot-0.8.3"
DEPEND="${RDEPEND}
	test? ( dev-python/mock )"

PYTHON_MODNAME="buildslave"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python_pkg_setup
	enewuser buildbot

	DOC_CONTENTS="The \"buildbot\" user and the \"buildslave\" init script has been added
		to support starting buildslave through Gentoo's init system. To use this,
		set up your build slave following the documentation, make sure the
		resulting directories are owned by the \"buildbot\" user and point
		\"${ROOT}etc/conf.d/buildslave\" at the right location.  The scripts can
		run as a different user if desired. If you need to run more than one
		build slave, just copy the scripts."
}

src_install() {
	distutils_src_install

	doman docs/buildslave.1

	newconfd "${FILESDIR}/buildslave.confd" buildslave
	newinitd "${FILESDIR}/buildslave.initd" buildslave

	readme.gentoo_create_doc
}

pkg_postinst() {
	distutils_pkg_postinst
	readme.gentoo_print_elog
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="Backend data caching and persistence daemon for Graphite"
HOMEPAGE="http://graphite.wikidot.com/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	~dev-python/twisted-core-12.3.0[${PYTHON_USEDEP}]
	dev-python/whisper[${PYTHON_USEDEP}]
	dev-python/txAMQP[${PYTHON_USEDEP}]"

PATCHES=(
	# Do not install the configuration and data files. We install them
	# somewhere sensible by hand.
	"${FILESDIR}"/${P}-no-data-files.patch
	)

python_prepare_all() {
	# This sets prefix to /opt/graphite. We want FHS-style paths instead.
	rm setup.cfg || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/carbon
	doins conf/*

	dodir /var/log/carbon /var/lib/carbon/{whisper,lists,rrd}

	newinitd "${FILESDIR}"/carbon.initd carbon-cache
	newinitd "${FILESDIR}"/carbon.initd carbon-relay
	newinitd "${FILESDIR}"/carbon.initd carbon-aggregator

	newconfd "${FILESDIR}"/carbon.confd carbon-cache
	newconfd "${FILESDIR}"/carbon.confd carbon-relay
	newconfd "${FILESDIR}"/carbon.confd carbon-aggregator
}

pkg_postinst() {
	einfo 'This ebuild installs carbon into FHS-style paths.'
	einfo 'You will probably have to set GRAPHITE_CONF_DIR to /etc/carbon'
	einfo 'and GRAPHITE_STORAGE_DIR to /var/lib/carbon to make use of this'
	einfo '(see /etc/carbon/carbon.conf.example).'
	einfo ' '
	einfo 'OpenRC init script supports multiple instances !'
	einfo 'Example to run an instance b of carbon-cache :'
	einfo '    ln -s /etc/init.d/carbon-cache /etc/init.d/carbon-cache.b'
	einfo '    cp /etc/conf.d/carbon-cache /etc/conf.d/carbon-cache.b'
}

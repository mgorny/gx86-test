# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7} )
inherit eutils python-single-r1

MY_P="${P/pyicq-t/pyicqt}"
DESCRIPTION="Python based jabber transport for ICQ"
HOMEPAGE="http://code.google.com/p/pyicqt/"
SRC_URI="http://pyicqt.googlecode.com/files/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="webinterface"

DEPEND="net-im/jabber-base"
RDEPEND="${DEPEND}
	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/twisted-words[${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]
	webinterface? ( >=dev-python/nevow-0.4.1[${PYTHON_USEDEP}] )
	virtual/python-imaging[${PYTHON_USEDEP}]"

src_prepare() {
	epatch "${FILESDIR}/${P}-python26-warnings.diff"
	epatch "${FILESDIR}/${P}-pillow-imaging.patch"
}

src_install() {
	python_moduleinto ${PN}
	cp PyICQt.py ${PN}.py || die
	python_domodule ${PN}.py data tools src

	insinto /etc/jabber
	newins config_example.xml ${PN}.xml
	fperms 600 /etc/jabber/${PN}.xml
	fowners jabber:jabber /etc/jabber/${PN}.xml
	fperms 755 "$(python_get_sitedir)/${PN}/${PN}.py"
	sed -i \
		-e "s:<spooldir>[^\<]*</spooldir>:<spooldir>/var/spool/jabber</spooldir>:" \
		-e "s:<pid>[^\<]*</pid>:<pid>/var/run/jabber/${PN}.pid</pid>:" \
		"${ED}/etc/jabber/${PN}.xml"

	newinitd "${FILESDIR}/${PN}-0.8-initd-r1" ${PN}
	sed -i -e "s:INSPATH:$(python_get_sitedir)/${PN}:" "${ED}/etc/init.d/${PN}"
	python_fix_shebang "${D}$(python_get_sitedir)/${PN}"
}

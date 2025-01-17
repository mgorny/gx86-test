# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

DESCRIPTION="JavaScript display engine for LaTeX, MathML and AsciiMath"
HOMEPAGE="http://www.mathjax.org/"
SRC_URI="https://github.com/mathjax/MathJax/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RESTRICT="binchecks"

S=${WORKDIR}/MathJax-${PV}

make_webconf() {
	# web server config file - should we really do this?
	cat > $1 <<-EOF
		Alias /MathJax/ ${EPREFIX}${webinstalldir}/
		Alias /mathjax/ ${EPREFIX}${webinstalldir}/

		<Directory ${EPREFIX}${webinstalldir}>
			Options None
			AllowOverride None
			Order allow,deny
			Allow from all
		</Directory>
	EOF
}

src_prepare() {
	find . -name .gitignore -delete || die
}

src_install() {
	dodoc README*
	use doc && dohtml -r docs/html/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r test/*
	fi
	rm -rf test docs LICENSE README* || die

	webinstalldir=/usr/share/${PN}
	insinto ${webinstalldir}
	doins -r *

	make_webconf MathJax.conf
	insinto /etc/httpd/conf.d
	doins MathJax.conf
}

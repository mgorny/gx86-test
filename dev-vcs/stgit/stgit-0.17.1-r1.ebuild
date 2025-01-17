# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Manage a stack of patches using GIT as a backend"
HOMEPAGE="http://www.procode.org/stgit/"
UPSTREAM_VER=0
[[ -n ${UPSTREAM_VER} ]] && \
	UPSTREAM_PATCHSET_URI="http://dev.gentoo.org/~dlan/distfiles/${P}-upstream-patches-${UPSTREAM_VER}.tar.xz"

SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz
	${UPSTREAM_PATCHSET_URI}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND=">=dev-vcs/git-1.6.3.3"

# NOTE: It seems to be quite important which asciidoc version to use.
# So keep an eye on it for the future.
DEPEND="${RDEPEND}
	doc? (
		app-text/asciidoc
		app-text/xmlto
		dev-lang/perl
	)"

PATCHES=(
	"${FILESDIR}/${PN}-0.16-man-linkfix.patch"
)

pkg_setup() {
	if ! use doc; then
		echo
		ewarn "Manpages will not be built and installed."
		ewarn "Enable the 'doc' useflag, if you want them."
		echo
	fi
}

python_prepare_all() {
	# Upstream's patchset
	if [[ -n ${UPSTREAM_VER} ]]; then
		EPATCH_SUFFIX="patch" \
		EPATCH_FORCE="yes" \
			epatch "${WORKDIR}"/patches-upstream
	fi

	# this will be a noop, as we are working with a tarball,
	# but throws git errors --> just get rid of it
	sed -i -e 's/version\.write_builtin_version()//' setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake DESTDIR="${D}" \
			htmldir="${EPREFIX}/usr/share/doc/${PF}/html/" \
			mandir="${EPREFIX}/usr/share/man/" \
			doc
	fi
}

python_install_all() {
	if use doc; then
		emake DESTDIR="${D}" \
			htmldir="${EPREFIX}/usr/share/doc/${PF}/html/" \
			mandir="${EPREFIX}/usr/share/man/" \
			install-doc install-html
	fi

	distutils-r1_python_install_all

	newbashcomp stgit-completion.bash ${PN}
}

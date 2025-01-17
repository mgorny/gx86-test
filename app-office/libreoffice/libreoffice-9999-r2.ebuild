# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

KDE_REQUIRED="optional"
QT_MINIMAL="4.7.4"
KDE_SCM="git"
CMAKE_REQUIRED="never"

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )
PYTHON_REQ_USE="threads,xml"

# experimental ; release ; old
# Usually the tarballs are moved a lot so this should make
# everyone happy.
DEV_URI="
	http://dev-builds.libreoffice.org/pre-releases/src
	http://download.documentfoundation.org/libreoffice/src/${PV:0:5}/
	http://download.documentfoundation.org/libreoffice/old/${PV}/
"
EXT_URI="http://ooo.itc.hu/oxygenoffice/download/libreoffice"
ADDONS_URI="http://dev-www.libreoffice.org/src/"

BRANDING="${PN}-branding-gentoo-0.8.tar.xz"
# PATCHSET="${P}-patchset-01.tar.xz"

[[ ${PV} == *9999* ]] && SCM_ECLASS="git-2"
inherit base autotools bash-completion-r1 check-reqs eutils java-pkg-opt-2 kde4-base pax-utils python-single-r1 multilib toolchain-funcs flag-o-matic nsplugins ${SCM_ECLASS}
unset SCM_ECLASS

DESCRIPTION="LibreOffice, a full office productivity suite"
HOMEPAGE="http://www.libreoffice.org"
SRC_URI="branding? ( http://dev.gentoo.org/~dilfridge/distfiles/${BRANDING} )"
[[ -n ${PATCHSET} ]] && SRC_URI+=" http://dev.gentooexperimental.org/~scarabeus/${PATCHSET}"

# Split modules following git/tarballs
# Core MUST be first!
# Help is used for the image generator
MODULES="core help"
# Only release has the tarballs
if [[ ${PV} != *9999* ]]; then
	for i in ${DEV_URI}; do
		for mod in ${MODULES}; do
			if [[ ${mod} == core ]]; then
				SRC_URI+=" ${i}/${P}.tar.xz"
			else
				SRC_URI+=" ${i}/${PN}-${mod}-${PV}.tar.xz"
			fi
		done
		unset mod
	done
	unset i
fi
unset DEV_URI

# Really required addons
# These are bundles that can't be removed for now due to huge patchsets.
# If you want them gone, patches are welcome.
ADDONS_SRC+=" ${ADDONS_URI}/d62650a6f908e85643e557a236ea989c-vigra1.6.0.tar.gz"
ADDONS_SRC+=" ${ADDONS_URI}/1f24ab1d39f4a51faf22244c94a6203f-xmlsec1-1.2.14.tar.gz" # modifies source code
ADDONS_SRC+=" java? ( ${ADDONS_URI}/17410483b5b5f267aa18b7e00b65e6e0-hsqldb_1_8_0.zip )"
ADDONS_SRC+=" libreoffice_extensions_wiki-publisher? ( ${ADDONS_URI}/a7983f859eafb2677d7ff386a023bc40-xsltml_2.1.2.zip )" # no release for 8 years, should we package it?
ADDONS_SRC+=" libreoffice_extensions_scripting-javascript? ( ${ADDONS_URI}/798b2ffdc8bcfe7bca2cf92b62caf685-rhino1_5R5.zip )" # Does not build with 1.6 rhino at all
ADDONS_SRC+=" libreoffice_extensions_scripting-javascript? ( ${ADDONS_URI}/35c94d2df8893241173de1d16b6034c0-swingExSrc.zip )" # requirement of rhino
ADDONS_SRC+=" odk? ( http://download.go-oo.org/extern/185d60944ea767075d27247c3162b3bc-unowinreg.dll )" # not packageable
SRC_URI+=" ${ADDONS_SRC}"

unset ADDONS_URI
unset EXT_URI
unset ADDONS_SRC

IUSE="bluetooth +branding +cups dbus debug eds firebird gnome gstreamer +gtk
gtk3 jemalloc kde mysql odk opengl postgres telepathy test +vba vlc +webdav"

LO_EXTS="nlpsolver scripting-beanshell scripting-javascript wiki-publisher"
# Unpackaged separate extensions:
# diagram: lo has 0.9.5 upstream is weirdly patched 0.9.4 -> wtf?
# hunart: only on ooo extensions -> fubared download path somewhere on sf
# numbertext, typo, validator, watch-window: ^^
# oooblogger: no homepage or anything
# Extensions that need extra work:
for lo_xt in ${LO_EXTS}; do
	IUSE+=" libreoffice_extensions_${lo_xt}"
done
unset lo_xt

LICENSE="|| ( LGPL-3 MPL-1.1 )"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	${PYTHON_DEPS}
	app-arch/zip
	app-arch/unzip
	>=app-text/hunspell-1.3.2-r3
	app-text/mythes
	>=app-text/libabw-0.1.0
	>=app-text/libexttextcat-3.2
	>=app-text/libebook-0.1.1
	app-text/libetonyek
	app-text/liblangtag
	app-text/libmspub
	>=app-text/libmwaw-0.2
	>=app-text/libodfgen-0.0.3
	app-text/libwpd:0.10[tools]
	app-text/libwpg:0.3
	>=app-text/libwps-0.3.0
	>=app-text/poppler-0.16:=[xpdf-headers(+),cxx]
	>=dev-cpp/clucene-2.3.3.4-r2
	dev-cpp/libcmis:0.4
	dev-db/unixODBC
	>=dev-libs/boost-1.46:=
	dev-libs/expat
	>=dev-libs/hyphen-2.7.1
	>=dev-libs/icu-4.8.1.1:=
	>=dev-libs/libatomic_ops-7.2d
	>=dev-libs/liborcus-0.7.0:=
	>=dev-libs/nspr-4.8.8
	>=dev-libs/nss-3.12.9
	>=dev-lang/perl-5.0
	>=dev-libs/openssl-1.0.0d:0
	>=dev-libs/redland-1.0.16
	media-gfx/graphite2
	>=media-libs/fontconfig-2.8.0
	media-libs/freetype:2
	>=media-libs/glew-1.10
	>=media-libs/harfbuzz-0.9.18:=[icu(+)]
	media-libs/lcms:2
	>=media-libs/libpng-1.4
	>=media-libs/libcdr-0.0.5
	media-libs/libfreehand
	media-libs/libvisio
	>=net-misc/curl-7.21.4
	net-nds/openldap
	sci-mathematics/lpsolve
	virtual/jpeg:0
	>=x11-libs/cairo-1.10.0[X]
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	bluetooth? ( net-wireless/bluez )
	cups? ( net-print/cups )
	dbus? ( >=dev-libs/dbus-glib-0.92 )
	eds? ( gnome-extra/evolution-data-server )
	firebird? ( >=dev-db/firebird-2.5 )
	gnome? ( gnome-base/gconf:2 )
	gtk? (
		x11-libs/gdk-pixbuf[X]
		>=x11-libs/gtk+-2.24:2
	)
	gtk3? ( >=x11-libs/gtk+-3.2:3 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	jemalloc? ( dev-libs/jemalloc )
	libreoffice_extensions_scripting-beanshell? ( >=dev-java/bsh-2.0_beta4 )
	libreoffice_extensions_scripting-javascript? ( dev-java/rhino:1.6 )
	libreoffice_extensions_wiki-publisher? (
		dev-java/commons-codec:0
		dev-java/commons-httpclient:3
		dev-java/commons-lang:2.1
		dev-java/commons-logging:0
		dev-java/tomcat-servlet-api:3.0
	)
	mysql? ( >=dev-db/mysql-connector-c++-1.1.0 )
	opengl? (
		virtual/glu
		virtual/opengl
	)
	postgres? ( >=dev-db/postgresql-base-9.0[kerberos] )
	telepathy? (
		dev-libs/glib:2
		>=net-libs/telepathy-glib-0.18.0
		>=x11-libs/gtk+-2.24:2
	)
	webdav? ( net-libs/neon )
"

RDEPEND="${COMMON_DEPEND}
	!app-office/libreoffice-bin
	!app-office/libreoffice-bin-debug
	!<app-office/openoffice-bin-3.4.0-r1
	!app-office/openoffice
	media-fonts/libertine-ttf
	media-fonts/liberation-fonts
	media-fonts/urw-fonts
	java? ( >=virtual/jre-1.6 )
	vlc? ( media-video/vlc )
"

if [[ ${PV} != *9999* ]]; then
	PDEPEND="~app-office/libreoffice-l10n-${PV}"
else
	# Translations are not reliable on live ebuilds
	# rather force people to use english only.
	PDEPEND="!app-office/libreoffice-l10n"
fi

# FIXME: cppunit should be moved to test conditional
#        after everything upstream is under gbuild
#        as dmake execute tests right away
DEPEND="${COMMON_DEPEND}
	>=dev-libs/libxml2-2.7.8
	dev-libs/libxslt
	dev-perl/Archive-Zip
	dev-util/cppunit
	>=dev-util/gperf-3
	dev-util/intltool
	>=dev-util/mdds-0.10.3:=
	media-libs/glm
	net-misc/npapi-sdk
	>=sys-apps/findutils-4.4.2
	sys-devel/bison
	sys-apps/coreutils
	sys-devel/flex
	sys-devel/gettext
	>=sys-devel/make-3.82
	sys-devel/ucpp
	sys-libs/zlib
	virtual/pkgconfig
	x11-libs/libXt
	x11-libs/libXtst
	x11-proto/randrproto
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xproto
	java? (
		>=virtual/jdk-1.6
		>=dev-java/ant-core-1.7
	)
	odk? ( >=app-doc/doxygen-1.8.4 )
	test? ( dev-util/cppunit )
"

PATCHES=(
	# not upstreamable stuff
	"${FILESDIR}/${PN}-3.7-system-pyuno.patch"
)

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	bluetooth? ( dbus )
	gnome? ( gtk )
	eds? ( gnome )
	telepathy? ( gtk )
	libreoffice_extensions_nlpsolver? ( java )
	libreoffice_extensions_scripting-beanshell? ( java )
	libreoffice_extensions_scripting-javascript? ( java )
	libreoffice_extensions_wiki-publisher? ( java )
"

CHECKREQS_MEMORY="512M"
CHECKREQS_DISK_BUILD="6G"

pkg_pretend() {
	local pgslot

	if [[ ${MERGE_TYPE} != binary ]]; then
		check-reqs_pkg_pretend

		if [[ $(gcc-major-version) -lt 4 ]] || \
				 ( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 6 ]] ) \
				; then
			eerror "Compilation with gcc older than 4.6 is not supported"
			die "Too old gcc found."
		fi
	fi

	# Ensure pg version but we have to be sure the pg is installed (first
	# install on clean system)
	if use postgres && has_version dev-db/postgresql-base; then
		 pgslot=$(postgresql-config show)
		 if [[ ${pgslot//.} < 90 ]] ; then
			eerror "PostgreSQL slot must be set to 9.0 or higher."
			eerror "    postgresql-config set 9.0"
			die "PostgreSQL slot is not set to 9.0 or higher."
		 fi
	fi
}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	kde4-base_pkg_setup
	python-single-r1_pkg_setup

	[[ ${MERGE_TYPE} != binary ]] && check-reqs_pkg_setup
}

src_unpack() {
	local mod mod2 dest tmplfile tmplname mypv

	[[ -n ${PATCHSET} ]] && unpack ${PATCHSET}
	use branding && unpack "${BRANDING}"

	if [[ ${PV} != *9999* ]]; then
		unpack "${P}.tar.xz"
		for mod in ${MODULES}; do
			[[ ${mod} == core ]] && continue
			unpack "${PN}-${mod}-${PV}.tar.xz"
		done
	else
		for mod in ${MODULES}; do
			mypv=${PV/.9999}
			[[ ${mypv} != ${PV} ]] && EGIT_BRANCH="${PN}-${mypv/./-}"
			EGIT_PROJECT="${PN}/${mod}"
			EGIT_SOURCEDIR="${WORKDIR}/${P}"
			[[ ${mod} != core ]] && EGIT_SOURCEDIR="${WORKDIR}/${PN}-${mod}-${PV}"
			EGIT_REPO_URI="git://anongit.freedesktop.org/${PN}/${mod}"
			EGIT_NOUNPACK="true"
			git-2_src_unpack
			if [[ ${mod} != core ]]; then
				mod2=${mod}
				# mapping does not match on help
				[[ ${mod} == help ]] && mod2="helpcontent2"
				mkdir -p "${S}/${mod2}/" || die
				mv -n "${WORKDIR}/${PN}-${mod}-${PV}"/* "${S}/${mod2}" || die
				rm -rf "${WORKDIR}/${PN}-${mod}-${PV}"
			fi
		done
		unset EGIT_PROJECT EGIT_SOURCEDIR EGIT_REPO_URI EGIT_BRANCH
	fi
}

src_prepare() {
	# optimization flags
	export GMAKE_OPTIONS="${MAKEOPTS}"
	# System python 2.7 enablement:
	export PYTHON_CFLAGS=$(python_get_CFLAGS)
	export PYTHON_LIBS=$(python_get_LIBS)

	# patchset
	if [[ -n ${PATCHSET} ]]; then
		EPATCH_FORCE="yes" \
		EPATCH_SOURCE="${WORKDIR}/${PATCHSET/.tar.xz/}" \
		EPATCH_SUFFIX="patch" \
		epatch
	fi

	base_src_prepare

	AT_M4DIR="m4" eautoreconf
	# hack in the autogen.sh
	touch autogen.lastrun

	# system pyuno mess
	sed \
		-e "s:%eprefix%:${EPREFIX}:g" \
		-e "s:%libdir%:$(get_libdir):g" \
		-i pyuno/source/module/uno.py \
		-i scripting/source/pyprov/officehelper.py || die
	# sed in the tests
	sed -i \
		-e 's#all : build unitcheck#all : build#g' \
		solenv/gbuild/Module.mk || die
	sed -i \
		-e 's#check: dev-install subsequentcheck#check: unitcheck slowcheck dev-install subsequentcheck#g' \
		-e 's#Makefile.gbuild all slowcheck#Makefile.gbuild all#g' \
		Makefile.in || die

	if use branding; then
		# hack...
		mv -v "${WORKDIR}/branding-intro.png" "${S}/icon-themes/galaxy/brand/intro.png" || die
	fi
}

src_configure() {
	local java_opts
	local internal_libs
	local lo_ext
	local ext_opts
	local jbs=$(sed -ne 's/.*\(-j[[:space:]]*\|--jobs=\)\([[:digit:]]\+\).*/\2/;T;p' <<< "${MAKEOPTS}")

	# recheck that there is some value in jobs
	[[ -z ${jbs} ]] && jbs="1"

	# sane: just sane.h header that is used for scan in writer, not
	#       linked or anything else, worthless to depend on
	# vigra: just uses templates from there
	#        it is serious pain in the ass for packaging
	#        should be replaced by boost::gil if someone interested
	internal_libs+="
		--without-system-sane
		--without-system-vigra
	"

	# libreoffice extensions handling
	for lo_xt in ${LO_EXTS}; do
		if [[ "${lo_xt}" == "scripting-beanshell" || "${lo_xt}" == "scripting-javascript" ]]; then
			ext_opts+=" $(use_enable libreoffice_extensions_${lo_xt} ${lo_xt})"
		else
			ext_opts+=" $(use_enable libreoffice_extensions_${lo_xt} ext-${lo_xt})"
		fi
	done

	if use java; then
		# hsqldb: system one is too new
		java_opts="
			--without-junit
			--without-system-hsqldb
			--with-ant-home="${ANT_HOME}"
			--with-jdk-home=$(java-config --jdk-home 2>/dev/null)
			--with-jvm-path="${EPREFIX}/usr/lib/"
		"

		use libreoffice_extensions_scripting-beanshell && \
			java_opts+=" --with-beanshell-jar=$(java-pkg_getjar bsh bsh.jar)"

		use libreoffice_extensions_scripting-javascript && \
			java_opts+=" --with-rhino-jar=$(java-pkg_getjar rhino-1.6 js.jar)"

		if use libreoffice_extensions_wiki-publisher; then
			java_opts+="
				--with-commons-codec-jar=$(java-pkg_getjar commons-codec commons-codec.jar)
				--with-commons-httpclient-jar=$(java-pkg_getjar commons-httpclient-3 commons-httpclient.jar)
				--with-commons-lang-jar=$(java-pkg_getjar commons-lang-2.1 commons-lang.jar)
				--with-commons-logging-jar=$(java-pkg_getjar commons-logging commons-logging.jar)
				--with-servlet-api-jar=$(java-pkg_getjar tomcat-servlet-api-3.0 servlet-api.jar)
			"
		fi
	fi

	# system headers/libs/...: enforce using system packages
	# --enable-cairo: ensure that cairo is always required
	# --enable-graphite: disabling causes build breakages
	# --enable-*-link: link to the library rather than just dlopen on runtime
	# --enable-release-build: build the libreoffice as release
	# --disable-fetch-external: prevent dowloading during compile phase
	# --disable-gnome-vfs: old gnome virtual fs support
	# --disable-kdeab: kde3 adressbook
	# --disable-kde: kde3 support
	# --disable-systray: quickstarter does not actually work at all so do not
	#   promote it
	# --enable-extension-integration: enable any extension integration support
	# --without-{fonts,myspell-dicts,ppsd}: prevent install of sys pkgs
	# --disable-report-builder: too much java packages pulled in without pkgs
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/" \
		--with-system-headers \
		--with-system-libs \
		--with-system-jars \
		--with-system-dicts \
		--enable-cairo-canvas \
		--enable-graphite \
		--enable-largefile \
		--enable-mergelibs \
		--enable-python=system \
		--enable-randr \
		--enable-randr-link \
		--enable-release-build \
		--disable-hardlink-deliver \
		--disable-ccache \
		--disable-crashdump \
		--disable-dependency-tracking \
		--disable-epm \
		--disable-fetch-external \
		--disable-gnome-vfs \
		--disable-gstreamer-0-10 \
		--disable-report-builder \
		--disable-kdeab \
		--disable-kde \
		--disable-online-update \
		--disable-systray \
		--with-alloc=$(use jemalloc && echo "jemalloc" || echo "system") \
		--with-build-version="Gentoo official package" \
		--enable-extension-integration \
		--with-external-dict-dir="${EPREFIX}/usr/share/myspell" \
		--with-external-hyph-dir="${EPREFIX}/usr/share/myspell" \
		--with-external-thes-dir="${EPREFIX}/usr/share/myspell" \
		--with-external-tar="${DISTDIR}" \
		--with-lang="" \
		--with-parallelism=${jbs} \
		--with-system-ucpp \
		--with-vendor="Gentoo Foundation" \
		--with-x \
		--without-fonts \
		--without-myspell-dicts \
		--without-help \
		--with-helppack-integration \
		--without-sun-templates \
		$(use_enable bluetooth sdremote-bluetooth) \
		$(use_enable cups) \
		$(use_enable debug) \
		$(use_enable dbus) \
		$(use_enable eds evolution2) \
		$(use_enable firebird firebird-sdbc) \
		$(use_enable gnome gconf) \
		$(use_enable gnome gio) \
		$(use_enable gnome lockdown) \
		$(use_enable gstreamer) \
		$(use_enable gtk) \
		$(use_enable gtk3) \
		$(use_enable kde kde4) \
		$(use_enable mysql ext-mariadb-connector) \
		$(use_enable odk) \
		$(use_enable opengl) \
		$(use_enable postgres postgresql-sdbc) \
		$(use_enable telepathy) \
		$(use_enable vba) \
		$(use_enable vlc) \
		$(use_enable webdav neon) \
		$(use_with java) \
		$(use_with mysql system-mysql-cppconn) \
		$(use_with odk doxygen) \
		${internal_libs} \
		${java_opts} \
		${ext_opts}
}

src_compile() {
	# hack for offlinehelp, this needs fixing upstream at some point
	# it is broken because we send --without-help
	# https://bugs.freedesktop.org/show_bug.cgi?id=46506
	(
		grep "^export" "${S}/config_host.mk" > "${T}/config_host.mk"
		source "${T}/config_host.mk" 2&> /dev/null

		local path="${WORKDIR}/helpcontent2/source/auxiliary/"
		mkdir -p "${path}" || die

		echo "perl \"${S}/helpcontent2/helpers/create_ilst.pl\" -dir=icon-themes/galaxy/res/helpimg > \"${path}/helpimg.ilst\""
		perl "${S}/helpcontent2/helpers/create_ilst.pl" \
			-dir=icon-themes/galaxy/res/helpimg \
			> "${path}/helpimg.ilst"
		[[ -s "${path}/helpimg.ilst" ]] || ewarn "The help images list is empty, something is fishy, report a bug."
	)

	local target
	use test && target="build" || target="build-nocheck"

	# this is not a proper make script
	make ${target} || die
}

src_test() {
	make unitcheck || die
	make slowcheck || die
}

src_install() {
	# This is not Makefile so no buildserver
	make DESTDIR="${D}" distro-pack-install -o build -o check || die

	# Fix bash completion placement
	newbashcomp "${ED}"/etc/bash_completion.d/libreoffice.sh ${PN}
	rm -rf "${ED}"/etc/

	if use branding; then
		insinto /usr/$(get_libdir)/${PN}/program
		newins "${WORKDIR}/branding-sofficerc" sofficerc
		echo "CONFIG_PROTECT=/usr/$(get_libdir)/${PN}/program/sofficerc" > "${ED}"/etc/env.d/99${PN}
	fi

	# symlink the nsplugin to proper location
	# use gtk && inst_plugin /usr/$(get_libdir)/libreoffice/program/libnpsoplugin.so

	# Hack for offlinehelp, this needs fixing upstream at some point.
	# It is broken because we send --without-help
	# https://bugs.freedesktop.org/show_bug.cgi?id=46506
	insinto /usr/$(get_libdir)/libreoffice/help
	doins xmlhelp/util/*.xsl

	# Remove desktop files for support to old installs that can't parse mime
	rm -rf "${ED}"/usr/share/mimelnk/

	pax-mark -m "${ED}"/usr/$(get_libdir)/libreoffice/program/soffice.bin
	pax-mark -m "${ED}"/usr/$(get_libdir)/libreoffice/program/unopkg.bin
}

pkg_preinst() {
	# Cache updates - all handled by kde eclass for all environments
	kde4-base_pkg_preinst
}

pkg_postinst() {
	kde4-base_pkg_postinst

	use java || \
		ewarn 'If you plan to use lbase application you should enable java or you will get various crashes.'
}

pkg_postrm() {
	kde4-base_pkg_postrm
}

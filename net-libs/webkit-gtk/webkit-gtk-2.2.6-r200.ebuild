# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7} )
GCONF_DEBUG="no"

inherit autotools check-reqs eutils flag-o-matic gnome2 pax-utils python-any-r1 toolchain-funcs versionator virtualx

MY_P="webkitgtk-${PV}"
DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://www.webkitgtk.org/"
SRC_URI="http://www.webkitgtk.org/releases/${MY_P}.tar.xz"

LICENSE="LGPL-2+ BSD"
SLOT="2"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
IUSE="aqua coverage debug +egl +geoloc gles2 +gstreamer +introspection +jit libsecret +opengl spell +webgl"
# bugs 372493, 416331
REQUIRED_USE="
	geoloc? ( introspection )
	introspection? ( gstreamer )
	gles2? ( egl )
	webgl? ( ^^ ( gles2 opengl ) )
	!webgl? ( ?? ( gles2 opengl ) )
"

# use sqlite, svg by default
RDEPEND="
	dev-libs/libxml2:2
	dev-libs/libxslt
	media-libs/harfbuzz:=[icu(+)]
	media-libs/libwebp:=
	virtual/jpeg:0=
	>=media-libs/libpng-1.4:0=
	>=x11-libs/cairo-1.10:=[X]
	>=dev-libs/glib-2.36.0:2
	>=dev-libs/icu-3.8.1-r1:=
	>=net-libs/libsoup-2.42.0:2.4[introspection?]
	dev-db/sqlite:3=
	>=x11-libs/pango-1.30.0.0
	x11-libs/libXrender
	x11-libs/libXt
	>=x11-libs/gtk+-2.24.10:2

	egl? ( media-libs/mesa[egl] )
	geoloc? ( app-misc/geoclue:0 )
	gles2? ( media-libs/mesa[gles2] )
	gstreamer? (
		>=media-libs/gstreamer-1.2:1.0
		>=media-libs/gst-plugins-base-1.2:1.0 )
	introspection? ( >=dev-libs/gobject-introspection-1.32.0 )
	libsecret? ( app-crypt/libsecret )
	opengl? ( virtual/opengl )
	spell? ( >=app-text/enchant-0.22:= )
	webgl? (
		x11-libs/cairo[opengl]
		x11-libs/libXcomposite
		x11-libs/libXdamage )
"

# paxctl needed for bug #407085
# Need real bison, not yacc
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/perl
	|| (
		virtual/rubygems[ruby_targets_ruby20]
		virtual/rubygems[ruby_targets_ruby21]
		virtual/rubygems[ruby_targets_ruby19]
	)
	>=dev-libs/atk-2.8.0
	>=dev-util/gtk-doc-am-1.10
	dev-util/gperf
	>=sys-devel/bison-2.4.3
	>=sys-devel/flex-2.5.33
	|| ( >=sys-devel/gcc-4.7 >=sys-devel/clang-3.0 )
	sys-devel/gettext
	>=sys-devel/make-3.82-r4
	virtual/pkgconfig

	introspection? ( jit? ( sys-apps/paxctl ) )
	test? (
		dev-lang/python:2.7
		dev-python/pygobject:3[python_targets_python2_7]
		x11-themes/hicolor-icon-theme
		jit? ( sys-apps/paxctl ) )
"

S="${WORKDIR}/${MY_P}"

CHECKREQS_DISK_BUILD="18G" # and even this might not be enough, bug #417307

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" && ! is-flagq "-g*0" ; then
		einfo "Checking for sufficient disk space to build ${PN} with debugging CFLAGS"
		check-reqs_pkg_pretend
	fi

	if ! test-flag-CXX -std=c++11; then
		die "You need at least GCC 4.7.x or Clang >= 3.0 for C++11-specific compiler flags"
	fi
}

pkg_setup() {
	# Check whether any of the debugging flags is enabled
	if [[ ${MERGE_TYPE} != "binary" ]] && is-flagq "-g*" && ! is-flagq "-g*0" ; then
		if is-flagq "-ggdb" && [[ ${WEBKIT_GTK_GGDB} != "yes" ]]; then
			replace-flags -ggdb -g
			ewarn "Replacing \"-ggdb\" with \"-g\" in your CFLAGS."
			ewarn "Building ${PN} with \"-ggdb\" produces binaries which are too"
			ewarn "large for current binutils releases (bug #432784) and has very"
			ewarn "high temporary build space and memory requirements."
			ewarn "If you really want to build ${PN} with \"-ggdb\", add"
			ewarn "WEBKIT_GTK_GGDB=yes"
			ewarn "to your make.conf file."
		fi
		einfo "You need to have at least 18GB of temporary build space available"
		einfo "to build ${PN} with debugging CFLAGS. Note that it might still"
		einfo "not be enough, as the total space requirements depend on the flags"
		einfo "(-ggdb vs -g1) and enabled features."
		check-reqs_pkg_setup
	fi

	[[ ${MERGE_TYPE} = "binary" ]] || python-any-r1_pkg_setup
}

src_prepare() {
	DOCS="ChangeLog NEWS" # other ChangeLog files handled by src_install

	# intermediate MacPorts hack while upstream bug is not fixed properly
	# https://bugs.webkit.org/show_bug.cgi?id=28727
	use aqua && epatch "${FILESDIR}"/${PN}-1.6.1-darwin-quartz.patch

	# Don't force -O2
	sed -i 's/-O2//g' "${S}"/Source/autotools/SetupCompilerFlags.m4 || die

	# Failing tests
	# * webinspector -> https://bugs.webkit.org/show_bug.cgi?id=50744
	# * keyevents is interactive
	# * mimehandling test sometimes fails under Xvfb (works fine manually), bug #???
	# * webdatasource test needs a network connection and intermittently fails with icedtea-web
	# * webplugindatabase intermittently fails with icedtea-web, bug #????
	sed -e '/Programs\/TestWebKitAPI\/WebKitGtk\/testwebinspector/ d' \
		-e '/Programs\/TestWebKitAPI\/WebKitGtk\/testkeyevents/ d' \
		-e '/Programs\/TestWebKitAPI\/WebKitGtk\/testmimehandling/ d' \
		-e '/Programs\/TestWebKitAPI\/WebKitGtk\/testwebdatasource/ d' \
		-e '/Programs\/TestWebKitAPI\/WebKitGtk\/testwebplugindatabase/ d' \
		-i Source/WebKit/gtk/GNUmakefile.am || die

	# Respect CC, otherwise fails on prefix #395875
	tc-export CC

	# bug #459978, upstream bug #113397
	epatch "${FILESDIR}/${PN}-1.11.90-gtk-docize-fix.patch"

	# Do not build unittests unless requested, upstream bug #128163
	epatch "${FILESDIR}"/${PN}-2.2.4-unittests-build.patch

	# Deadlock causing infinite compilations with nvidia-drivers: 
	# https://bugs.gentoo.org/show_bug.cgi?id=463960
	# http://osdyson.org/issues/161
	# https://bugs.webkit.org/show_bug.cgi?id=125651
	epatch "${FILESDIR}"/${PN}-2.2.5-gir-nvidia-hangs.patch

	# Debian patches to fix support for some arches
	# https://bugs.webkit.org/show_bug.cgi?id=129540
	epatch "${FILESDIR}"/${PN}-2.2.5-{hppa,ia64}-platform.patch
	# https://bugs.webkit.org/show_bug.cgi?id=129542
	epatch "${FILESDIR}"/${PN}-2.2.5-ia64-malloc.patch

	# OpenBSD patches to fix support for some arches
	# https://bugs.webkit.org/show_bug.cgi?id=86835
	epatch "${FILESDIR}"/${PN}-2.2.5-sparc64-build.patch

	AT_M4DIR=Source/autotools eautoreconf

	gnome2_src_prepare
}

src_configure() {
	# Arches without JIT support also need this to really disable it in all places
	use jit || append-cppflags -DENABLE_JIT=0 -DENABLE_YARR_JIT=0 -DENABLE_ASSEMBLER=0

	# It doesn't compile on alpha without this in LDFLAGS, bug #???
	use alpha && append-ldflags "-Wl,--no-relax"

	# Sigbuses on SPARC with mcpu and co., bug #???
	use sparc && filter-flags "-mvis"

	# https://bugs.webkit.org/show_bug.cgi?id=42070 , #301634
	use ppc64 && append-flags "-mminimal-toc"

	# Try to use less memory, bug #469942 (see Fedora .spec for reference)
	# --no-keep-memory doesn't work on ia64, bug #502492
	if ! use ia64; then
		append-ldflags "-Wl,--no-keep-memory"
	fi
	if ! $(tc-getLD) --version | grep -q "GNU gold"; then
		append-ldflags "-Wl,--reduce-memory-overheads"
	fi

	local myconf=""

	if has_version "virtual/rubygems[ruby_targets_ruby21]"; then
		myconf="${myconf} RUBY=$(type -P ruby21)"
	elif has_version "virtual/rubygems[ruby_targets_ruby20]"; then
		myconf="${myconf} RUBY=$(type -P ruby20)"
	else
		myconf="${myconf} RUBY=$(type -P ruby19)"
	fi

	# TODO: Check Web Audio support
	# should somehow let user select between them?
	#
	# * dependency-tracking is required so parallel builds won't fail
	gnome2_src_configure \
		$(use_enable coverage) \
		$(use_enable debug) \
		$(use_enable egl) \
		$(use_enable geoloc geolocation) \
		$(use_enable gles2) \
		$(use_enable gstreamer video) \
		$(use_enable gstreamer web-audio) \
		$(use_enable introspection) \
		$(use_enable jit) \
		$(use_enable libsecret credential_storage) \
		$(use_enable opengl glx) \
		$(use_enable spell spellcheck) \
		$(use_enable webgl) \
		$(use_enable webgl accelerated-compositing) \
		--with-gtk=2.0 \
		--disable-webkit2 \
		--enable-dependency-tracking \
		--disable-gtk-doc \
		$(usex aqua "--with-font-backend=pango --with-target=quartz" "")
		${myconf}
}

src_test() {
	# Tests expect an out-of-source build in WebKitBuild
	ln -s . WebKitBuild || die "ln failed"

	# Prevents test failures on PaX systems
	use jit && pax-mark m $(list-paxables Programs/*[Tt]ests/*) # Programs/unittests/.libs/test*

	unset DISPLAY
	# Tests need virtualx, bug #294691, bug #310695
	# Parallel tests sometimes fail
	Xemake -j1 check
}

src_install() {
	# https://bugs.webkit.org/show_bug.cgi?id=129242
	MAKEOPTS="${MAKEOPTS} -j1" gnome2_src_install

	newdoc Source/WebKit/gtk/ChangeLog ChangeLog.gtk
	newdoc Source/JavaScriptCore/ChangeLog ChangeLog.JavaScriptCore
	newdoc Source/WebCore/ChangeLog ChangeLog.WebCore

	# Prevents crashes on PaX systems
	use jit && pax-mark m "${ED}usr/bin/jsc-1"

	# File collisions with slot 3
	# bug #402699, https://bugs.webkit.org/show_bug.cgi?id=78134
	rm -rf "${ED}usr/share/gtk-doc" || die
}

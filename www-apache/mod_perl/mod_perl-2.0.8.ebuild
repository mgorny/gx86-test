# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="5"

inherit depend.apache apache-module perl-module eutils

DESCRIPTION="An embedded Perl interpreter for Apache2"
SRC_URI="mirror://apache/perl/${P}.tar.gz"
HOMEPAGE="https://projects.apache.org/projects/mod_perl.html"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"
IUSE="debug"
SLOT="1"

# Make sure we always use the latest Apache-Test version or even check the
# version of the bundled Apache-Test!
#
# We need both, apache and perl but either apache without threads or perl with
# ithreads, bug 373943
DEPEND="<www-servers/apache-2.4
	>=dev-perl/Apache-Test-1.360
	>=virtual/perl-CGI-3.08
	dev-lang/perl
	www-servers/apache
	|| ( www-servers/apache[-threads] dev-lang/perl[ithreads] )"
RDEPEND="${DEPEND}"
PDEPEND=">=dev-perl/Apache-Reload-0.11
	>=dev-perl/Apache-SizeLimit-0.95"

APACHE2_MOD_FILE="${S}/src/modules/perl/mod_perl.so"
APACHE2_MOD_CONF="2.0.3/75_${PN}"
APACHE2_MOD_DEFINE="PERL"

SRC_TEST="do"

DOCFILES="Changes INSTALL README STATUS"

need_apache2

src_prepare() {
	perl-module_src_prepare

	# I am not entirely happy with this solution, but here's what's
	# going on here if someone wants to take a stab at another
	# approach.  When userpriv compilation is off, then the make
	# process drops to user "nobody" to run the test servers.  This
	# server is closed, and then the socket is rebound using
	# SO_REUSEADDR.  If the same user does this, there is no problem,
	# and the socket may be rebound immediately.  If a different user
	# (yes, in my testing, even root) attempts to rebind, it fails.
	# Since the "is the socket available yet" code and the
	# second-batch bind call both run as root, this will fail.

	# The upstream settings on my test machine cause the second batch
	# of tests to fail, believing the socket to still be in use.  I
	# tried patching various parts to make them run as the user
	# specified in $config->{vars}{user} using getpwnam, but found
	# this patch to be fairly intrusive, because the userid must be
	# restored and the patch must be applied to multiple places.

	# For now, we will simply extend the timeout in hopes that in the
	# non-userpriv case, the socket will clear from the kernel tables
	# normally, and the tests will proceed.

	# If anybody is still having problems, then commenting out "make
	# test" below should allow the software to build properly.

	# Robert Coie <rac@gentoo.org> 2003.05.06
#	sed -i -e "s/sleep \$_/sleep \$_ << 2/" \
#		"${S}"/Apache-Test/lib/Apache/TestServer.pm \
#		|| die "problem editing TestServer.pm"

	# rendhalver - this got redone for 2.0.1 and seems to fix the make test problems
	epatch "${FILESDIR}"/mod_perl-2.0.1-sneak-tmpdir.patch

	# bug 352724
	epatch "${FILESDIR}/${P}-bundled-Apache-Test.patch"
	rm -rf Apache-{Test,Reload,SizeLimit}/ lib/Bundle/
	sed -i -e 's:^Apache-\(Reload\|SizeLimit\|Test\).*::' \
		-e 's:^lib/Bundle/Apache2.pm::' MANIFEST || die
}

src_configure() {
	local myargs=

	if use debug; then
		myargs="MP_TRACE=1 MP_DEBUG=1"
	else
		myargs="MP_TRACE=0 MP_DEBUG=0"
	fi

	perl Makefile.PL \
		PREFIX="${EPREFIX}"/usr \
		INSTALLDIRS=vendor \
		MP_USE_DSO=1 \
		MP_APXS=${APXS} \
		${myargs} || die
}

src_test() {
	# make test notes whether it is running as root, and drops
	# privileges all the way to "nobody" if so, so we must adjust
	# write permissions accordingly in this case.

	# IF YOU SUDO TO EMERGE AND HAVE !env_reset set testing will fail!
	if [[ "$(id -u)" == "0" ]]; then
		chown nobody:nobody "${WORKDIR}"
		chown nobody:nobody "${T}"
	fi

	# this does not || die because of bug 21325. kudos to smark for
	# the idea of setting HOME.
	TMPDIR="${T}" HOME="${T}/" perl-module_src_test
}

src_install() {
	apache-module_src_install

	emake DESTDIR="${D}" install || die

	# TODO: add some stuff from docs/ back?

	# rendhalver - fix the perllocal.pod that gets installed
	# it seems to me that this has been getting installed for ages
	fixlocalpod
	# Remove empty .bs files as well
	perl_delete_packlist

	insinto "${APACHE_MODULES_CONFDIR}"
	doins "${FILESDIR}"/2.0.3/apache2-mod_perl-startup.pl || die

	# this is an attempt to get @INC in line with /usr/bin/perl.
	# there is blib garbage in the mainstream one that can only be
	# useful during internal testing, so we wait until here and then
	# just go with a clean slate.  should be much easier to see what's
	# happening and revert if problematic.

	# Sorry for this evil hack...
	perlinfo # just to be sure...
	sed -i -e "s,-I${S}/[^[:space:]\"\']\+[[:space:]]\?,,g" \
		-e "s,-typemap[[:space:]]${S}/[^[:space:]\"\']\+[[:space:]]\?,,g" \
		-e "s,${S}\(/[^[:space:]\"\']\+\)\?,/,g" "${D}/${VENDOR_ARCH}/Apache2/BuildConfig.pm" || die

	for fname in $(find "${D}" -type f -not -name '*.so'); do
		grep -q "\(${D}\|${S}\)" "${fname}" && ewarn "QA: File contains a temporary path ${fname}"
		sed -i -e "s:\(${D}\|${S}\):/:g" ${fname}
	done
	# All the rest
	perl_remove_temppath
}

pkg_postinst() {
	perl-module_pkg_postinst
	apache-module_pkg_postinst
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

POE_TEST_LOOPS_VERSION=1.351.0
MODULE_AUTHOR=RCAPUTO
MODULE_VERSION=1.356
inherit perl-module

DESCRIPTION="A framework for creating multitasking programs in Perl"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ipv6 libwww ncurses tk test"

RDEPEND="
	>=dev-perl/Event-1.09
	>=virtual/perl-File-Spec-0.87
	>=virtual/perl-IO-1.23.01
	>=virtual/perl-IO-Compress-1.33
	>=virtual/perl-Storable-2.12
	>=dev-perl/IO-Tty-1.08
	dev-perl/Filter
	dev-perl/FreezeThaw
	dev-perl/yaml
	>=dev-perl/TermReadKey-2.21
	>=virtual/perl-Time-HiRes-1.59
	ipv6? (
		>=dev-perl/Socket6-0.14
	)
	tk? (
		>=dev-perl/perl-tk-800.027
	)
	libwww? (
		>=dev-perl/libwww-perl-5.79
		>=dev-perl/URI-1.30
	)
	ncurses? (
		>=dev-perl/Curses-1.08
	)
"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/POE-Test-Loops-${POE_TEST_LOOPS_VERSION}
		>=virtual/perl-Test-Harness-2.26
		>=virtual/perl-Test-Simple-0.54
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		dev-perl/IO-Pipely
	)
"

SRC_TEST=do

src_test() {
	# Disable network tests
	rm -f "${S}"/run_network_tests
	perl-module_src_test
}

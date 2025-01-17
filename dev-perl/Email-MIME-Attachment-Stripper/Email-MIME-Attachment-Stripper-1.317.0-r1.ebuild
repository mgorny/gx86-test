# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=1.317
inherit perl-module

DESCRIPTION="Strip the attachments from a mail"

LICENSE="|| ( GPL-2 GPL-3 )" # GPL-2+
# under the same terms as Tony's original module
# Mail::Message::Attachment::Stripper
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

RDEPEND=">=dev-perl/Email-MIME-1.900
	>=dev-perl/Email-MIME-ContentType-1.012"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		dev-perl/Capture-Tiny
	)"

SRC_TEST="do"

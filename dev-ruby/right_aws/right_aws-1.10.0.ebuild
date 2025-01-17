# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

inherit ruby-fakegem

DESCRIPTION="A robust, fast, and secure interface to Amazon EC2, EBS, S3, SQS, SDB, and CloudFront"
HOMEPAGE="http://www.rightscale.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Tests require you to set up Amazon AWS access so we have no way to
# handle this from within the ebuild :(
RESTRICT="test"

# uuidtools is just needed for sdb, but still better to add it to the
# dependencies.
# libxml is also optionally supported.
ruby_add_rdepend '>=dev-ruby/right_http_connection-1.2.4 dev-ruby/uuidtools'

all_ruby_prepare() {
	# by default the Rakefile will require rcovtask from rcov to allow
	# coverage testing; since we don't care about that we'll just be
	# ignoring it for now.
	sed -i \
		-e '/rcovtask/s:^:#:' \
		Rakefile || die
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 jruby"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="History.txt README.md"

inherit ruby-fakegem eutils

DESCRIPTION="Adds a streamy multipart form post capability to Net::HTTP"
HOMEPAGE="http://github.com/nicksieger/multipart-post"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

each_ruby_test() {
	${RUBY} -S testrb -Ilib test || die "Tests failed."
}

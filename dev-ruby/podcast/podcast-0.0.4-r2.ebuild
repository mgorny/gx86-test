# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="A pure Ruby library for generating podcasts from mp3 files"
HOMEPAGE="http://podcast.rubyforge.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"

ruby_add_rdepend "dev-ruby/ruby-mp3info"

each_ruby_test() {
	${RUBY} -Ilib test/ts_podcast.rb || die "Tests failed."
}

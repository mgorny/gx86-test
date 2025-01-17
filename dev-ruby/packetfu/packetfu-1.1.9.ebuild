# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19"

inherit multilib ruby-fakegem

DESCRIPTION="A mid-level packet manipulation library"
HOMEPAGE="https://rubygems.org/gems/packetfu"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

ruby_add_rdepend " >=dev-ruby/pcaprub-0.9.2"
ruby_add_bdepend "test? ( >=dev-ruby/rspec-2.6.2 )
	doc? ( >=dev-ruby/sdoc-0.2.0 )"

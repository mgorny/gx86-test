# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_TASK_TEST="test:unit"

inherit ruby-fakegem

DESCRIPTION="Rails application preloader"
HOMEPAGE="http://github.com/rails/spring"

LICENSE="MIT"
SLOT="1.1"
KEYWORDS="~amd64"

IUSE=""

ruby_add_rdepend ">=dev-ruby/rubygems-2.1.0"

ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/activesupport virtual/ruby-minitest )"

all_ruby_prepare() {
	sed -i -e '/files/d' ${PN}.gemspec || die
}

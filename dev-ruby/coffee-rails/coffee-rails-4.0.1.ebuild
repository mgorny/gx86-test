# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem versionator

DESCRIPTION="Coffee Script adapter for the Rails asset pipeline"
HOMEPAGE="https://github.com/rails/coffee-rails"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~x86"

IUSE=""

ruby_add_rdepend ">=dev-ruby/coffee-script-2.2.0
	=dev-ruby/railties-4*"

all_ruby_prepare() {
	# Avoid dependency on git.
	sed -i -e 's/git ls-files/echo/' Rakefile || die

	# Make sure a consistent rails version is loaded.
	sed -i -e '4igem "rails"' -e '/bundler/ s:^:#:' test/test_helper.rb || die
}

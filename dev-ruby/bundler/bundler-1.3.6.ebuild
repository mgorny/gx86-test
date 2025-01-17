# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

# jruby → Many tests fail and test suite hangs.
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

# No documentation task
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md ISSUES.md UPGRADING.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="An easy way to vendor gem dependencies"
HOMEPAGE="http://github.com/carlhuda/bundler"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend virtual/rubygems

ruby_add_bdepend "test? ( app-text/ronn )"

RDEPEND+=" dev-vcs/git"
DEPEND+=" test? ( dev-vcs/git )"

all_ruby_prepare() {
	# Bundler only supports running the specs from git:
	# http://github.com/carlhuda/bundler/issues/issue/738
	sed -i -e '/when Bundler is bundled/,/^  end/ s:^:#:' spec/runtime/setup_spec.rb || die

	# Fails randomly and no clear cause can be found. Might be related
	# to bug 346357. This was broken in previous releases without a
	# failing spec, so patch out this spec for now since it is not a
	# regression.
	sed -i -e '/works when you bundle exec bundle/,/^  end/ s:^:#:' spec/install/deploy_spec.rb || die

	# Remove unneeded git dependency from gemspec, which we need to use
	# for bug 491826
	sed -i -e '/files/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Remove security policy specs since the certificate that it uses
	# expired 2014-02-04
	rm spec/install/security_policy_spec.rb || die
}

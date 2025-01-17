# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_BINWRAP=""

# The guides are now here but we'd need to rebuilt them first.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.md guides/CHANGELOG.md"

inherit ruby-fakegem versionator

DESCRIPTION="ruby on rails is a web-application and persistance framework"
HOMEPAGE="http://www.rubyonrails.org"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm"

IUSE="+asset-pipeline"

ruby_add_rdepend "
	~dev-ruby/actionmailer-${PV}
	~dev-ruby/actionpack-${PV}
	~dev-ruby/actionview-${PV}
	~dev-ruby/activemodel-${PV}
	~dev-ruby/activerecord-${PV}
	~dev-ruby/activesupport-${PV}
	~dev-ruby/railties-${PV}
	>=dev-ruby/bundler-1.3 =dev-ruby/bundler-1*
	=dev-ruby/sprockets-rails-2*
	asset-pipeline? (
		dev-ruby/jquery-rails
		>=dev-ruby/sass-rails-4.0.3:4.0
		>=dev-ruby/uglifier-1.3.0
		>=dev-ruby/coffee-rails-4.0.0:4.0
	)"

# also: turbolinks, >=jbuilder-1.2:1

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="An easy way to detect and use command-line dependencies"
HOMEPAGE="http://yaauie.github.io/cliver/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

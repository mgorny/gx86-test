# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

USE_RUBY="ruby19 ruby20"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="A dirt simple mechanism to tell if files have changed"
HOMEPAGE="http://github.com/benschwarz/watch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

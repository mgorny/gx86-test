# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 jruby"

RUBY_FAKEGEM_EXTRADOC="History.markdown README.md"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Lightweight and flexible library for writing command-line apps"
HOMEPAGE="https://github.com/jekyll/mercenary"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

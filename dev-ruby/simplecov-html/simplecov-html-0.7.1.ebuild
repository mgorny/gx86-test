# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
USE_RUBY="ruby19"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRAINSTALL="assets public views"

inherit ruby-fakegem

DESCRIPTION="Generates a nice HTML report of your SimpleCov ruby code coverage results on Ruby 1.9"
HOMEPAGE="https://github.com/colszowka/simplecov"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE="doc"

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
USE_RUBY="ruby19 ruby20 jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES README.rdoc TODO"

RUBY_FAKEGEM_TASK_TEST=""

inherit bash-completion-r1 ruby-fakegem

DESCRIPTION="Make-like scripting in Ruby"
HOMEPAGE="https://github.com/jimweirich/rake"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

DEPEND="${DEPEND} app-arch/gzip"
RDEPEND="${RDEPEND}"

ruby_add_bdepend "doc? ( dev-ruby/rdoc )
	test? ( virtual/ruby-minitest )"

all_ruby_prepare() {
	# Comment out unimportant test which failes on ruby18 at least.
	sed -i -e '/def test_classic_namespace/,/^  end/ s:^:#:' test/test_rake_application_options.rb || die

	# Avoid tests which can't work in bootstrapping because the test runs
	# in a directory that can't access the file being loaded.
	rm test/test_rake_clean.rb || die
	sed -i -e '/test_run_code_rake/,/^  end/ s:^:#:' test/test_rake_test_task.rb || die

	# Decompress the file. The compressed version has errors, ignore them.
	zcat doc/rake.1.gz > doc/rake.1
}

each_ruby_prepare() {
	case ${RUBY} in
		*jruby)
			# Remove failing tests. These are not failures in rake but
			# in our packaging of jruby. They are already present in
			# rake 0.9.2.2, so avoid them for now so that we can at
			# least bump 0.9.6 which is needed for ruby20.
			rm test/test_rake_{functional,rules}.rb || die
			;;
	esac
}

all_ruby_compile() {
	if use doc; then
		ruby -Ilib bin/rake rdoc || die "doc generation failed"
	fi
}

each_ruby_test() {
	${RUBY} -S testrb test/test_*.rb || die
}

all_ruby_install() {
	ruby_fakegem_binwrapper rake

	if use doc; then
		pushd html
		dohtml -r *
		popd
	fi

	doman doc/rake.1

	newbashcomp "${FILESDIR}"/rake.bash-completion ${PN}
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} pypy pypy2_0 )

inherit distutils-r1

DESCRIPTION="Pure python memcached client"
HOMEPAGE="http://www.tummy.com/Community/software/python-memcached/ http://pypi.python.org/pypi/python-memcached"
SRC_URI="ftp://ftp.tummy.com/pub/python-memcached/old-releases/${P}.tar.gz"

LICENSE="OSL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( net-misc/memcached )"
RDEPEND=""

MULTIBUILD_JOBS="1"

python_test() {
	pushd "${BUILD_DIR}/lib" > /dev/null
	cp memcache.py memcache_test.py || die
	sed -ie "s/11211/11219/" memcache_test.py || die
	memcached -u portage -d -p 11219 -l localhost -P "${T}/memcached.pid"
	"${PYTHON}" memcache_test.py || die
	kill "$(<"${T}/memcached.pid")"
	rm "${T}/memcached.pid"
	rm memcache_test.py*
	popd > /dev/null
}

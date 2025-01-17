# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} pypy pypy2_0 )

inherit check-reqs distutils-r1

DESCRIPTION="Python driver for MongoDB"
HOMEPAGE="http://github.com/mongodb/mongo-python-driver http://pypi.python.org/pypi/pymongo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc kerberos mod_wsgi test"

RDEPEND="dev-db/mongodb"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	kerberos? ( dev-python/pykerberos )"
DISTUTILS_IN_SOURCE_BUILD=1

reqcheck() {
	if use test; then
		# During the tests, database size reaches 1.5G.
		local CHECKREQS_DISK_BUILD=1536M

		check-reqs_${1}
	fi
}

pkg_pretend() {
	reqcheck pkg_pretend
}

pkg_setup() {
	reqcheck pkg_setup
}

PATCHES=( "${FILESDIR}"/${PN}-2.5.1-greenlet.patch )

python_compile_all() {
	if use doc; then
		mkdir html || die
		sphinx-build doc html || die
	fi
}

src_test() {
	# Yes, we need TCP/IP for that...
	local DB_IP=127.0.0.1
	local DB_PORT=27000

	export DB_IP DB_PORT

	# 1.5G of disk space per run.
	local DISTUTILS_NO_PARALLEL_BUILD=1

	distutils-r1_src_test
}

python_test() {
	local dbpath=${TMPDIR}/mongo.db
	local logpath=${TMPDIR}/mongod.log

	# Now, the hard part: we need to find a free port for mongod.
	# We're just trying to run it random port numbers and check the log
	# for bind errors. It shall be noted that 'mongod --fork' does not
	# return failure when it fails to bind.

	mkdir -p "${dbpath}" || die
	while true; do
		ebegin "Trying to start mongod on port ${DB_PORT}"

		LC_ALL=C \
		mongod --dbpath "${dbpath}" --smallfiles --nojournal \
			--bind_ip ${DB_IP} --port ${DB_PORT} \
			--unixSocketPrefix "${TMPDIR}" \
			--logpath "${logpath}" --fork \
		&& sleep 2

		# Now we need to check if the server actually started...
		if [[ ${?} -eq 0 && -S "${TMPDIR}"/mongodb-${DB_PORT}.sock ]]; then
			# yay!
			eend 0
			break
		elif grep -q 'Address already in use' "${logpath}"; then
			# ay, someone took our port!
			eend 1
			: $(( DB_PORT += 1 ))
			continue
		else
			eend 1
			eerror "Unable to start mongod for tests. See the server log:"
			eerror "	${logpath}"
			die "Unable to start mongod for tests."
		fi
	done

	local failed
	#https://jira.mongodb.org/browse/PYTHON-521, py2.[6-7] has intermittent failure with gevent
	pushd "${BUILD_DIR}"/../ > /dev/null
	if [[ "${EPYTHON}" == python3* ]]; then
		2to3 --no-diffs -w test
	fi
	DB_PORT2=$(( DB_PORT + 1 )) DB_PORT3=$(( DB_PORT + 2 )) esetup.py test || failed=1

	mongod --dbpath "${dbpath}" --shutdown

	[[ ${failed} ]] && die "Tests fail with ${EPYTHON}"

	rm -rf "${dbpath}"
}

python_install() {
	# Maintainer note:
	# In order to work with mod_wsgi, we need to disable the C extension.
	# See [1] for more information.
	# [1] http://api.mongodb.org/python/current/faq.html#does-pymongo-work-with-mod-wsgi
	distutils-r1_python_install $(use mod_wsgi && echo --no_ext)
}

python_install_all() {
	use doc && local HTML_DOCS=( html/. )

	distutils-r1_python_install_all
}

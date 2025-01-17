# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# @ECLASS: qmail.eclass
# @MAINTAINER:
# qmail-bugs@gentoo.org
# @BLURB: common qmail functions

inherit flag-o-matic toolchain-funcs fixheadtails user

# hardcoded paths
QMAIL_HOME="/var/qmail"
TCPRULES_DIR="/etc/tcprules.d"
SUPERVISE_DIR="/var/qmail/supervise"

# source files and directories
GENQMAIL_F=genqmail-${GENQMAIL_PV}.tar.bz2
GENQMAIL_S="${WORKDIR}"/genqmail-${GENQMAIL_PV}

QMAIL_SPP_F=qmail-spp-${QMAIL_SPP_PV}.tar.gz
QMAIL_SPP_S="${WORKDIR}"/qmail-spp-${QMAIL_SPP_PV}

# @FUNCTION: primes
# @USAGE: <min> <max>
# @DESCRIPTION:
# Prints a list of primes between min and max inclusive
# Note: this functions gets very slow when used with large numbers.
primes() {
	local min=${1} max=${2}
	local result= primelist=2 i p

	[[ ${min} -le 2 ]] && result="${result} 2"

	for ((i = 3; i <= max; i += 2))
	do
		for p in ${primelist}
		do
			[[ $[i % p] == 0 || $[p * p] -gt ${i} ]] && \
				break
		done
		if [[ $[i % p] != 0 ]]
		then
			primelist="${primelist} ${i}"
			[[ ${i} -ge ${min} ]] && \
				result="${result} ${i}"
		fi
	done

	echo ${result}
}

# @FUNCTION: is_prima
# @USAGE: <number>
# @DESCRIPTION:
# Checks wether a number is a prime number
is_prime() {
	local number=${1} i
	for i in $(primes ${number} ${number})
	do
		[[ ${i} == ${number} ]] && return 0
	done
	return 1
}

dospp() {
	insinto "${QMAIL_HOME}"/plugins/
	insopts -o root -g "$GROUP_ROOT" -m 0755
	newins $1 ${2:-$(basename $1)}
}

# @FUNCTION: dosupervise
# @USAGE: dosupervise <service> [<runfile> <logfile>]
# @DESCRIPTION:
# Install runfiles for services and logging to supervise directory
dosupervise() {
	local service=$1
	local runfile=${2:-${service}} logfile=${3:-${service}-log}
	[[ -z "${service}" ]] && die "no service given"

	insopts -o root -g "$GROUP_ROOT" -m 0755
	diropts -o root -g "$GROUP_ROOT" -m 0755

	dodir ${SUPERVISE_DIR}/${service}{,/log}
	fperms +t ${SUPERVISE_DIR}/${service}{,/log}

	insinto ${SUPERVISE_DIR}/${service}
	newins ${runfile} run

	insinto ${SUPERVISE_DIR}/${service}/log
	newins ${logfile} run
}

# @FUNCTION: qmail_set_cc
# @DESCRIPTION:
# The following commands patch the conf-{cc,ld} files to use the user's
# specified CFLAGS and LDFLAGS. These rather complex commands are needed
# because a user supplied patch might apply changes to these files, too.
# See bug #165981.
qmail_set_cc() {
	local cc=$(head -n 1 ./conf-cc | sed -e "s#^g\?cc\s\+\(-O2\)\?#$(tc-getCC) #")
	local ld=$(head -n 1 ./conf-ld | sed -e "s#^g\?cc\s\+\(-s\)\?#$(tc-getCC) #")

	echo "${cc} ${CFLAGS} ${CPPFLAGS}"  > ./conf-cc || die 'Patching conf-cc failed.'
	echo "${ld} ${LDFLAGS}" > ./conf-ld || die 'Patching conf-ld failed.'
}

# @FUNCTION: qmail_create_groups
# @DESCRIPTION:
# Keep qmail groups in sync across ebuilds
qmail_create_groups() {
	einfo "Creating qmail groups"
	enewgroup nofiles 200
	enewgroup qmail 201
}

# @FUNCTION: qmail_create_users
# @DESCRIPTION:
# Keep qmail users in sync across ebuilds
qmail_create_users() {
	qmail_create_groups

	einfo "Creating qmail users"
	enewuser alias 200 -1  "${QMAIL_HOME}"/alias 200
	enewuser qmaild 201 -1 "${QMAIL_HOME}" 200
	enewuser qmaill 202 -1 "${QMAIL_HOME}" 200
	enewuser qmailp 203 -1 "${QMAIL_HOME}" 200
	enewuser qmailq 204 -1 "${QMAIL_HOME}" 201
	enewuser qmailr 205 -1 "${QMAIL_HOME}" 201
	enewuser qmails 206 -1 "${QMAIL_HOME}" 201
}

genqmail_src_unpack() {
	cd "${WORKDIR}"
	[[ -n ${GENQMAIL_PV} ]] && unpack "${GENQMAIL_F}"
}

qmail_spp_src_unpack() {
	cd "${WORKDIR}"
	[[ -n ${QMAIL_SPP_PV} ]] && unpack "${QMAIL_SPP_F}"
}

# @FUNCTION: qmail_src_postunpack
# @DESCRIPTION:
# Unpack common config files, apply custom patches if supplied and
# set built configuration (CFLAGS, LDFLAGS, etc)
qmail_src_postunpack() {
	cd "${S}"

	qmail_set_cc

	mysplit=${QMAIL_CONF_SPLIT:-23}
	is_prime ${mysplit} || die "QMAIL_CONF_SPLIT is not a prime number."
	einfo "Using conf-split value of ${mysplit}."
	echo -n ${mysplit} > "${S}"/conf-split
}

qmail_src_compile() {
	cd "${S}"
	emake it man "$@" || die "make failed"
}

qmail_spp_src_compile() {
	cd "${GENQMAIL_S}"/spp/
	emake || die "make spp failed"
}

qmail_base_install() {
	einfo "Setting up basic directory hierarchy"
	diropts -o root -g qmail -m 755
	keepdir "${QMAIL_HOME}"/{,bin,control}

	einfo "Installing basic qmail software"
	insinto "${QMAIL_HOME}"/bin

	insopts -o root -g qmail -m 755
	doins datemail elq forward maildir2mbox maildirmake \
		maildirwatch mailsubj pinq predate qail \
		qmail-{inject,qmqpc,showctl} sendmail

	einfo "Adding env.d entry for qmail"
	doenvd "${GENQMAIL_S}"/conf/99qmail

	declare -F qmail_base_install_hook >/dev/null && \
		qmail_base_install_hook
}

qmail_full_install() {
	einfo "Setting up full directory hierarchy"
	keepdir "${QMAIL_HOME}"/users
	diropts -o alias -g qmail -m 755
	keepdir "${QMAIL_HOME}"/alias

	einfo "Installing all qmail software"
	insopts -o root -g qmail -m 755
	doins bouncesaying condredirect config-fast except preline qbiff \
		qmail-{pop3d,qmqpd,qmtpd,qread,qstat,smtpd,tcpok,tcpto} \
		qreceipt qsmhook tcp-env

	insopts -o root -g qmail -m 711
	doins qmail-{clean,getpw,local,popup,pw2u,remote,rspawn,send} splogger

	insopts -o root -g qmail -m 700
	doins qmail-{lspawn,newmrh,newu,start}

	insopts -o qmailq -g qmail -m 4711
	doins qmail-queue

	declare -F qmail_full_install_hook >/dev/null && \
		qmail_full_install_hook
}

qmail_config_install() {
	einfo "Installing stock configuration files"
	insinto "${QMAIL_HOME}"/control
	insopts -o root -g "$GROUP_ROOT" -m 644
	doins "${GENQMAIL_S}"/control/{conf-*,defaultdelivery}

	einfo "Installing configuration sanity checker and launcher"
	insinto "${QMAIL_HOME}"/bin
	insopts -o root -g "$GROUP_ROOT" -m 644
	doins "${GENQMAIL_S}"/control/qmail-config-system

	declare -F qmail_config_install_hook >/dev/null && \
		qmail_config_install_hook
}

qmail_man_install() {
	einfo "Installing manpages and documentation"

	# those are tagged for section 8 but named for
	# section 9 (which does not exist anyway)
	for i in *.9; do
		mv ${i} ${i/.9/.8}
	done

	into /usr
	doman *.[1578]
	dodoc BLURB* CHANGES FAQ INSTALL* PIC* README* REMOVE* SECURITY \
		SENDMAIL SYSDEPS TEST* THANKS* THOUGHTS TODO* \
		UPGRADE VERSION*

	declare -F qmail_man_install_hook >/dev/null && \
		qmail_man_install_hook
}

qmail_sendmail_install() {
	einfo "Installing sendmail replacement"
	diropts -m 755
	dodir /usr/sbin /usr/lib

	dosym "${QMAIL_HOME}"/bin/sendmail /usr/sbin/sendmail
	dosym "${QMAIL_HOME}"/bin/sendmail /usr/lib/sendmail

	declare -F qmail_sendmail_install_hook >/dev/null && \
		qmail_sendmail_install_hook
}

qmail_maildir_install() {
	# use the correct maildirmake
	# the courier-imap one has some extensions that are nicer
	MAILDIRMAKE="${D}${QMAIL_HOME}/bin/maildirmake"
	[[ -e /usr/bin/maildirmake ]] && \
		MAILDIRMAKE="/usr/bin/maildirmake"

	einfo "Setting up the default aliases"
	diropts -o alias -g qmail -m 700
	"${MAILDIRMAKE}" "${D}${QMAIL_HOME}"/alias/.maildir
	keepdir "${QMAIL_HOME}"/alias/.maildir/{cur,new,tmp}

	for i in "${QMAIL_HOME}"/alias/.qmail-{mailer-daemon,postmaster,root}; do
		if [[ ! -f "${ROOT}${i}" ]]; then
			touch "${D}${i}"
			fowners alias:qmail "${i}"
		fi
	done

	einfo "Setting up default maildirs in the account skeleton"
	diropts -o root -g "$GROUP_ROOT" -m 755
	insinto /etc/skel
	insopts -o root -g "$GROUP_ROOT" -m 644
	newins "${GENQMAIL_S}"/control/defaultdelivery .qmail.sample
	"${MAILDIRMAKE}" "${D}"/etc/skel/.maildir
	keepdir /etc/skel/.maildir/{cur,new,tmp}

	declare -F qmail_maildir_install_hook >/dev/null && \
		qmail_maildir_install_hook
}

qmail_tcprules_install() {
	dodir "${TCPRULES_DIR}"
	insinto "${TCPRULES_DIR}"
	insopts -o root -g "$GROUP_ROOT" -m 0644
	doins "${GENQMAIL_S}"/tcprules/Makefile.qmail
	doins "${GENQMAIL_S}"/tcprules/tcp.qmail-*
	use ssl || rm -f "${D}${TCPRULES_DIR}"/tcp.qmail-pop3sd
}

qmail_supervise_install() {
	einfo "Installing supervise scripts"

	cd "${GENQMAIL_S}"/supervise

	for i in qmail-{send,smtpd,qmtpd,qmqpd,pop3d}; do
		dosupervise ${i}
		diropts -o qmaill -g "$GROUP_ROOT" -m 755
		keepdir /var/log/qmail/${i}
	done

	if use ssl; then
		dosupervise qmail-pop3sd
		diropts -o qmaill -g "$GROUP_ROOT" -m 755
		keepdir /var/log/qmail/qmail-pop3sd
	fi

	declare -F qmail_supervise_install_hook >/dev/null && \
		qmail_supervise_install_hook
}

qmail_spp_install() {
	einfo "Installing qmail-spp configuration files"
	insinto "${QMAIL_HOME}"/control/
	insopts -o root -g "$GROUP_ROOT" -m 0644
	doins "${GENQMAIL_S}"/spp/smtpplugins

	einfo "Installing qmail-spp plugins"
	keepdir "${QMAIL_HOME}"/plugins/
	for i in authlog mfdnscheck ifauthnext tarpit; do
		dospp "${GENQMAIL_S}"/spp/${i}
	done

	declare -F qmail_spp_install_hook >/dev/null && \
		qmail_spp_install_hook
}

qmail_ssl_install() {
	use gencertdaily && \
		CRON_FOLDER=cron.daily || \
		CRON_FOLDER=cron.hourly

	einfo "Installing SSL Certificate creation script"
	insinto "${QMAIL_HOME}"/control
	insopts -o root -g "$GROUP_ROOT" -m 0644
	doins "${GENQMAIL_S}"/ssl/servercert.cnf

	insinto "${QMAIL_HOME}"/bin
	insopts -o root -g "$GROUP_ROOT" -m 0755
	doins "${GENQMAIL_S}"/ssl/mkservercert

	einfo "Installing RSA key generation cronjob"
	insinto /etc/${CRON_FOLDER}
	insopts -o root -g "$GROUP_ROOT" -m 0755
	doins "${GENQMAIL_S}"/ssl/qmail-genrsacert.sh

	keepdir "${QMAIL_HOME}"/control/tlshosts

	declare -F qmail_ssl_install_hook >/dev/null && \
		qmail_ssl_install_hook
}

qmail_src_install() {
	export GROUP_ROOT="$(id -gn root)"
	qmail_base_install
	qmail_full_install
	qmail_config_install
	qmail_man_install
	qmail_sendmail_install
	qmail_maildir_install
	qmail_tcprules_install
	qmail_supervise_install

	use qmail-spp && qmail_spp_install
	use ssl && qmail_ssl_install
}

qmail_queue_setup() {
	if use highvolume; then
		myconf="--bigtodo"
	else
		myconf="--no-bigtodo"
	fi

	mysplit=${QMAIL_CONF_SPLIT:-23}
	is_prime ${mysplit} || die "QMAIL_CONF_SPLIT is not a prime number."

	einfo "Setting up the message queue hierarchy"
	/usr/bin/queue-repair.py --create ${myconf} \
		--split ${mysplit} \
		"${ROOT}${QMAIL_HOME}" >/dev/null || \
		die 'queue-repair failed'
}

qmail_rootmail_fixup() {
	local TMPCMD="ln -sf ${QMAIL_HOME}/alias/.maildir/ ${ROOT}/root/.maildir"

	if [[ -d "${ROOT}"/root/.maildir && ! -L "${ROOT}"/root/.maildir ]] ; then
		elog "Previously the qmail ebuilds created /root/.maildir/ but not"
		elog "every mail was delivered there. If the directory does not"
		elog "contain any mail, please delete it and run:"
		elog "${TMPCMD}"
	else
		${TMPCMD}
	fi

	chown -R alias:qmail "${ROOT}${QMAIL_HOME}"/alias/.maildir 2>/dev/null
}

qmail_tcprules_fixup() {
	mkdir -p "${TCPRULES_DIR}"
	for f in {smtp,qmtp,qmqp,pop3}{,.cdb}; do
		old="/etc/tcp.${f}"
		new="${TCPRULES_DIR}/tcp.qmail-${f}"
		fail=0
		if [[ -f "${old}" && ! -f "${new}" ]]; then
			einfo "Moving ${old} to ${new}"
			cp "${old}" "${new}" || fail=1
		else
			fail=1
		fi
		if [[ "${fail}" = 1 && -f "${old}" ]]; then
			eerror "Error moving ${old} to ${new}, be sure to check the"
			eerror "configuration! You may have already moved the files,"
			eerror "in which case you can delete ${old}"
		fi
	done
}

qmail_tcprules_build() {
	for f in tcp.qmail-{smtp,qmtp,qmqp,pop3,pop3s}; do
		# please note that we don't check if it exists
		# as we want it to make the cdb files anyway!
		src="${ROOT}${TCPRULES_DIR}/${f}"
		cdb="${ROOT}${TCPRULES_DIR}/${f}.cdb"
		tmp="${ROOT}${TCPRULES_DIR}/.${f}.tmp"
		[[ -e "${src}" ]] && tcprules "${cdb}" "${tmp}" < "${src}"
	done
}

qmail_config_notice() {
	elog
	elog "To setup ${PN} to run out-of-the-box on your system, run:"
	elog "emerge --config =${CATEGORY}/${PF}"
}

qmail_supervise_config_notice() {
	elog
	elog "To start qmail at boot you have to add svscan to your startup"
	elog "and create the following links:"
	elog "ln -s ${SUPERVISE_DIR}/qmail-send /service/qmail-send"
	elog "ln -s ${SUPERVISE_DIR}/qmail-smtpd /service/qmail-smtpd"
	elog
	elog "To start the pop3 server as well, create the following link:"
	elog "ln -s ${SUPERVISE_DIR}/qmail-pop3d /service/qmail-pop3d"
	elog
	if use ssl; then
		elog "To start the pop3s server as well, create the following link:"
		elog "ln -s ${SUPERVISE_DIR}/qmail-pop3sd /service/qmail-pop3sd"
		elog
	fi
	elog "Additionally, the QMTP and QMQP protocols are supported, "
	elog "and can be started as:"
	elog "ln -s ${SUPERVISE_DIR}/qmail-qmtpd /service/qmail-qmtpd"
	elog "ln -s ${SUPERVISE_DIR}/qmail-qmqpd /service/qmail-qmqpd"
	elog
	elog "Additionally, if you wish to run qmail right now, you should "
	elog "run this before anything else:"
	elog "source /etc/profile"
}

qmail_config_fast() {
	if [[ ${ROOT} = / ]]; then
		local host=$(hostname --fqdn)

		if [[ -z "${host}" ]]; then
			eerror
			eerror "Cannot determine your fully-qualified hostname"
			eerror "Please setup your /etc/hosts as described in"
			eerror "http://www.gentoo.org/doc/en/handbook/handbook-x86.xml?part=1&chap=8#doc_chap2_sect4"
			eerror
			die "cannot determine FQDN"
		fi

		if [[ ! -f "${ROOT}${QMAIL_HOME}"/control/me ]]; then
			"${ROOT}${QMAIL_HOME}"/bin/config-fast ${host}
		fi
	else
		ewarn "Skipping some configuration as it MUST be run on the final host"
	fi
}

qmail_tcprules_config() {
	einfo "Accepting relaying by default from all ips configured on this machine."
	LOCALIPS=$(/sbin/ifconfig | grep inet | cut -d' ' -f 12 -s | cut -b 6-20)
	TCPSTRING=":allow,RELAYCLIENT=\"\",RBLSMTPD=\"\""
	for ip in $LOCALIPS; do
		myline="${ip}${TCPSTRING}"
		for proto in smtp qmtp qmqp; do
			f="${ROOT}${TCPRULES_DIR}/tcp.qmail-${proto}"
			egrep -q "${myline}" "${f}" || echo "${myline}" >> "${f}"
		done
	done
}

qmail_ssl_generate() {
	CRON_FOLDER=cron.hourly
	use gencertdaily && CRON_FOLDER=cron.daily

	ebegin "Generating RSA keys for SSL/TLS, this can take some time"
	"${ROOT}"/etc/${CRON_FOLDER}/qmail-genrsacert.sh
	eend $?

	einfo "Creating a self-signed ssl-certificate:"
	"${ROOT}${QMAIL_HOME}"/bin/mkservercert

	einfo "If you want to have a properly signed certificate "
	einfo "instead, do the following:"
	# space at the end of the string because of the current implementation
	# of einfo
	einfo "openssl req -new -nodes -out req.pem \\ "
	einfo "  -config ${QMAIL_HOME}/control/servercert.cnf \\ "
	einfo "  -keyout ${QMAIL_HOME}/control/servercert.pem"
	einfo "Send req.pem to your CA to obtain signed_req.pem, and do:"
	einfo "cat signed_req.pem >> ${QMAIL_HOME}/control/servercert.pem"
}

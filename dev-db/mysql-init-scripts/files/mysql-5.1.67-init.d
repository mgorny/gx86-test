#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

depend() {
	use net.lo
	# localmount needed for $basedir
	need localmount
}

get_config() {
	my_print_defaults --config-file="$1" mysqld |
	sed -n -e "s/^--$2=//p"
}

mysql_svcname() {
	local ebextra=
	case "${SVCNAME}" in
		mysql*) ;;
		*) ebextra=" (mysql)" ;;
	esac
	echo "${SVCNAME}${ebextra}"
}

start() {
	# Check for old conf.d variables that mean migration was not yet done.
	set | egrep -sq '^(mysql_slot_|MYSQL_BLOG_PID_FILE|STOPTIMEOUT)'
	rc=$?
	# Yes, MYSQL_INIT_I_KNOW_WHAT_I_AM_DOING is a hidden variable.
	# It does have a use in testing, as it is possible to build a config file
	# that works with both the old and new init scripts simulateously.
	if [ "${rc}" = 0 -a -z "${MYSQL_INIT_I_KNOW_WHAT_I_AM_DOING}" ]; then
		eerror "You have not updated your conf.d for the new mysql-init-scripts-2 revamp."
		eerror "Not proceeding because it may be dangerous."
		return 1
	fi

	# Now we can startup
	ebegin "Starting $(mysql_svcname)"

	MY_CNF="${MY_CNF:-/etc/${SVCNAME}/my.cnf}"

	if [ ! -r "${MY_CNF}" ] ; then
		eerror "Cannot read the configuration file \`${MY_CNF}'"
		return 1
	fi

	# tail -n1 is critical as these we only want the last instance of the option
	local basedir=$(get_config "${MY_CNF}" basedir | tail -n1)
	local datadir=$(get_config "${MY_CNF}" datadir | tail -n1)
	local pidfile=$(get_config "${MY_CNF}" pid-file | tail -n1)
	local socket=$(get_config "${MY_CNF}" socket | tail -n1)

	if [ ! -d "${datadir}" ] ; then
		eerror "MySQL datadir \`${datadir}' is empty or invalid"
		eerror "Please check your config file \`${MY_CNF}'"
		return 1
	fi

	if [ ! -d "${datadir}"/mysql ] ; then
		eerror "You don't appear to have the mysql database installed yet."
		eerror "Please run /usr/bin/mysql_install_db to have this done..."
		return 1
	fi

	local piddir="${pidfile%/*}"
	checkpath -d --owner mysql:mysql --mode 0755 "$piddir"
	rc=$?
	if [ $rc -ne 0 ]; then
		eerror "Directory $piddir for pidfile does not exist and cannot be created"
		return 1
	fi

	local startup_timeout=${STARTUP_TIMEOUT:-900}
	local startup_early_timeout=${STARTUP_EARLY_TIMEOUT:-1000}
	local tmpnice="${NICE:+"--nicelevel "}${NICE}"
	local tmpionice="${IONICE:+"--ionice "}${IONICE}"
	start-stop-daemon \
		${DEBUG:+"--verbose"} \
		--start \
		--exec "${basedir}"/sbin/mysqld \
		--pidfile "${pidfile}" \
		--background \
		--wait ${startup_early_timeout} \
		${tmpnice} \
		${tmpionice} \
		-- --defaults-file="${MY_CNF}" ${MY_ARGS}
	local ret=$?
	if [ ${ret} -ne 0 ] ; then
		eend ${ret}
		return ${ret}
	fi

	ewaitfile ${startup_timeout} "${socket}"
	eend $? || return 1

	save_options pidfile "${pidfile}"
	save_options basedir "${basedir}"
}

stop() {
	ebegin "Stopping $(mysql_svcname)"

	local pidfile="$(get_options pidfile)"
	local basedir="$(get_options basedir)"
	local stop_timeout=${STOP_TIMEOUT:-120}

	start-stop-daemon \
		${DEBUG:+"--verbose"} \
		--stop \
		--exec "${basedir}"/sbin/mysqld \
		--pidfile "${pidfile}" \
		--retry ${stop_timeout}
	eend $?
}
# vim: filetype=gentoo-init-d sw=2 ts=2 sts=2 noet:


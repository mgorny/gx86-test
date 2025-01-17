#!/sbin/runscript
# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

depend() {
	use logger
}

checkconfig() {
	if [ ! -e /etc/sec.conf ] ; then
		eerror "You need an /etc/sec.conf config file to run sec"
		return 1
	fi
	return 0
}

start() {
	checkconfig || return 1
	ebegin "Starting sec"
	start-stop-daemon --start --quiet --exec /usr/bin/sec.pl \
		-- -pid=/var/run/sec.pid \
		-detach -log=/var/log/sec.log \
		-conf=/etc/sec.conf \
		${INPUT_FILES} \
		-debug=${DEBUG_LEVEL} \
		${SEC_FLAGS} > /dev/null 2>&1
	eend $?
}

stop() {
	ebegin "Stopping sec"
	start-stop-daemon --stop --quiet --pidfile /var/run/sec.pid
	eend $?
}


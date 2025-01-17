#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

depend() {
	need net
	use dns ircd
}

start() {
	ebegin "Starting ptlink-opm"
	start-stop-daemon --start --quiet --exec /usr/bin/ptlink-opm \
		--chuid ${PTLINKOPM_USER} >/dev/null
	eend $?
}

stop() {
	ebegin "Shutting down ptlink-opm"
	start-stop-daemon --stop --exec /usr/bin/ptlink-opm
	eend $?
}

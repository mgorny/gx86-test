#!/sbin/runscript
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

depend() {
	need net
	provide ircd
}

start() {
	ebegin "Starting ngIRCd"
	start-stop-daemon --start --quiet --exec /usr/sbin/ngircd
	eend $?
}

stop() {
	ebegin "Stopping ngIRCd"
	start-stop-daemon --stop --quiet --exec /usr/sbin/ngircd
	eend $?
}

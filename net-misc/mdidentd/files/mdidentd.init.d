#!/sbin/runscript
# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

depend() {
	need net
}

start() {
	ebegin "Starting mdidentd"
	/usr/sbin/mdidentd -u ${MDIDENTD_UID} -kr /usr/sbin/mdidentd
	eend $?
}

stop() {
	ebegin "Stopping mdidentd"
	kill $(</var/run/mdidentd.pid)
	eend $?
	rm -f /var/run/mdidentd.pid
}

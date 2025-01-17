#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

extra_started_commands="reload"
command="/usr/sbin/acpid"
command_args="${ACPID_ARGS}"
start_stop_daemon_args="--quiet"
description="Daemon for Advanced Configuration and Power Interface"

depend() {
	need localmount
	use logger
}

reload() {
	ebegin "Reloading acpid configuration"
	start-stop-daemon --exec $command --signal HUP
	eend $?
}

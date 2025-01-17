#!/sbin/runscript
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

depend() {
    need openib
    after net    # ip net seems to be needed to perform management.
}

prog=/usr/sbin/opensm

start() {
    ebegin "Starting OpenSM Infiniband Subnet Manager"
    start-stop-daemon --start --background --exec $prog -- $OPTIONS
    eend $?
}

stop() {
    ebegin "Stopping OpenSM Infiniband Subnet Manager"
    start-stop-daemon --stop --exec $prog
    eend $?
}


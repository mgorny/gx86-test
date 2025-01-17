# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# If you want a non-stock location for the config file, uncomment or update
# either of these as needed. If you do use it, you must make sure that none of
# your socket, pidfile, datadir, logfiles, binary logs, relay logs or InnoDB
# files collide with each other.
MY_CNF="/etc/mysql/my.cnf"
#MY_CNF="${MY_CNF:-/etc/${SVCNAME}/my.cnf}"
#MY_CNF="${MY_CNF:-/etc/mysql/my-${SVCNAME/mysql.}.cnf}"

# Place any additional arguments here that you might need
# Common/useful options:
# --skip-slave-start=1 - For bringing up replication initially
# --server-id=NNN - Server ID for replication
# --skip-networking - lock it down to UNIX sockets only
MY_ARGS=""

# This setting (in seconds) should be high enough to allow InnoDB to do a full
# checkpoint recovery. 900 is the default used in the upstream RPM startup
# scripts. 30 seconds should be sufficent if you just have a tiny <1GiB
# database. After the core startup is done, we wait this long for the UNIX
# socket to appear.
STARTUP_TIMEOUT="900"

# This is how long, in milliseconds, we wait for pidfile to be created, early
# in the startup.
STARTUP_EARLY_TIMEOUT="1000"

# How long (in seconds) should we wait for shutdown?
STOP_TIMEOUT=120

# integer [-20 .. 19 ] default 0
# change the priority of the server -20 (high) to 19 (low)
# see nice(1) for description
#NICE=0

# See start-stop-daemon(8) for possible settings
#IONICE=2

# If defined, --verbose gets passed to S-S-D
#DEBUG=1

# Depending on your usage of MySQL, you may also wish to start it after some
# other services are up. Uncomment the lines below as needed. If these aren't
# enough for you, we encourage you to file a bug, and help us understand how
# you are using MySQL.

# Do your MySQL ACLs refer to hostnames not in your /etc/hosts?
# If so, you need DNS before you can accept connections.
# Avoid dependency circular loops if you use MySQL to power a local DNS server.
#rc_use="dns"
#rc_after="dns"

# Does your MySQL bind to an IP on an interface other than net.lo?
# Alternatively you might wish to specify the exact interface here.
#rc_use="net"
#rc_after="net"

# Do you store your MySQL files on a SAN or other network filesystem, that is
# provided by the netmount init script?
#rc_need="netmount"

# Or from NFS? P.S. This is not a good idea in most cases, but does have some
# valid usage cases, so we provide the option.
#rc_need="nfsmount"

# Should any one of the instances satisfy the requirement for MySQL coming up?
# By default, we say no.
[ "${SVCNAME}" != mysql ] && rc_provide="!mysql"
# But uncomment this next instead if you think it should.
#rc_provide="mysql"

# The conditional above has a false-positive "failure" return value as a
# side-effect, and since it's the last statement, without the next line, this
# script returns failure.
return 0
# vim: ft=gentoo-conf-d et ts=4 sw=4:

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils unpacker cdrom games

DESCRIPTION="Futuristic FPS (Game Of The Year edition)"
HOMEPAGE="http://www.unrealtournament.com/"
SRC_URI="ftp://ftp.lokigames.com/pub/beta/ut/ut-install-${PV}-GOTY.run
	ftp://ftp.lokigames.com/pub/patches/ut/IpDrv-${PV}-Linux-08-20-02.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="x86"
IUSE="3dfx S3TC nls opengl"
RESTRICT="mirror bindist"

DEPEND="!games-fps/unreal-tournament
	app-arch/unzip"
RDEPEND="opengl? ( virtual/opengl )
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp"

S=${WORKDIR}

src_unpack() {
	cdrom_get_cds System/ Help/chaosut
	unpack_makeself ut-install-${PV}-GOTY.run
	unpack IpDrv-${PV}-Linux-08-20-02.zip
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN/-goty/}
	local Ddir=${D}/${dir}
	dodir "${dir}"

	###########
	### PRE ###
	# System
	if use 3dfx ; then
		tar -zxf Glide.ini.tar.gz -C "${Ddir}" || die "install Glide ini"
	else
		tar -zxf OpenGL.ini.tar.gz -C "${Ddir}" || die "install OpenGL ini"
	fi
	tar -zxf data.tar.gz -C "${Ddir}" || die "extract System data"

	# the most important things, ucc & ut :)
	exeinto "${dir}"
	doexe bin/x86/{ucc,ut} || die "install ucc/ut"
	dosed "s:\`FindPath \$0\`:${dir}:" "${dir}"/ucc

	# export some symlinks so ppl can run
	dodir "${GAMES_BINDIR}"
	dosym "${dir}"/ucc "${GAMES_BINDIR}"/ucc
	dosym "${dir}"/ut "${GAMES_BINDIR}"/ut
	### PRE ###
	###########

	###########
	### CD1 ###
	# Help, Logs, Music, Sounds, Textures, Web
	cp -rf "${CDROM_ROOT}"/{Help,Logs,Music,Textures,Web} "${Ddir}"/ || die "copy Help, Logs, Music, Textures, Web CD1"
	dodir "${dir}"/Sounds
	if use nls ; then
		cp -rf "${CDROM_ROOT}"/Sounds/* "${Ddir}"/Sounds/ || die "copy Sounds CD1"
	else
		cp -rf "${CDROM_ROOT}"/Sounds/*.uax "${Ddir}"/Sounds/ || die "copy Sounds CD1"
	fi

	# System
	dodir "${dir}"/System
	if use nls ; then
		cp "${CDROM_ROOT}"/System/*.{est,frt,itt,int,u} "${Ddir}"/System/ || die "copy System data CD1"
	else
		cp "${CDROM_ROOT}"/System/*.{int,u} "${Ddir}"/System/ || die "copy System data CD1"
	fi

	# now we uncompress the maps
	einfo "Uncompressing CD1 Maps ... this may take some time"
	dodir "${dir}"/Maps
	cd "${Ddir}"
	export HOME=${T}
	export UT_DATA_PATH="${Ddir}"/System
	for f in `find "${CDROM_ROOT}"/Maps/ -name '*.uz' -printf '%f '` ; do
		./ucc decompress "${CDROM_ROOT}"/Maps/${f} -nohomedir || die "uncompressing map CD1 ${f}"
		mv System/${f:0:${#f}-3} Maps/ || die "copy map CD1 ${f}"
	done
	### CD1 ###
	###########

	### Have user switch cds if need be ###
	cdrom_load_next_cd

	###########
	### CD2 ###
	# Help, Sounds
	cp -rf "${CDROM_ROOT}"/{Help,Sounds} "${Ddir}"/ || die "copy Help, Sounds CD2"

	# S3TC Textures
	if use S3TC ; then
		cp -rf "${CDROM_ROOT}"/Textures "${Ddir}"/ || die "copy S3TC Textures CD2"
	else
		cp -rf "${CDROM_ROOT}"/Textures/{JezzTex,Jezztex2,SnowDog,chaostex{,2}}.utx "${Ddir}"/Textures/ || die "copy Textures CD2"
	fi

	# System
	cp -rf "${CDROM_ROOT}"/System/*.{u,int} "${Ddir}"/System/ || die "copy System CD2"

	# now we uncompress the maps
	einfo "Uncompressing CD2 Maps ... this may take some time"
	dodir "${dir}"/Maps
	cd "${Ddir}"
	export HOME=${T}
	export UT_DATA_PATH="${Ddir}"/System
	for f in `find "${CDROM_ROOT}"/maps/ -name '*.uz' -printf '%f '` ; do
		./ucc decompress "${CDROM_ROOT}"/maps/${f} -nohomedir || die "uncompressing map CD2 ${f}"
		mv System/${f:0:${#f}-3} Maps/ || die "copy map CD2 ${f}"
	done
	### CD2 ###
	###########

	###########
	### END ###
	cd "${S}"

	# Textures
	tar -zxf Credits.tar.gz -C "${Ddir}" || die "extract credits texture"
	# NetGamesUSA.com
	tar -zxf NetGamesUSA.com.tar.gz -C "${Ddir}"/ || die "extract NetGamesUSA.com"

	# Patch UT-GOTY
	cd setup.data
	cp patch.dat{,.orig} || die "cp failed"
	sed -e 's:sh uz-maps.sh:echo:' patch.dat.orig > patch.dat || die "sed failed"
	./bin/Linux/x86/loki_patch patch.dat "${Ddir}" || die "failed to patch"
	cd "${S}"

	# now we install the IpDrv.so patch
	insinto "${dir}"/System
	doins IpDrv.so || die "install IpDrv.so patch"

	# install a few random files
	insinto "${dir}"
	doins README icon.{bmp,xpm} || die "installing random files"

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find "${Ddir}" -exec touch '{}' \;
	### END ###
	###########

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "You might want to install the bonus packs too."
	elog "Many servers on the internet use them, and the"
	elog "majority of players do too."
	elog
	elog "Just run: emerge unreal-tournament-bonuspacks"
}

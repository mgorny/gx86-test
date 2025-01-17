# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="A meta-package for installing all EMBASSY packages (EMBOSS add-ons)"
HOMEPAGE="http://www.emboss.org/"
SRC_URI=""
LICENSE="GPL-2 freedist"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="!<sci-biology/emboss-6.1.0
	~sci-biology/emboss-6.1.0
	=sci-biology/embassy-cbstools-1.0.0-r1
	=sci-biology/embassy-domainatrix-0.1.0-r4
	=sci-biology/embassy-domalign-0.1.0-r4
	=sci-biology/embassy-domsearch-0.1.0-r4
	=sci-biology/embassy-emnu-1.05-r6
	=sci-biology/embassy-esim4-1.0.0-r6
	=sci-biology/embassy-hmmer-2.3.2-r3
	=sci-biology/embassy-iprscan-4.3.1-r1
	=sci-biology/embassy-memenew-4.0.0
	=sci-biology/embassy-mira-2.8.2-r1
	=sci-biology/embassy-mse-1.0.0-r7
	=sci-biology/embassy-phylipnew-3.68
	=sci-biology/embassy-signature-0.1.0-r4
	=sci-biology/embassy-structure-0.1.0-r4
	=sci-biology/embassy-topo-1.0.0-r6
	=sci-biology/embassy-vienna-1.7.2-r1"

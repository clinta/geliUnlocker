# $FreeBSD$

PORTNAME=	geliunlock
PORTVERSION=	0.82
CATEGORIES=	sysutils

USE_GITHUB=	yes
GH_ACCOUNT=	clinta
GH_COMMIT=	c31d2e7
GH_PROJECT=	geliUnlocker
GH_TAGNAME=	${GH_COMMIT}

DIST_SUBDIR=	${PORTNAME}

MAINTAINER=	clint@clintarmstrong.net
COMMENT=	Automatically unlocks geli partitions using keys and passphrases stored on remote servers.

PLIST_FILES=	etc/rc.d/unlockgeli

.include <bsd.port.mk>

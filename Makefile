# $FreeBSD$

PORTNAME=	geliunlock
PORTVERSION=	0.8
CATEGORIES=	sysutils

USE_GITHUB=	yes
GH_ACCOUNT=	clinta
GH_COMMIT=	2ac4d14
MAINTAINER=	clint@clintarmstrong.net
COMMENT=	Automatically unlocks geli partitions using keys and passphrases stored on remote servers.

PLIST_FILES=	etc/rc.d/unlockgeli

.include <bsd.port.mk>

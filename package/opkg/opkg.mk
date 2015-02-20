#############################################################
#
# opkg
#
#############################################################

OPKG_VERSION = 0.2.4
OPKG_SOURCE = opkg-$(OPKG_VERSION).tar.gz
OPKG_SITE = http://git.yoctoproject.org/cgit/cgit.cgi/opkg/snapshot
OPKG_INSTALL_STAGING = YES
OPKG_CONF_OPT = --disable-curl --disable-gpg
OPKG_AUTORECONF = YES
# Uses PKG_CHECK_MODULES() in configure.ac
OPKG_DEPENDENCIES = host-pkgconf

# Ensure directory for lockfile exists
define OPKG_CREATE_LOCKDIR
	mkdir -p $(TARGET_DIR)/usr/lib/opkg
endef

OPKG_POST_INSTALL_TARGET_HOOKS += OPKG_CREATE_LOCKDIR

$(eval $(autotools-package))

#
# Copyright (C) 2007-2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tinc-pre
PKG_VERSION:=1.1pre17
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/tinc-$(PKG_VERSION)
PKG_SOURCE:=release-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/gsliepen/tinc/archive
PKG_HASH:=004d7c0c1f32c414df96e7f44890186cb533a1b7
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/tinc-pre
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=tinc vpn daemon pre-release
  URL:=https://www.tinc-vpn.org/
  DEPENDS:=+kmod-tun +liblzo +libopenssl +zlib
endef

define Package/tinc-pre/description
  tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and
  encryption to create a secure private network between hosts on the Internet.
endef

TARGET_CFLAGS += -std=gnu99

CONFIGURE_ARGS += \
	--disable-readline \
	--disable-curses \
	--with-kernel="$(LINUX_DIR)" \
	--with-lzo-include="$(STAGING_DIR)/usr/include/lzo" \
	--with-zlib="$(STAGING_DIR)/usr"

MAKE_PATH:=src

define Build/Compile
	$(call Build/Compile/Default)
endef

define Package/tinc-pre/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/tinc $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/tincd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) files/tinc.init $(1)/etc/init.d/tinc
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) files/tinc.config $(1)/etc/config/tinc
	$(INSTALL_DIR) $(1)/etc/tinc
	$(INSTALL_DIR) $(1)/lib/upgrade/keep.d
	$(INSTALL_DATA) files/tinc.upgrade $(1)/lib/upgrade/keep.d/tinc
endef

define Package/tinc/conffiles
/etc/config/tinc
endef

$(eval $(call BuildPackage,tinc-pre))

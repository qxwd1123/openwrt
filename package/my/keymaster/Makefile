# SPDX-Identifier-License: GPL-3.0-only
#
# Copyright (C) 2021 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=keymaster
PKG_VERSION:=1.15.3
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/Cloud-Foundations/keymaster/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=2e0de1e677322d468a55b2ac79c9b73f6e19c1811d023ca5ba1121be082dd25a

PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILE:=LICENSE
PKG_MAINTAINER:=a <a@a>

PKG_CONFIG_DEPENDS:= \
	CONFIG_KEYMASTER_COMPRESS_GOPROXY \
	CONFIG_KEYMASTER_COMPRESS_UPX

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/Cloud-Foundations/keymaster
TARGET_CFLAGS+=-D_LARGEFILE64_SOURCE
GO_PKG_LDFLAGS:=-s -w
COMPILE_TIME:= $(shell TZ=UTC-8 date '+%Y-%m-%d %H:%M:%S')
GO_PKG_LDFLAGS_X+= main.Version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/keymaster/config
config KEYMASTER_COMPRESS_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n

config KEYMASTER_COMPRESS_UPX
	bool "Compress executable files with UPX"
	default y
endef

ifeq ($(CONFIG_KEYMASTER_COMPRESS_GOPROXY),y)
	export GO111MODULE=on
	export GOPROXY=https://goproxy.io
endif

define Package/keymaster
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=SSH
  TITLE:=keymaster
  URL:=https://github.com/Cloud-Foundations/keymaster
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) $(PKG_BUILD_DIR)/templates/config_host_go $(PKG_BUILD_DIR)/cmd/keymaster/config_host.go
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
ifeq ($(CONFIG_GOST_COMPRESS_UPX),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/keymaster
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/keymasterd
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/keymaster-unlocker
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/keymaster-eventmond
endif
endef

define Package/keymaster/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/etc/keymaster
	$(INSTALL_DIR) $(1)/etc/keymaster/web
	$(CP) $(PKG_BUILD_DIR)/cmd/keymasterd/customization_data $(1)/etc/keymaster/web
	$(CP) $(PKG_BUILD_DIR)/cmd/keymasterd/data $(1)/etc/keymaster/web
	$(CP) $(PKG_BUILD_DIR)/cmd/keymasterd/static_files $(1)/etc/keymaster/web
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/keymaster.init $(1)/etc/init.d/keymaster
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/keymaster $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/keymaster-unlocker $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/keymasterd $(1)/usr/sbin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/keymaster-eventmond $(1)/usr/sbin
endef

$(eval $(call GoBinPackage,keymaster))
$(eval $(call BuildPackage,keymaster))

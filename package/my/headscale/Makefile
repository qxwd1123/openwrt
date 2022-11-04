# SPDX-Identifier-License: GPL-3.0-only
#
# Copyright (C) 2021 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=headscale
PKG_VERSION:=0.22.3
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/juanfont/headscale/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=ee408065c879fc5148a10050d663f93148eccdd6bf59d3b953673a36eaad4070

PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILE:=LICENSE
PKG_MAINTAINER:=a <a@a>

PKG_CONFIG_DEPENDS:= \
	CONFIG_LIBRESPEED_GO_COMPRESS_GOPROXY \
	CONFIG_LIBRESPEED_GO_COMPRESS_UPX

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/juanfont/headscale
GO_PKG_BUILD_PKG:=github.com/juanfont/headscale/cmd/headscale
GO_PKG_LDFLAGS:=-s -w
COMPILE_TIME:= $(shell TZ=UTC-8 date '+%Y-%m-%d %H:%M:%S')
GO_PKG_LDFLAGS_X+= \
	$(GO_PKG).version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/headscale/config
config LIBRESPEED_GO_COMPRESS_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default n

config LIBRESPEED_GO_COMPRESS_UPX
	bool "Compress executable files with UPX"
	default y
endef

ifeq ($(CONFIG_LIBRESPEED_GO_COMPRESS_GOPROXY),y)
	export GO111MODULE=on
	export GOPROXY=https://goproxy.io
endif

define Package/headscale
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=headscale
  URL:=https://github.com/juanfont/headscale
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
ifeq ($(CONFIG_GOST_COMPRESS_UPX),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/headscale
endif
endef

define Package/headscale/conffiles
/etc/headscale/config.yaml
endef

define Package/headscale/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	sed -i 's;magic_dns.*;magic_dns: false;' $(PKG_BUILD_DIR)/config-example.yaml
	sed -i 's;/var/lib;/etc;' $(PKG_BUILD_DIR)/config-example.yaml
	$(INSTALL_DIR) $(1)/etc/headscale
	$(CP) $(PKG_BUILD_DIR)/config-example.yaml $(1)/etc/headscale/config.yaml
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/headscale.init $(1)/etc/init.d/headscale
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/headscale $(1)/usr/sbin
endef

$(eval $(call GoBinPackage,headscale))
$(eval $(call BuildPackage,headscale))

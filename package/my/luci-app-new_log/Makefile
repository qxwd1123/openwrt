include $(TOPDIR)/rules.mk

PKG_LICENSE:=GPLv2
PKG_MAINTAINER:=unknown
PKG_NAME:=luci-app-new_log
PKG_VERSION:=2016-01-30
PKG_RELEASE:=1

LUCI_TITLE:=Display syslog in descended

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-new_log
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=Display syslog in descended
endef

define Package/luci-app-new_log/description
	This package contains LuCI configuration pages for new_log.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef


define Package/luci-app-new_log/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view

	$(INSTALL_DATA) ./luasrc/controller/new_log.lua $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luasrc/view/new_log.htm $(1)/usr/lib/lua/luci/view
endef

$(eval $(call BuildPackage,luci-app-new_log))


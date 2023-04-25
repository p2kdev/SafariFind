export THEOS_PACKAGE_SCHEME=rootless
export TARGET = iphone:clang:13.7:13.0

THEOS_DEVICE_IP=192.168.1.145

PACKAGE_VERSION=$(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk

export ARCHS = arm64 arm64e

TWEAK_NAME = SafariFind
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileSafari"

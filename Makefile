export THEOS_DEVICE_IP = iPhone
export TARGET = iphone:clang:8.1
export ARCHS = armv7 arm64
export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0

include theos/makefiles/common.mk

TWEAK_NAME = ConfirmKill
ConfirmKill_FILES = Tweak.x BUIAlertView.m
ConfirmKill_FRAMEWORKS = UIKit CoreGraphics
ConfirmKill_CFLAGS ?= -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += confirmkillprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

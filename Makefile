THEOS_DEVICE_IP = iPad
TARGET := iphone:clang:8.1
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = ConfirmKill
ConfirmKill_FILES = Tweak.x BUIAlertView.m
ConfirmKill_FRAMEWORKS = UIKit CoreGraphics
ConfirmKill_CFLAGS ?= -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += confirmkillprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

TARGET = :clang:7.0
ARCHS = armv7

include theos/makefiles/common.mk

TWEAK_NAME = ConfirmKill
ConfirmKill_FILES = Tweak.x SRConfirmKillAlertItem.x
ConfirmKill_FRAMEWORKS = UIKit CoreGraphics
ConfirmKill_CFLAGS ?= -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += confirmkillprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

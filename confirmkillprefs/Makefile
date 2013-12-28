include ../theos/makefiles/common.mk

BUNDLE_NAME = ConfirmKillPrefs
ConfirmKillPrefs_FILES = ConfirmKillPrefs.mm
ConfirmKillPrefs_INSTALL_PATH = /Library/PreferenceBundles
ConfirmKillPrefs_FRAMEWORKS = UIKit
ConfirmKillPrefs_PRIVATE_FRAMEWORKS = Preferences
ConfirmKillPrefs_LIBRARIES = applist
ConfirmKillPrefs_CFLAGS?= -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ConfirmKillPrefs.plist$(ECHO_END)

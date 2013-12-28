#import <SpringBoard/SBAlertItemsController.h>
#import <SpringBoard/SBAppSliderController.h>
#import "SRConfirmKillAlertItem.h"

#define PREFS_PATH @"/var/mobile/Library/Preferences/com.sharedRoutine.confirmkill.plist"

@class SBAppSliderScrollingViewController;

BOOL original;
NSArray *confirmIDs;
NSDictionary *prefDict;

static void settingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {

prefDict = [NSDictionary dictionaryWithContentsOfFile:PREFS_PATH] ?: [NSDictionary dictionary];
confirmIDs = [prefDict objectForKey:@"ConfirmIDs"] ?: [NSArray array];

}

%hook SBAppSliderController

- (void)sliderScroller:(SBAppSliderScrollingViewController *)scroller itemWantsToBeRemoved:(NSUInteger)index {

    //SpringBoard
	if (index == 0) {

		%orig;
		return;
	}

    //Call original method instead of hook
	if (original) {

	 %orig;
	 [self setIsOriginal:FALSE];
	 return;

    }

    if ([confirmIDs containsObject:[self _displayIDAtIndex:index]]) {
	 
        SRConfirmKillAlertItem *alert = [[%c(SRConfirmKillAlertItem) alloc] initWithController:self index:index];
        [(SBAlertItemsController *)[%c(SBAlertItemsController) sharedInstance] activateAlertItem:alert];
       
    } else {

        %orig;

    }
}

%new 

-(void)setIsOriginal:(BOOL)isOrig {

    original = isOrig;

}

%end

%ctor {

CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,settingsChanged,CFSTR("com.sharedRoutine.confirmkill.settingschanged"),NULL,CFNotificationSuspensionBehaviorDeliverImmediately);

prefDict = [NSDictionary dictionaryWithContentsOfFile:PREFS_PATH] ?: [NSDictionary dictionary];
confirmIDs = [prefDict objectForKey:@"ConfirmIDs"] ?: [NSArray array];

}

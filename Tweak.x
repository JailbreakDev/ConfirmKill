#import "Headers.h"
#import "BUIAlertView.h"

static NSArray *confirmIDs;
void reloadPreferences();

static void settingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {

reloadPreferences();

}

void reloadPreferences() {
	CFPreferencesAppSynchronize(CFSTR("com.sharedRoutine.confirmkill"));
	confirmIDs = nil;
	confirmIDs = (__bridge_transfer NSArray *)CFPreferencesCopyAppValue(CFSTR("ConfirmIDs"),CFSTR("com.sharedRoutine.confirmkill"));
}

%group iOS8Hooks
%hook SBAppSwitcherController
-(void)switcherScroller:(id)arg1 displayItemWantsToBeRemoved:(SBDisplayItem *)item {
	void (^resetScrollViews)() = ^{
		for (UIScrollView *scrollView in ((UIScrollView *)[[self pageController] valueForKey:@"_scrollView"]).subviews) {
			if ([scrollView isKindOfClass:UIScrollView.class]) {
				scrollView.contentOffset = CGPointZero;
			}
		}
	};

	if ([confirmIDs containsObject:item.displayIdentifier]) {
		UIAlertController *alertController = [%c(UIAlertController) alertControllerWithTitle:@"Confirm Removal" message:@"Are you sure you want to close this App?" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *removeAction = [%c(UIAlertAction) actionWithTitle:@"Yes"
                                         style:UIAlertActionStyleDestructive
                                       handler:^(UIAlertAction *action) {
                                           %orig;
                                       }];
		UIAlertAction *keepAction = [%c(UIAlertAction) actionWithTitle:@"No"
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                           [UIView animateWithDuration:0.3f animations:resetScrollViews];
                                       }];
		[alertController addAction:keepAction];
		[alertController addAction:removeAction];
		[self presentViewController:alertController animated:YES completion:nil];
	} else {
		%orig;
	}
}

%end
%end

%group iOS7Hooks
%hook SBAppSliderController

-(void)sliderScroller:(id)arg1 itemWantsToBeRemoved:(unsigned)index {

	void (^resetScrollViews)() = ^{
		for (UIScrollView *scrollView in self.contentScrollView.subviews) {
			if ([scrollView isKindOfClass:UIScrollView.class]) {
				scrollView.contentOffset = CGPointZero;
			}
		}
	};
    if ([confirmIDs containsObject:[self _displayIDAtIndex:index]]) {
    	BUIAlertView *av = [[BUIAlertView alloc] initWithTitle:@"Confirm Removal" message:@"Are you sure you want to close this App?" delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes!", nil];
			[av showWithDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex, NSString *buttonTitle) {
	  		if ([buttonTitle isEqualToString:@"Yes!"]) {
	    		%orig;
	  		} else {
	  			[UIView animateWithDuration:0.3f animations:resetScrollViews];
	  		}
		}];
    } else {
    	%orig;
    }
}

%end
%end

%ctor {

	if (iOS8) {
		%init(iOS8Hooks);
	} else if (iOS7) {
		%init(iOS7Hooks);
	} 

	reloadPreferences();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,settingsChanged,CFSTR("com.sharedRoutine.confirmkill.settingschanged"),NULL,CFNotificationSuspensionBehaviorDeliverImmediately);

}

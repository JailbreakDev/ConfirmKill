#import "SRConfirmKillAlertItem.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBAppSliderController.h>
#import <UIKit/UIAlertView+Private.h>

@interface UIViewController (ScrollViewTest)

-(UIScrollView *)contentScrollView;

@end

SBAppSliderController *controller;
unsigned indexToBeRemoved;

%subclass SRConfirmKillAlertItem : SBAlertItem

%new

- (id)initWithController:(SBAppSliderController *)controller_ index:(unsigned)index_ {

	self = [self init];

	if (self) {

		controller = controller_;
		indexToBeRemoved = index_;
	}

	return self;
}

- (void)configure:(BOOL)configure requirePasscodeForActions:(BOOL)requirePasscode {
	
    %orig;

	((UIAlertView*)self.alertSheet).delegate = self;
	((UIAlertView*)self.alertSheet).title = @"Confirm Removal?";

	[((UIAlertView*)self.alertSheet) addButtonWithTitle:@"Kill it"];
	[((UIAlertView*)self.alertSheet) addButtonWithTitle:@"Cancel"];

	((UIAlertView*)self.alertSheet).forceHorizontalButtonsLayout = YES;
	((UIAlertView*)self.alertSheet).numberOfRows = 1;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {

	void (^resetScrollViews)() = ^{
		for (UIScrollView *scrollView in controller.contentScrollView.subviews) {

			if ([scrollView isKindOfClass:UIScrollView.class]) {

				scrollView.contentOffset = CGPointZero;
			}
		}
	};

	switch (index) {

		case 0: {

			resetScrollViews();
			
			if ([controller sliderScroller:controller.pageController isIndexRemovable:indexToBeRemoved]) {

                [controller setIsOriginal:TRUE];
                [controller sliderScroller:controller.pageController itemWantsToBeRemoved:indexToBeRemoved];

			}

			break;
		}

		case 1:

			[UIView animateWithDuration:0.3f animations:resetScrollViews];
            
			break;

	}

	[self dismiss];
}

%end

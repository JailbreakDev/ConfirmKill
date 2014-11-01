#import <CoreFoundation/CoreFoundation.h>
@interface SBAlertItem : NSObject <UIAlertViewDelegate>
-(void)configure:(BOOL)arg1 requirePasscodeForActions:(BOOL)arg2;
-(void)alertView:(id)arg1 clickedButtonAtIndex:(int)arg2;
@end

@interface SBAppSwitcherPageViewController : UIViewController {
	id _scrollView;
}
@end

@interface SBAppSwitcherController : UIViewController
@property (nonatomic,readonly) UIScrollView *contentScrollView;
-(void)switcherScroller:(id)arg1 displayItemWantsToBeRemoved:(id)arg2 ;
-(BOOL)switcherScroller:(id)arg1 isDisplayItemRemovable:(id)arg2 ;
-(SBAppSwitcherPageViewController *)pageController;
@end

@interface SBAppSliderController : UIViewController
@property (nonatomic,readonly) UIScrollView *contentScrollView;
-(void)sliderScroller:(id)arg1 itemWantsToBeRemoved:(unsigned)arg2 ;
-(BOOL)sliderScroller:(id)arg1 isIndexRemovable:(unsigned)arg2 ;
-(id)_displayIDAtIndex:(unsigned)arg1 ;
@end

@interface SBAppSliderScrollingViewController : UIViewController
@end

@interface SBDisplayItem : NSObject
@property (nonatomic,readonly) NSString* displayIdentifier;
@end

//CoreFoundation Numbers
#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_1
#define kCFCoreFoundationVersionNumber_iOS_7_1 847.24
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1140.10
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_1
#define kCFCoreFoundationVersionNumber_iOS_8_1 1141.14
#endif

#define iOS8 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0 \
&& kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_8_1

#define iOS7 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0 \
&& kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_7_1
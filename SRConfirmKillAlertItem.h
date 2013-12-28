/*
 Thanks to hashbang productions. Used part of their Code for the Alert
 */

#import <SpringBoardUI/SBAlertItem.h>

@class SBAppSliderController;

@interface SRConfirmKillAlertItem : SBAlertItem

- (instancetype)initWithController:(SBAppSliderController *)controller index:(unsigned)index;


@end

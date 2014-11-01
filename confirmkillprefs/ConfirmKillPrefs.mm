#import <libapplist/AppList.h>
#import <objc/runtime.h>

@interface PSViewController : UIViewController
- (id)initForContentSize:(CGSize)size;
@end

@interface SRConfirmKillPrefsController : PSViewController <UITableViewDelegate> {
    
    UITableView *_tableView;
    ALApplicationTableDataSource *_dataSource;
    
}
    
- (id)initForContentSize:(CGSize)size;
- (UIView *)view;
- (CGSize)contentSize;
- (id)navigationTitle;

@end

@interface SRConfirmKillAppsDataSource : ALApplicationTableDataSource <ALValueCellDelegate> {
    
    SRConfirmKillPrefsController *_controller;
}

- (id)initWithController:(SRConfirmKillPrefsController *)controller;

@end

@implementation SRConfirmKillPrefsController

- (id)initForContentSize:(CGSize)size {

    if ([[PSViewController class] instancesRespondToSelector:@selector(initForContentSize:)])
		self = [super initForContentSize:size];
	else
		self = [super init];
	
    if (self)  {
        
		CGRect frame;
		frame.origin = (CGPoint){0, 0};
		frame.size = size;
	
		_tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];

		BOOL isOS7 = (objc_getClass("UIAttachmentBehavior") != nil);
		if (isOS7) _tableView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);

		_dataSource = [[SRConfirmKillAppsDataSource alloc] initWithController:self];
		NSNumber *iconSize = [NSNumber numberWithUnsignedInteger:ALApplicationIconSizeSmall];
		NSArray *sectionDescriptors = [NSArray arrayWithObjects: [NSDictionary dictionaryWithObjectsAndKeys:@"Available Apps", ALSectionDescriptorTitleKey, @"ALCheckCell", ALSectionDescriptorCellClassNameKey, iconSize, ALSectionDescriptorIconSizeKey, (id)kCFBooleanTrue, ALSectionDescriptorSuppressHiddenAppsKey,
								  nil], nil];
		_dataSource.sectionDescriptors = sectionDescriptors;

		[_tableView setDataSource:_dataSource];
		[_tableView setDelegate:self];
		[_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin];
    }
	return self;
}

- (UIView *)view
{
	return _tableView;
}

- (UITableView *)table
{
    return _tableView;
}

- (CGSize)contentSize
{
	return [_tableView frame].size;
}

- (id)navigationTitle
{
    return @"Available Apps";
}

- (NSString *)title
{
    return @"Available Apps";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [_tableView cellForRowAtIndexPath:indexPath];
    [cell didSelect];
}

- (void)cellAtIndexPath:(NSIndexPath *)indexPath didChangeToValue:(id)newValue
{
    NSString *identifier = [_dataSource displayIdentifierForIndexPath:indexPath];
    NSMutableArray *filteredApps = [(__bridge_transfer NSArray *)CFPreferencesCopyAppValue(CFSTR("ConfirmIDs"),CFSTR("com.sharedRoutine.confirmkill")) mutableCopy]?: [NSMutableArray array];
    
    if ([newValue boolValue]) [filteredApps addObject:identifier];
    else if(![newValue boolValue]) [filteredApps removeObject:identifier];

    CFPreferencesSetAppValue(CFSTR("ConfirmIDs"),(__bridge CFArrayRef)filteredApps,CFSTR("com.sharedRoutine.confirmkill"));
    CFPreferencesAppSynchronize(CFSTR("com.sharedRoutine.confirmkill"));
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.sharedRoutine.confirmkill.settingschanged"), NULL, NULL, YES);
}

- (id)valueForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [_dataSource displayIdentifierForIndexPath:indexPath];
    NSArray *array = (__bridge_transfer NSArray *)CFPreferencesCopyAppValue(CFSTR("ConfirmIDs"),CFSTR("com.sharedRoutine.confirmkill")) ?: [NSArray array];

    return [NSNumber numberWithBool:[array containsObject:identifier]];
}

@end

@implementation SRConfirmKillAppsDataSource

- (id)initWithController:(SRConfirmKillPrefsController *)controller
{
	if ((self = [super init])) {
		_controller = controller;
	}
	return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALValueCell *cell = (ALValueCell *)[super tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    if ([cell isKindOfClass:[ALValueCell class]])
    {
		[cell setDelegate:self];
		[cell loadValue:[_controller valueForCellAtIndexPath:indexPath]];
    }
    return cell;
}

- (void)valueCell:(ALValueCell *)valueCell didChangeToValue:(id)newValue
{
	[_controller cellAtIndexPath:[self.tableView indexPathForCell:valueCell] didChangeToValue:newValue];
}

@end

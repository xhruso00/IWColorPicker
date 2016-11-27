#import <Cocoa/Cocoa.h>

@interface TMAColorChooserPopoverController : NSObject <NSPopoverDelegate>

+ (id)sharedPopoverController;
+ (void)showPopoverForTarget:(id)target;
+ (void)closePopover;
+ (BOOL)isPopoverShownForTarget:(id)target;
- (void)popoverDidClose:(id)sender;

@end

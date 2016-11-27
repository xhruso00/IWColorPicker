#import "TMAColorChooserPopoverController.h"
#import "TMAFillSwatchGridView.h"
#import "MyColorWell.h"
#import "TSKMacNSPopover.h"

__strong static NSPopover *mColorSwatchPickerPopover;
__strong static TMAColorChooserPopoverController *mColorSwatchPickerPopoverController;
__strong static TMAFillSwatchGridView *swatchGrid;
__weak id targetView;



@implementation TMAColorChooserPopoverController

+ (id)sharedPopoverController
{
    static dispatch_once_t swatchOnceToken1;
    dispatch_once (&swatchOnceToken1, ^{
        mColorSwatchPickerPopoverController = [[self alloc] init];
    });
    return mColorSwatchPickerPopoverController;
}
                   
+ (void)showPopoverForTarget:(id)target
{
    static dispatch_once_t swatchOnceToken2;
    dispatch_once (&swatchOnceToken2, ^{
        NSViewController *viewController = [[NSViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
        swatchGrid = [[TMAFillSwatchGridView alloc] initWithFrame:NSMakeRect(0, 0, 478, 228)];
        

        [swatchGrid setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSView *view = [[NSView alloc] init];
        [view addSubview:swatchGrid];
        
        
        [swatchGrid setAction:@selector(takeSelectedSwatchFrom:)];
        
        
        NSDictionary *dict = @{@"swatchGrid" : swatchGrid};
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[swatchGrid]-0-|" options:0 metrics:nil views:dict]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[swatchGrid]-0-|" options:0 metrics:nil views:dict]];
        
        [view setFrameSize:[view fittingSize]];
        [viewController setView:view];
        
        mColorSwatchPickerPopover = [[TSKMacNSPopover alloc] init];
        [mColorSwatchPickerPopover setContentViewController:viewController];
        [mColorSwatchPickerPopover setBehavior:NSPopoverBehaviorTransient];
        [mColorSwatchPickerPopover setAnimates:NO];
        [mColorSwatchPickerPopover setDelegate:[[self class] sharedPopoverController]];
        
        
    });
    
    [swatchGrid setTarget:target];
    
    if ([mColorSwatchPickerPopover isShown]) {
        [mColorSwatchPickerPopover close];
    }
    
    [mColorSwatchPickerPopover showRelativeToRect:[target bounds] ofView:target preferredEdge:NSRectEdgeMinY];
}

+ (void)closePopover
{
    [mColorSwatchPickerPopover close];
}

+ (BOOL)isPopoverShownForTarget:(id)target
{
    return target == targetView ? YES : NO;
}

- (void)popoverDidClose:(id)sender
{
    [targetView popoverDidClose];
    targetView = nil;
}

@end

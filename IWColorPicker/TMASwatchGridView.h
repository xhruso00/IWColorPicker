#import <Cocoa/Cocoa.h>
@class PPColorFill;

@interface TMASwatchGridView : NSControl

@property (nonatomic) PPColorFill *highlightedSwatch;
@property (nonatomic) PPColorFill *selectedSwatch;
@property (weak) id delegate;
@property(retain) NSTrackingArea *trackingArea;

@end

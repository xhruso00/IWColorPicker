#import "PPColorWell.h"
@class TMASwatchGridView;

@interface MyColorWell : PPColorWell {
    BOOL _activating;
    BOOL _dragging;
    BOOL _representsMixedState;
    NSUInteger _wellState;
    NSTrackingArea *_trackingArea;
    NSToolTipTag _colorButtonTag;
    NSToolTipTag _swatchTag;
}

@property(retain) NSTrackingArea *trackingArea;

- (void)takeSelectedSwatchFrom:(TMASwatchGridView *)sender;
- (void)popoverDidClose;

@end

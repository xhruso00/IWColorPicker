#import "MyColorWell.h"
#import "NSView+Additions.h"
#import "TMAColorChooserPopoverController.h"
#import "TMASwatchGridView.h"
#import "PPColorFill.h"

@implementation MyColorWell

- (void)awakeFromNib
{
    NSRect colorButtonFrame, swatchFrame;
    [self getColorButtonFrame:&colorButtonFrame swatchFrame:&swatchFrame];
    _colorButtonTag = [self addToolTipRect:colorButtonFrame owner:@"Click to show more colors or create your own." userData:@"TSApplication"];
    _swatchTag = [self addToolTipRect:swatchFrame owner:@"Click to choose a color." userData:@"TSApplication"];

    //[self updateTrackingAreas];
}

- (void)mouseExited:(NSEvent *)event
{
    [self setWellState:0];
}

- (void)mouseEntered:(NSEvent *)event
{
    if ([self isEnabled]) {
        NSPoint mouseLocation = [self mousePosition];//[self convertPoint:[event locationInWindow] fromView:nil];
        NSRect colorButtonFrame, swatchFrame;
        [self getColorButtonFrame:&colorButtonFrame swatchFrame:&swatchFrame];
        NSUInteger state = 3;
        if ([self mouse:mouseLocation inRect:swatchFrame]) {
            state = 1;
        }
        [self setWellState:state];
    }
}

- (void)mouseMoved:(NSEvent *)event
{
    NSPoint mouseLocation = [self mousePosition];//[self convertPoint:[event locationInWindow] fromView:nil];
    NSRect colorButtonFrame, swatchFrame;
    [self getColorButtonFrame:&colorButtonFrame swatchFrame:&swatchFrame];
    NSUInteger state = 3;
    if (NSMouseInRect(mouseLocation, swatchFrame, [self isFlipped])) {
        state = 1;
    }
    [self setWellState:state];
}

- (NSSize)intrinsicContentSize
{
    return NSMakeSize(66, 23);
}

- (NSEdgeInsets)alignmentRectInsets
{
    return NSEdgeInsetsMake(0, 0, 0, 0);
}

- (NSLayoutPriority)contentHuggingPriorityForOrientation:(NSLayoutConstraintOrientation)orientation
{
    return 0x443b800040c00000;
}

- (BOOL)isFlipped
{
    return NO;
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    [self removeTrackingArea:[self trackingArea]];
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self visibleRect]
                                                        options:NSTrackingInVisibleRect|NSTrackingActiveInKeyWindow|NSTrackingMouseMoved|NSTrackingMouseEnteredAndExited
                                                          owner:self
                                                       userInfo:nil];
    [self setTrackingArea:area];
    [self addTrackingArea:[self trackingArea]];
}

- (NSButtonCell *)colorButtonCell
{
    static NSButtonCell *colorButtonCell;
    if (!colorButtonCell) {
        NSImage *image = [NSImage imageNamed:@"sf-mac_insp_color_L3-CW"];
        colorButtonCell = [[NSButtonCell alloc] initImageCell:image];
        [colorButtonCell setBordered:NO];
        [colorButtonCell setTarget:self];
        [colorButtonCell setAction:@selector(showPopover:)];
        [colorButtonCell setButtonType:NSButtonTypeMomentaryPushIn];
        [colorButtonCell sendActionOn:NSEventMaskLeftMouseUp];
        [colorButtonCell setImageScaling:NO];
        [colorButtonCell setImageDimsWhenDisabled:YES];
    }
    return colorButtonCell;
}

- (id)multipleValuesPlaceholder
{
    return NULL;
}

- (BOOL)canDraw
{
    BOOL canDraw = YES;
    if ([self layer] == NO) {
        canDraw = [super canDraw];
    }
    return canDraw;
}

- (void)setColor:(NSColor *)color
{
    if (_activating) {
        return;
    }
    _representsMixedState = NO;
    if (color && [self multipleValuesPlaceholder] != color) {
        [super setColor:color];
    } else {
        if ([self multipleValuesPlaceholder] == color) {
            _representsMixedState = YES;
            color = [NSColor whiteColor];
        }
        if (!color) {
            color = [NSColor whiteColor];
        }
        _activating = YES;
        [super setColor:color];
        _activating = NO;
    }
}

- (Class)colorChooserPopoverControllerClass
{
    return [TMAColorChooserPopoverController class];
}

- (IBAction)togglePopover:(id)sender
{
    if ([[self colorChooserPopoverControllerClass] isPopoverShownForTarget:self]) {
        [[self colorChooserPopoverControllerClass] closePopover];
    }
    else {
        [self deactivate];
        [[self colorChooserPopoverControllerClass] showPopoverForTarget:self];
    }
    
//    NSPopover *popover = [self popover];
//    if ([popover isShown]) {
//        [popover close];
//    } else {
//        [popover showRelativeToRect:[sender frame]
//                             ofView:[sender superview]
//                      preferredEdge:[sender tag]];
//    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    if ([self isEnabled]) {
        NSImage *maskImage = [NSImage imageNamed:@"sf-mac_insp_color_L3-MASK"];
        NSGraphicsContext *context = [NSGraphicsContext currentContext];
        NSRect proposedRect = NSZeroRect;
        proposedRect.size = [maskImage size];
        CGImageRef cgImage = [maskImage CGImageForProposedRect:&proposedRect context:context hints:NULL];
        if (_representsMixedState) {
            NSImage *image2 = [NSImage imageNamed:@"sf-mac_insp_color_L3-MixedFill"];
            [image2 drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];
        } else {
            CGContextRef contextRef = [[NSGraphicsContext currentContext] graphicsPort];
            NSRect wellRect = NSMakeRect(0, 0, maskImage.size.width, maskImage.size.height);
            CGContextSaveGState(contextRef);
            CGContextClipToMask(contextRef, wellRect, cgImage);
            [super drawWellInside:wellRect];
            CGContextRestoreGState(contextRef);
        }
        NSUInteger state = 5;
        if (_dragging == NO) {
            state = _wellState;
            if ((state == 0x0) || (state == 0x3)) {
                if ([self isActive]) {
                    state = 0x5;
                }
            }
        }
        NSImage *image = [self imageForState:state];
        [image drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];
    } else {
        NSImage *image = [self imageForState:0];
        [image drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:0.5];
    }
    
    [[self colorButtonCell] setEnabled:[self isEnabled]];
    NSRect colorButtonFrame, swatchFrame;
    [self getColorButtonFrame:&colorButtonFrame swatchFrame:&swatchFrame];
    [[self colorButtonCell] drawWithFrame:colorButtonFrame inView:self];
}


- (void)getColorButtonFrame:(NSRect *)colorButtonFrame swatchFrame:(NSRect *)swatchFrame
{
    NSRect insectRect = [self bounds];
    CGRectDivide(insectRect, colorButtonFrame, swatchFrame, 20, CGRectMaxXEdge);
    CGRectInset(*swatchFrame, 0, 1);
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if ([self isEnabled] == NO) {
        return;
    }
    
    
    NSPoint mouseLocation = [self mousePosition];//[self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSRect colorButtonFrame, swatchFrame;
    [self getColorButtonFrame:&colorButtonFrame swatchFrame:&swatchFrame];
    if ([self mouse:mouseLocation inRect:colorButtonFrame]) {
        [[self colorChooserPopoverControllerClass] closePopover];
        [self setWellState:4];
        [super mouseDown:theEvent];
        [self setWellState:3];
    } else {
        [self setWellState:2];
        @autoreleasepool {
            while ((theEvent = [[self window] nextEventMatchingMask:(NSLeftMouseUpMask | NSLeftMouseDraggedMask)
                                                       untilDate:[NSDate distantFuture]
                                                          inMode:NSEventTrackingRunLoopMode
                                                         dequeue:YES]) &&
                   ([theEvent type] != NSLeftMouseUp && [theEvent type] != 0)) {
                
                if ([theEvent type] == NSLeftMouseDragged) {
                    NSPoint newMouseLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
                    
                    //unfinished
                    [self setWellState:0];
                    [super mouseDown:theEvent];
                    [[self window] sendEvent:theEvent];
                    return;
                }
            }
        }
        [self setWellState:1];
        [self togglePopover:self];
        
    }
}

- (void)activate:(BOOL)exclusive
{
    _activating = YES;
    [super activate:exclusive];
    _activating = NO;
}

- (void)popoverDidClose
{
    [self deactivate];
}

- (NSImage *)imageForState:(NSInteger)state
{
    NSString *extension = @"";
    switch (state) {
        case 0:
            extension = @"N";
            break;
        case 1:
            extension = @"H";
            break;
        case 2:
            extension = @"P";
            break;
        case 3:
            extension = @"CWH";
            break;
        case 4:
            extension = @"CWP";
            break;
        case 5:
            extension = @"CWF";
            break;
        case 6:
            extension = @"DRAG";
            break;
    }
    return [NSImage imageNamed:[@"sf-mac_insp_color_L3-" stringByAppendingString:extension]];
}

- (void)setWellState:(NSUInteger)wellState
{
    _wellState = wellState;
    [self setNeedsDisplay];
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSDragOperation operation = [super draggingEntered:sender];
    if (operation) {
        [self setDragging:YES];
    }
    return operation;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    BOOL result = [super performDragOperation:sender];
    [self setDragging:NO];
    return result;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    [super draggingExited:sender];
    [self setDragging:NO];
}

- (void)setDragging:(BOOL)dragging
{
    _dragging = dragging;
    [self setNeedsDisplay:YES];
}

- (void)takeSelectedSwatchFrom:(TMASwatchGridView *)sender
{
    id swatch = [sender highlightedSwatch];
    NSColor *color;
    if (swatch) {
        color = [swatch fillColor];
    } else {
        color = [NSColor clearColor];
    }
    ;
    [self setColor:color];
    [self sendAction:[self action] to:[self target]];
    [[self colorChooserPopoverControllerClass] closePopover];
}


@end

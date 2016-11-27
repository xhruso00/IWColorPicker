#import "PPColorWell.h"

static NSInteger _isColorWellActiveGlobal;

IB_DESIGNABLE
@implementation PPColorWell

+ (BOOL)colorWellIsActive
{
    return (BOOL)_isColorWellActiveGlobal;
}

+ (void)_colorWellDidBecomeInactive
{
    if (_isColorWellActiveGlobal == 0) {
        NSLog(@"Shouldn't happen");
        if (_isColorWellActiveGlobal) {
            _isColorWellActiveGlobal -= 1;
        }
    }
    else {
        _isColorWellActiveGlobal -= 1;
    }
    return;
}

+ (void)_colorWellWillBecomeActive
{
    _isColorWellActiveGlobal += 1;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    if (([self isActive]) && (_isCountedAsActive == NO)) {
        [[self class] _colorWellWillBecomeActive];
        _isCountedAsActive = YES;
    }
    else {
        if ([self isActive] == NO) {
            if (_isCountedAsActive) {
                _isCountedAsActive = NO;
                [[self class] _colorWellDidBecomeInactive];
            }
        }
    }
    return;
}

- (void)deactivate
{
    [super deactivate];
    if (_isCountedAsActive) {
        _isCountedAsActive = NO;
        [[self class] _colorWellDidBecomeInactive];
    }
    [[NSColorPanel sharedColorPanel] setShowsAlpha:NO];
}

- (void)activate:(BOOL)exclusive
{
    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    if (_isCountedAsActive == NO) {
        [[self class] _colorWellWillBecomeActive];
        _isCountedAsActive = YES;
    }
    [super activate:exclusive];
}



- (void)dealloc
{
    if (_isCountedAsActive) {
        [[self class] _colorWellDidBecomeInactive];
        _isCountedAsActive = NO;
    }
}


//- (void)drawRect:(NSRect)aRect
//{
//    CGFloat rectangleCornerRadius = 4.5f;
//    NSRect fullRectangle = [self bounds];
//
//
//    //// rightPart Drawing
//    NSRect rightPartRect = fullRectangle;
//    rightPartRect.size.width = 20.0f;
//    rightPartRect.origin.x = fullRectangle.size.width - rightPartRect.size.width;
//
//    NSRect rightPartInnerRect = NSInsetRect(rightPartRect, rectangleCornerRadius, rectangleCornerRadius);
//    NSBezierPath* rightPartPath = [NSBezierPath bezierPath];
//    [rightPartPath moveToPoint: NSMakePoint(NSMinX(rightPartRect), NSMinY(rightPartRect))];
//    [rightPartPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(rightPartInnerRect), NSMinY(rightPartInnerRect)) radius: rectangleCornerRadius startAngle: 270 endAngle: 360];
//    [rightPartPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(rightPartInnerRect), NSMaxY(rightPartInnerRect)) radius: rectangleCornerRadius startAngle: 0 endAngle: 90];
//    [rightPartPath lineToPoint: NSMakePoint(NSMinX(rightPartRect), NSMaxY(rightPartRect))];
//    [rightPartPath closePath];
//    [NSColor.grayColor setFill];
//    [rightPartPath fill];
//    [NSColor.blackColor setStroke];
//    [rightPartPath setLineWidth: 0.5];
//    [rightPartPath stroke];
//
//    //// leftPart Drawing
//    NSRect leftPartRect = fullRectangle;
//    leftPartRect.size.width -= rightPartRect.size.width;
//
//    NSRect leftPartInnerRect = NSInsetRect(leftPartRect, rectangleCornerRadius, rectangleCornerRadius);
//    NSBezierPath* leftPartPath = [NSBezierPath bezierPath];
//    [leftPartPath moveToPoint: NSMakePoint(NSMaxX(leftPartRect), NSMaxY(leftPartRect))];
//    [leftPartPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(leftPartInnerRect), NSMaxY(leftPartInnerRect)) radius: rectangleCornerRadius startAngle: 90 endAngle: 180];
//    [leftPartPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(leftPartInnerRect), NSMinY(leftPartInnerRect)) radius: rectangleCornerRadius startAngle: 180 endAngle: 270];
//    [leftPartPath lineToPoint: NSMakePoint(NSMaxX(leftPartRect), NSMinY(leftPartRect))];
//
//    [NSColor.grayColor setFill];
//    [leftPartPath fill];
//    [NSColor.blackColor setStroke];
//    [leftPartPath setLineWidth: 0.5];
//    [leftPartPath stroke];
//
//    if (NSPointInRect([self mousePosition], leftPartRect)) {
//        //// Oval Drawing
//        CGFloat ovalDiameter = 13;
//        NSRect ovalRect = NSInsetRect(leftPartRect, 0, (CGRectGetHeight(leftPartRect) - ovalDiameter) / 2);
//
//        ovalRect.size.width = ovalDiameter;
//        ovalRect.size.height = ovalDiameter;
//        ovalRect.origin.x += CGRectGetWidth(leftPartRect) - 4 - ovalDiameter;
//
//        NSBezierPath* ovalPath = [NSBezierPath bezierPathWithOvalInRect: ovalRect];
//        [NSColor.blackColor setFill];
//        [ovalPath fill];
//
//
//        //// V shape drawing
//        NSBezierPath* vShapeBezierPath = [NSBezierPath bezierPath];
//        [vShapeBezierPath moveToPoint: NSMakePoint(CGRectGetMidX(ovalRect) - 3.5, CGRectGetMidY(ovalRect) + 1.5)];
//        [vShapeBezierPath lineToPoint: NSMakePoint(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect) - 2)];
//        [vShapeBezierPath lineToPoint: NSMakePoint(CGRectGetMidX(ovalRect) + 3.5, CGRectGetMidY(ovalRect) + 1.5)];
//        [vShapeBezierPath setLineJoinStyle: NSBevelLineJoinStyle];
//        [NSColor.whiteColor setStroke];
//        [vShapeBezierPath setLineWidth: 1];
//        [vShapeBezierPath stroke];
//    }
//
//    if (NSPointInRect([self mousePosition], rightPartRect)) {
//        [[NSColor colorWithDeviceWhite:1.0 alpha:0.5] set];
//        [rightPartPath fill];
//    }
//}


@end

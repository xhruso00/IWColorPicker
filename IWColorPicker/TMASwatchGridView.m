#import "TMASwatchGridView.h"
#import "PPColorFill.h"
#import "NSView+Additions.h"

@interface TMASwatchGridView() {
    
}
@end

@implementation TMASwatchGridView

- (void)awakeFromNib
{
    [self updateTrackingAreas];
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        for (NSUInteger swatchIndex = 0; swatchIndex < [[self swatches] count]; swatchIndex++ ) {
            [self addSubview:[self swatches][swatchIndex]];
        }
    }
    return self;
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

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint mouseLocation = [self mousePosition];//[self convertPoint:[theEvent locationInWindow] fromView:nil];
    PPColorFill *swatch = [self swatchAtPoint:mouseLocation];
    if (swatch) {
        [self setHighlightedSwatch:swatch];
        [self selectSwatchAndNotifyTarget:swatch];
        [self setHighlightedSwatch:nil];
    }
    
}

- (void)setHighlightedSwatch:(PPColorFill *)highlightedSwatch
{
    if (!highlightedSwatch) {
        [_highlightedSwatch setHighlighted:NO];
    }
    _highlightedSwatch = highlightedSwatch;
    [highlightedSwatch setHighlighted:YES];
}

- (void)selectSwatchAndNotifyTarget:(id)swatch
{
//    if ([self allowsSelection]) {
//        [self setSelectedSwatch:swatch];
//    }
    [self sendAction:[self action] to:[self target]];
}

- (NSSize)swatchSize
{
    return NSMakeSize(37, 20);
}

- (NSSize)intrinsicContentSize
{
    return NSMakeSize(237, 114);
}

- (NSSize)swatchSpacing
{
    return NSMakeSize(1, 1);
}

- (NSArray <PPColorFill *> *)swatches
{
    static NSArray *swatches;
    if (!swatches) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:30];
        for (NSUInteger colorIndex = 0; colorIndex < [[self colors] count]; colorIndex++) {
            NSRect frame = [[self frames][colorIndex] rectValue];
            NSColor *color = [self colors][colorIndex];
            PPColorFill *swatch = [[PPColorFill alloc] initWithFrame:frame];
            [swatch setFillColor:color];
            [array addObject:swatch];
        }
        swatches = [array copy];
    }
    return swatches;
}

- (NSEdgeInsets)margins
{
    return NSEdgeInsetsMake(5, 5, 5, 5);
}

- (NSUInteger)rowCount
{
    NSUInteger numberOfSwatches = [[self swatches] count];
    NSUInteger rowCount = numberOfSwatches / [self columnCount];
    if (numberOfSwatches % [self columnCount]) {
        rowCount++;
    }
    return rowCount;
}

- (NSUInteger)columnCount
{
    return 6;
}

- (BOOL)isFlipped
{
    return YES;
}

- (id)swatchAtPoint:(NSPoint)point
{
    for (id swatch in [self swatches]) {
        if (NSPointInRect(point, [swatch frame])) {
            return swatch;
        }
    }
    return nil;
}

- (NSUInteger)indexForSwatchAtPoint:(NSPoint)point
{
    return 0;
}

- (NSUInteger)indexOfObject:(id)swatch
{
    return [[self swatches] indexOfObject:swatch];
}

- (NSRect)frameForSwatch:(id)swatch
{
    NSUInteger index = [[self swatches] indexOfObject:swatch];
    if (index != NSNotFound) {
        return [self frameForSwatchAtIndex:index];
    }
    return NSZeroRect;
}

- (NSRect)frameForSwatchAtIndex:(NSUInteger)index
{
    NSRect rect = NSZeroRect;
    if (index <= [[self swatches] count]) {
        rect = [[self frames][index] rectValue];
    }
    return rect;
}

- (NSArray <NSValue *> *)frames
{
    static NSArray *frames;
    if (!frames) {
        frames = @[[NSValue valueWithRect:NSMakeRect(5,5,37,20)],
                   [NSValue valueWithRect:NSMakeRect(43,5,37,20)],
                   [NSValue valueWithRect:NSMakeRect(81,5,37,20)],
                   [NSValue valueWithRect:NSMakeRect(119,5,37,20)],
                   [NSValue valueWithRect:NSMakeRect(157,5,37,20)],
                   [NSValue valueWithRect:NSMakeRect(195,5,37,20)],
                   [NSValue valueWithRect:NSMakeRect(5,26,37,20)],
                   [NSValue valueWithRect:NSMakeRect(43,26,37,20)],
                   [NSValue valueWithRect:NSMakeRect(81,26,37,20)],
                   [NSValue valueWithRect:NSMakeRect(119,26,37,20)],
                   [NSValue valueWithRect:NSMakeRect(157,26,37,20)],
                   [NSValue valueWithRect:NSMakeRect(195,26,37,20)],
                   [NSValue valueWithRect:NSMakeRect(5,47,37,20)],
                   [NSValue valueWithRect:NSMakeRect(43,47,37,20)],
                   [NSValue valueWithRect:NSMakeRect(81,47,37,20)],
                   [NSValue valueWithRect:NSMakeRect(119,47,37,20)],
                   [NSValue valueWithRect:NSMakeRect(157,47,37,20)],
                   [NSValue valueWithRect:NSMakeRect(195,47,37,20)],
                   [NSValue valueWithRect:NSMakeRect(5,68,37,20)],
                   [NSValue valueWithRect:NSMakeRect(43,68,37,20)],
                   [NSValue valueWithRect:NSMakeRect(81,68,37,20)],
                   [NSValue valueWithRect:NSMakeRect(119,68,37,20)],
                   [NSValue valueWithRect:NSMakeRect(157,68,37,20)],
                   [NSValue valueWithRect:NSMakeRect(195,68,37,20)],
                   [NSValue valueWithRect:NSMakeRect(5,89,37,20)],
                   [NSValue valueWithRect:NSMakeRect(43,89,37,20)],
                   [NSValue valueWithRect:NSMakeRect(81,89,37,20)],
                   [NSValue valueWithRect:NSMakeRect(119,89,37,20)],
                   [NSValue valueWithRect:NSMakeRect(157,89,37,20)]];
    }
    return  frames;
}

- (NSArray <NSColor *> *)colors
{
    static NSArray *colors;
    if (!colors) {
        colors = @[[NSColor colorWithSRGBRed:0.391165 green:0.699916 blue:0.87393 alpha:1],
                   [NSColor colorWithSRGBRed:0.611963 green:0.883772 blue:0.349233 alpha:1],
                   [NSColor colorWithSRGBRed:1 green:0.879851 blue:0.38085 alpha:1],
                   [NSColor colorWithSRGBRed:1 green:0.753292 blue:0.446601 alpha:1],
                   [NSColor colorWithSRGBRed:1 green:0.37351 blue:0.36791 alpha:1],
                   [NSColor colorWithSRGBRed:0.6168 green:0.269032 blue:0.72253 alpha:1],
                   [NSColor colorWithSRGBRed:0.2852 green:0.607868 blue:0.789721 alpha:1],
                   [NSColor colorWithSRGBRed:0.430946 green:0.754452 blue:0.218967 alpha:1],
                   [NSColor colorWithSRGBRed:0.945922 green:0.818509 blue:0.190005 alpha:1],
                   [NSColor colorWithSRGBRed:1 green:0.664332 blue:0.228824 alpha:1],
                   [NSColor colorWithSRGBRed:1 green:0.175189 blue:0.130693 alpha:1],
                   [NSColor colorWithSRGBRed:0.422492 green:0.126634 blue:0.522057 alpha:1],
                   [NSColor colorWithSRGBRed:0.211048 green:0.489433 blue:0.636362 alpha:1],
                   [NSColor colorWithSRGBRed:0.475715 green:0.683055 blue:0.239445 alpha:1],
                   [NSColor colorWithSRGBRed:0.888136 green:0.720622 blue:0.00312815 alpha:1],
                   [NSColor colorWithSRGBRed:0.927138 green:0.62414 blue:0.181277 alpha:1],
                   [NSColor colorWithSRGBRed:0.809903 green:0.135454 blue:0.168689 alpha:1],
                   [NSColor colorWithSRGBRed:0.331914 green:0.0763713 blue:0.421744 alpha:1],
                   [NSColor colorWithSRGBRed:0.0894941 green:0.341924 blue:0.472526 alpha:1],
                   [NSColor colorWithSRGBRed:0.341573 green:0.529122 blue:0.147189 alpha:1],
                   [NSColor colorWithSRGBRed:0.777768 green:0.576669 blue:0 alpha:1],
                   [NSColor colorWithSRGBRed:0.821363 green:0.496803 blue:0.0819408 alpha:1],
                   [NSColor colorWithSRGBRed:0.681926 green:0.0985427 blue:0.0852828 alpha:1],
                   [NSColor colorWithSRGBRed:0.23534 green:0.0394902 blue:0.288075 alpha:1],
                   [NSColor colorWithSRGBRed:0.999939 green:1 blue:0.999878 alpha:1],
                   [NSColor colorWithSRGBRed:0.749844 green:0.749951 blue:0.749813 alpha:1],
                   [NSColor colorWithSRGBRed:0.499794 green:0.49987 blue:0.499763 alpha:1],
                   [NSColor colorWithSRGBRed:0.249805 green:0.249836 blue:0.249805 alpha:1],
                   [NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:1]];
    }
    return colors;
}

@end

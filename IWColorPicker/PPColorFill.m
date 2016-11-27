#import "PPColorFill.h"

@interface PPColorFill()

@end

@implementation PPColorFill

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        _highlighted = NO;
        [self setWantsLayer:YES];
    }
    return self;
}

- (void)updateLayer
{
    self.layer.backgroundColor = [[self fillColor] CGColor];
    self.layer.borderColor = [[NSColor colorWithWhite:0 alpha:0.15] CGColor];
    self.layer.borderWidth = 1;
    if (!_highlighted) {
    }
}

- (id)color
{
    if ([self fillColor] == NULL) {
        return [NSNull null];
    }
    return _fillColor;
}

- (void)setFillColor:(NSColor *)fillColor
{
    _fillColor = fillColor;
    [[self layer] setNeedsDisplay];
}

- (void)setHighLighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    [[self layer] setNeedsDisplay];
}

@end

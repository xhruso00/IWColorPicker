#import "NSView+Additions.h"

@implementation NSView(Additions)

- (BOOL)isFirstResponder
{
  return ([[self window] firstResponder] == self) ? YES : NO;
}

- (NSPoint)mousePosition
{
  NSPoint screenPoint = [NSEvent mouseLocation];
  NSRect rect = [[self window] convertRectFromScreen:NSMakeRect(screenPoint.x, screenPoint.y, 0, 0)]; //mozno 1.0, 1.0
  NSPoint windowPoint = rect.origin;
  NSPoint point = [self convertPoint:windowPoint fromView:nil];
  return point;
}

@end

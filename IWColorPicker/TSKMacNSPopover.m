#import "TSKMacNSPopover.h"

@implementation TSKMacNSPopover

- (instancetype)init
{
    return [self initWithAppearanceTheme:nil];
}

- (instancetype)initWithAppearanceTheme:(NSString *)themeName
{
    self = [super init];
    if (self) {
        if (themeName) {
            [self setAppearance:[NSAppearance appearanceNamed:themeName]];
        } else {
            //http://stackoverflow.com/questions/19978620/how-to-change-nspopover-background-color-include-triangle-part/30660945#30660945
            [self setAppearance:[NSAppearance appearanceNamed:@"TSKMacDefaultAppearanceTheme"]];
        }
    }
    return self;
}

- (void)setAppearanceTheme:(NSString *)themeName
{
    [self setAppearance:[NSAppearance appearanceNamed:themeName]];
}

@end

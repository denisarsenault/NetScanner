#import "EventActionEditor.h"


@implementation EventActionEditor

- (id) initWithAction:(EventAction*) action
{
    self = [super init];
    [self setAction:action];
    return self;
}

#pragma mark accessors

- (void) setAction:(EventAction*) action
{
    [edited release];
    edited = [action retain];
}

- (EventAction*) action
{
    return [[edited retain] autorelease];
}

@end

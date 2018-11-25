#import "EventAction.h"


@implementation EventAction

+ (EventAction*) action
{
    return [[EventAction new] autorelease];
}

- (id) init
{
    self = [super init];
    enabled = NO;
    return self;
}

/* the default event action does not succeed */
- (BOOL) performAction
{
    NSLog( @"EventAction no action performed");
    return NO;   
}

- (BOOL) enabled
{
    return enabled;
}

- (void) setEnabled:(BOOL) on
{
    enabled = on;
}

@end

/*  Copyright (c) 2005, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */
#import "Event.h"
#import "EventTrigger.h"
#import "EventAction.h"

@implementation Event

- (id) init
{
    self = [super init];
    actions = [NSMutableArray new];
    label = @"Untitled Event";
    return self;
}

- (void)dealloc
{
    [self setTrigger:nil];
    [self setLabel:nil];
    [actions release];
    actions = nil;
    [super dealloc];
}

- (EventTrigger *)trigger
{
    return [[trigger retain] autorelease]; 
}

- (void)setTrigger:(EventTrigger *)aTrigger
{
    if (trigger != aTrigger)
    {
        [trigger release];
        trigger = [aTrigger retain];
    }
}


- (NSString *)label
{
    return [[label retain] autorelease]; 
}

- (void)setLabel:(NSString *)aLabel
{
    if (label != aLabel)
    {
        [label release];
        label = [aLabel retain];
    }
}

- (BOOL)enabled
{
    return enabled;
}

- (void)setEnabled:(BOOL)flag
{
    enabled = flag;
    [trigger setArmed:enabled];
}

- (void)addAction:(EventAction*) action
{
    [actions addObject:action];
}

- (int)countActions
{
    return [actions count];
}

- (EventAction*) actionAtIndex:(int) index
{
    return (EventAction*) [actions objectAtIndex:index];
}

- (NSArray*) actions
{
    return [NSArray arrayWithArray:actions];
}

- (void) triggerFired:(NSNotification*) note
{
    NSLog(@"event trigger fired %@", note);
    NSEnumerator* todo = [actions objectEnumerator];
    EventAction* doing;
    while ( doing = (EventAction*) [todo nextObject])
    {
        @try
        {
            if (![doing performAction])
                NSLog(@"action failed to perform: %@", doing);
        }
        @catch(NSException* whoops)
        {
            NSLog(@"exception performing action: %@", whoops);
        }
    }
}

@end

/*  Copyright (c) 2005, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */
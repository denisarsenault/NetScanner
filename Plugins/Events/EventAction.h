#import <Cocoa/Cocoa.h>

@class Event;

@interface EventAction : NSObject 
{
    BOOL enabled;
}

+ (EventAction*) action;

/** perform the action of the event, return true 
    if the action was sucessful */
- (BOOL) performAction;

- (BOOL) enabled;
- (void) setEnabled:(BOOL) on;

@end

/*  Copyright (c) 2005, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */
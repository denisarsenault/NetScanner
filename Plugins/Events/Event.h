#import <Cocoa/Cocoa.h>

@class EventTrigger;
@class EventAction;

@interface Event : NSObject 
{
    NSString* label;
    BOOL enabled;
    EventTrigger* trigger;
    NSMutableArray* actions;
}

- (NSString *)label;
- (void)setLabel:(NSString *)aLabel;
- (BOOL)enabled;
- (void)setEnabled:(BOOL)flag;
- (EventTrigger *)trigger;
- (void)setTrigger:(EventTrigger *)aTrigger;
- (void)addAction:(EventAction*) action;
- (int)countActions;
- (EventAction*) actionAtIndex:(int) index;
- (NSArray*) actions;

- (void) triggerFired:(NSNotification*) note;

@end

/*  Copyright (c) 2005, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */
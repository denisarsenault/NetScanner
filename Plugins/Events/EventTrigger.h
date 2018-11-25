#import <Cocoa/Cocoa.h>

#import "Event.h"

/* event trigger base class, defines the interface and default implementation */
@interface EventTrigger : NSObject 
{
    IBOutlet NSView* trigger_view;
    NSString* notification;
    BOOL armed;
    Event* event;
}

- (id) initWithNotification:(NSString*) note_name event:(Event*) evnt;

- (BOOL) armed;
- (void) setArmed:(BOOL)flag;

/* this is the NSNotification that the trigger listens for */
- (NSString*) triggerNotification;

/* this selector is registered in the notification center,
    it must check for the required trigger condition and foward
    the notificaiton to the Event associated with the Trigger */
- (void) fireTrigger:(NSNotification*) note;

/* sets the event that the trigger will notify when fired */
- (void) setEvent:(Event*) event;
- (Event*) event;

@end

/*  Copyright (c) 2005, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */
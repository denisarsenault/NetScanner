#import "EventTrigger.h"


@implementation EventTrigger

- (id) initWithNotification:(NSString*) note_name event:(Event*) evnt
{
    self = [super init];
    notification = [note_name retain];
    [self setEvent:evnt];
    return self;
}

- (void) dealloc
{
    [notification release];
    notification = nil;
    [self setEvent:nil];
    [super dealloc];
}

- (BOOL) armed
{
    return armed;
}

- (void) setArmed:(BOOL)flag
{
    armed = flag;

    if ( armed)
    {
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(fireTrigger:)
                   name:[self triggerNotification]
                 object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]
            removeObserver:self];
    }
}

/* this is the NSNotification that the trigger listens for */
- (NSString*) triggerNotification
{
    return nil;
}

/* this selector is registered with the notification center */
- (void) fireTrigger:(NSNotification*) note
{
    NSLog( @"EventTrigger fired by %@", note);
    if ( event) [event triggerFired:note];
}

/* sets the event that the trigger will notify when fired */
- (void) setEvent:(Event*) evnt
{
    [event release];
    event = [evnt retain];
}

- (Event*) event
{
    return [[event retain] autorelease];   
}

@end

/*  Copyright (c) 2005, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */
#import <Cocoa/Cocoa.h>
#import <Plugins/Plugins.h>
#import "Event.h"
#import "EventEditor.h"

@interface EventsPlugin : Plugin 
{
    IBOutlet NSView* events_view;
    IBOutlet NSView* events_preferences;
    IBOutlet NSView* events_inspector;
    
    IBOutlet NSTableView* events_table;
    
    IBOutlet NSButton* events_toolbar_new;
    IBOutlet NSButton* events_toolbar_edit;
    IBOutlet NSButton* events_toolbar_delete;
    
    IBOutlet NSTextField* events_inspector_label;
    IBOutlet NSTextField* events_inspector_trigger;
    IBOutlet NSTextField* events_inspector_actions;
    
    // outlet?
    IBOutlet EventEditor* event_editor;
            
    NSMutableArray* events;
            
    NSToolbar* toolbar;
}

- (void) addEvent:(Event*) event;
- (int) countEvents;
- (Event*) eventAtIndex:(int) index;
- (NSArray*) events;

#pragma mark IBActions

- (IBAction) onToolbarNew:(id) sender;
- (IBAction) onToolbarEdit:(id) sender;
- (IBAction) onToolbarDelete:(id) sender;

@end

/*  Copyright (c) 2005, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */
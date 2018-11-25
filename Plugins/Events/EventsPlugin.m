#import "EventsPlugin.h"


@implementation EventsPlugin

- (id) initWithBundle:(NSBundle*) bundle
{
    self = [super initWithBundle:bundle];
    events = [[NSMutableArray array] retain];
    toolbar = [[NSToolbar alloc] initWithIdentifier:[self pluginIdentifier]];
    
    [[NSNotificationCenter defaultCenter] 
        addObserver:self
           selector:@selector(onEventUpdate:)
               name:@"event.update"
             object:nil];
     
    return self;
}

- (void) awakeFromNib
{
    [toolbar setDelegate:self];
    [events_table setDataSource:self];
    [events_table setDelegate:self];
}

- (void) dealloc
{
    [events release];
    events = nil;
    [toolbar release];
    toolbar = nil;
    [super dealloc];   
}

#pragma mark accessors 

- (void) addEvent:(Event*) event
{
    [events addObject:event];
}

- (int) countEvents
{
    return [events count];
}

- (Event*) eventAtIndex:(int) index
{
    return (Event*) [events objectAtIndex:index];
}

- (NSArray*) events
{
    return [NSArray arrayWithArray:events];
}

- (Event*) selectedEvent
{
    int index = [events_table selectedRow];
    return index >= 0 ? [self eventAtIndex:index] : nil;
}

#pragma mark Plugin Methods

- (NSView*) pluginView
{
    return events_view;   
}

- (NSToolbar*) pluginToolbar
{
    return toolbar;   
}

- (NSView*) pluginInspector
{
    return events_inspector;
}

- (NSView*) pluginPreferences
{
    return events_preferences;
}

#pragma mark IBActions

- (IBAction) onToolbarNew:(id) sender
{
    [self addEvent:[[Event new] autorelease]];
    [events_table reloadData];

    [events_table selectRow:[events count]-1 byExtendingSelection:NO];
    [self onToolbarEdit:events_toolbar_edit];    
}

- (IBAction) onToolbarEdit:(id) sender
{
    int index = [events_table selectedRow];
    if ( index >= 0)
    {
        Event* selected = [self eventAtIndex:index];

        // setup the editor 
        [event_editor setEvent:selected];
        [event_editor showEditor];
    }
}

- (IBAction) onToolbarDelete:(id) sender
{
    int selected = [events_table selectedRow];
    if (selected >= 0)
        [events removeObjectAtIndex:selected];
    [events_table reloadData];
}

#pragma mark NSTableDataSource

- (int) numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [events count];
}

- (id) tableView:(NSTableView*) table 
objectValueForTableColumn:(NSTableColumn*) column
             row:(int) index
{
    id value = nil;
    
    if ( [@"event.on" isEqualToString:[column identifier]])
    {
        value = [NSNumber numberWithBool:[[self eventAtIndex:index] enabled]];
    }
    else if ( [@"event.label" isEqualToString:[column identifier]])
    {
        value = [[self eventAtIndex:index] label];
    }
    else
    {
        value = @"!";    
    }

    return value;
}

- (void) tableView:(NSTableView*) table
    setObjectValue:(id)value
    forTableColumn:(NSTableColumn*) column
               row:(int)row
{
    if ( [@"event.enabled" isEqualToString:[column identifier]])
    {
        NSLog( @"event.enabed %@", value);
    }
}

- (void) tableViewSelectionDidChange:(NSNotification*) aNotification
{
    Event* selected = [self selectedEvent];
    // toido update inspector
    if (selected)
    {
        [events_inspector_label setStringValue:[selected label]];
        EventTrigger* trigger = [selected trigger];
        [events_inspector_trigger setStringValue:
                trigger!=nil ? [trigger description] : @""];
        // TODO list the actions one per line   
        // [events_inspector_actions setStringValue:];
    }
    else
    {
        [events_inspector_label setStringValue:@""];
        [events_inspector_trigger setStringValue:@""];
        [events_inspector_actions setStringValue:@""];
    }
}


#pragma mark NSToolbar delgate methods

- (NSToolbarItem*) toolbar:(NSToolbar*) toolbar
     itemForItemIdentifier:(NSString*) identifier
 willBeInsertedIntoToolbar:(BOOL) flag
{
    NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:identifier] autorelease];

    if ( [@"events.new" isEqualToString:identifier])
    {
        [item setLabel:[events_toolbar_new stringValue]];
        [item setView:events_toolbar_new];
        [item setMinSize:[events_toolbar_new frame].size];
//        [item setAction:@selector(onToolbarNew:)];
    }
    else if ( [@"events.edit" isEqualToString:identifier])
    {
        [item setLabel:[events_toolbar_edit stringValue]];
        [item setView:events_toolbar_edit];
        [item setMinSize:[events_toolbar_edit frame].size];
//        [item setAction:@selector(onToolbarEdit:)];
    }
    else if ( [@"events.delete" isEqualToString:identifier])
    {
        [item setLabel:[events_toolbar_delete stringValue]];
        [item setView:events_toolbar_delete];
        [item setMinSize:[events_toolbar_delete frame].size];
//        [item setAction:@selector(onToolbarDelete:)];
    }
    
    [item setPaletteLabel:[item label]];
    
    return item;
}

- (NSArray*) toolbarAllowedItemIdentifiers:(NSToolbar*) toolbar
{
    return [NSArray arrayWithObjects:
        NSToolbarSpaceItemIdentifier,
        NSToolbarFlexibleSpaceItemIdentifier,
        @"events.new",
        @"events.edit",
        @"events.delete",
        nil];
}


- (NSArray*) toolbarDefaultItemIdentifiers:(NSToolbar*) toolbar
{
    return [NSArray arrayWithObjects:        
        NSToolbarFlexibleSpaceItemIdentifier,
        @"events.new",
        @"events.edit",
        @"events.delete",
        nil];
}

#pragma mark NSNotifications

- (void) onEventUpdate:(NSNotification*) note
{
    [events_table reloadData];
    [events_table selectRow:[events indexOfObject:[note object]]
       byExtendingSelection:NO];
    [events_table performSelectorOnMainThread:@selector(setNeedsDisplay:)
                                  withObject:[NSNumber numberWithBool:YES]
                               waitUntilDone:NO];
    [self tableViewSelectionDidChange:nil];
}


@end

/*  Copyright (c) 2005, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */
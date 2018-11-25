#import "EventEditor.h"
#import <Plugins/PluginEnvironment.h>

@implementation EventEditor

- (id) init
{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] 
        addObserver:self
           selector:@selector(onActionUpdate:)
               name:@"event.action.update"
             object:nil];
    
    return self;
}

- (void) awakeFromNib
{
    [event_actions_table setDataSource:self];
    [self onEventTriggerType:event_trigger_type];
}

- (void) setEvent:(Event*) evnt
{
    edited = [evnt retain];
    NSString* label = [edited label];
    [event_editor_label setStringValue:label?label:@""];
    [event_actions_table reloadData];
    // TODO reset the trigger type pop-up
}

- (Event*) event
{
    return [[edited retain] autorelease];
}

/** starts the editor sheet */
- (void) showEditor
{
    NSWindow* istumbler = [[PluginEnvironment defaultEnvironment]
        applicationWindow];
    [event_actions_table reloadData];
    [NSApp beginSheet:editor_sheet
       modalForWindow:istumbler
        modalDelegate:self
       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
          contextInfo:nil];
}

- (void) didEndSheet:(NSWindow *)sheet
          returnCode:(int)returnCode
         contextInfo:(void*)contextInfo
{
    [sheet orderOut:self];
}

#pragma mark IBActions

- (IBAction) onEventEditorOK:(id)sender
{
    [edited setLabel:[event_editor_label stringValue]];
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"event.update"
                      object:edited];
    [NSApp endSheet:editor_sheet];
    [self setEvent:nil];
}

- (IBAction) onEventEditorCancel:(id)sender
{
    // TODO revert the trigger and action list
    [NSApp endSheet:editor_sheet];
    [self setEvent:nil];
}

- (IBAction) onEventTriggerType:(id)sender
{
    int type = [[sender selectedItem] tag];

    switch (type)
    {
        case 1:
            [event_trigger_box setContentView:radio_trigger_view]; 
            break;
            
        case 2:
            [event_trigger_box setContentView:notification_trigger_view];
            break;
                
        default:
            [event_trigger_box setContentView:nil];
            break;
    }
}

- (IBAction) onEventNewAction:(id)sender
{
    [edited addAction:[EventAction action]];
    [event_actions_table reloadData];
}

- (IBAction) onEventDeleteAction:(id)sender
{
    // TODO figure out the selected action...
}


#pragma mark NSNotifications

- (void) onActionUpdate:(NSNotification*) note
{
    [event_actions_table reloadData];
}

#pragma mark NSTableViewDelegate

- (int) numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [edited countActions];
}

- (id) tableView:(NSTableView*) table 
objectValueForTableColumn:(NSTableColumn*) column
             row:(int) index
{
    id value = nil;
    
    if ( [@"action.on" isEqualToString:[column identifier]])
    {
        value = [NSNumber numberWithBool:
            [[edited actionAtIndex:index] enabled]];
    }
    else if ( [@"action.view" isEqualToString:[column identifier]])
    {
        value = @"view";
    }
    else
    {
        value = @"!";    
    }
    
    return value;
}

@end

#import <Cocoa/Cocoa.h>

#import "Event.h"
#import "EventTrigger.h"
#import "EventAction.h"

@interface EventEditor : NSObject 
{
    IBOutlet NSWindow* editor_sheet;
    IBOutlet NSTextField* event_editor_label;
    IBOutlet NSPopUpButton* event_trigger_type;
    IBOutlet NSBox* event_trigger_box;
    IBOutlet NSTableView* event_actions_table;

    // views for the trigger type box
    
    IBOutlet NSView* radio_trigger_view;
    IBOutlet NSView* notification_trigger_view;
    
    // views for the action boxes?
    
    NSMutableDictionary* trigger_types; /* trigger class to label */

    Event* edited;
}

#pragma mark methods

- (void) setEvent:(Event*) evnt;
- (Event*) event;

/** starts the editor sheet */
- (void) showEditor;

#pragma mark IBActions

- (IBAction) onEventEditorOK:(id)sender;
- (IBAction) onEventEditorCancel:(id)sender;
- (IBAction) onEventTriggerType:(id)sender;
- (IBAction) onEventNewAction:(id)sender;
- (IBAction) onEventDeleteAction:(id)sender;


@end

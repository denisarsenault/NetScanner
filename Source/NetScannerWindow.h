#import "NetScannerInspector.h"
#import "NetScannerPrefs.h"


@interface NetScannerWindow : NSWindowController <NSSplitViewDelegate,NSWindowDelegate,NSTableViewDelegate>
{
    IBOutlet NetScannerPrefs*        NetScanner_prefs;
    IBOutlet NetScannerInspector*    NetScanner_inspector;
    
    IBOutlet NSBox*                 NetScanner_box;
    IBOutlet NSOutlineView*         NetScanner_plugins;
    IBOutlet NSTextField*           NetScanner_status;
    IBOutlet NSMenu*                NetScanner_menu;
    IBOutlet NSSplitView*           NetScanner_split;
    
    NSView*                         default_box_view;
    PluginManager*                  plugin_manager;
    NSFont*                         font;
    NSTimer*                        status_timer;
    
    // XXX HACK move this out somewhere...
    RSStoreServer* server;
    
    BOOL setup_done;
}

- (void) pluginSelected:(id<Plugin>) plugin;
- (void) updateIcon;
- (void) setupSplitView;

// IBActions

- (IBAction) NetScannerNews:(id) sender;
- (IBAction) donate:(id) sender;
- (IBAction) NetScannerHelp:(id) sender;
- (IBAction) pluginHelp:(id) sender;
- (IBAction) emailDeveloper:(id) sender;
- (IBAction) webSite:(id) sender;
- (IBAction) onNote:(id) sender;
- (IBAction) onEmptyCache:(id) sender;

// NSNotifications

- (void) outlineViewSelectionDidChange:(NSNotification *)note;
- (void) onStatus:(NSNotification*) note;
- (void) onPluginLoad:(NSNotification*) note;
- (void) onTextSizeChange:(NSNotification*) note;
- (void) onToolbarStyleChange:(NSNotification*) note;

// NSTimers

- (void) statusFade:(NSTimer*) timer;

@end

#pragma mark -

@interface PluginCell : NSImageCell
{
	NSImageView* imageView;
}
@end


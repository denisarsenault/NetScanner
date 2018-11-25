/*

 iStumblerUpdate is the controller class for the Plugin Update feature
 it periodically spawns a short lived thread which fetches an rss feed
 for each plugins and looks for newer versions as enclosures.
 
*/

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface PluginUpdate : NSObject 
{
    IBOutlet NSWindow*    update_window;
    IBOutlet NSTextField* update_status;
    IBOutlet NSProgressIndicator* update_progress;
    IBOutlet NSButton* update_button;
    IBOutlet NSButton* update_cancel;
    IBOutlet NSTableView* update_table;
    IBOutlet WebView* update_detail;
    
    IBOutlet NSView*    prefs_view;
    IBOutlet NSButton* prefs_update;
    IBOutlet NSPopUpButton* prefs_update_frequency;
    IBOutlet NSButton* prefs_auto_download;
    IBOutlet NSButton* prefs_auto_install;
    IBOutlet NSButton* prefs_check_now;
}

#pragma mark Class Methods

+ (PluginUpdate*) sharedUpdate;

#pragma mark Instance Methods

- (NSWindow*) updateWindow;
- (NSView*) prefsView;

#pragma mark IBActions

- (IBAction) onUpdate:(id) sender;
- (IBAction) onCancel:(id) sender;

- (IBAction) onPrefsUpdate:(id) sender;
- (IBAction) onPrefsUpdateFrequency:(id) sender;
- (IBAction) onPrefsAutoDownload:(id) sender;
- (IBAction) onPrefsAutoInstall:(id) sender;
- (IBAction) onPrefsCheckNow:(id) sender;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-style license.   */

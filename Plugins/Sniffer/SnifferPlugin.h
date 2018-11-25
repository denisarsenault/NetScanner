//
//  SnifferPlugin.h
//  Sniffer
//
//  Created by alf on 2008.01.10.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Plugins/Plugins.h>


@interface SnifferPlugin : Plugin 
{
    NSToolbar*              sniffer_toolbar;
    NSString*               sniffer_status;
    NSImage*                sniffer_icon;
    
    IBOutlet NSView*        sniffer_view;
    IBOutlet NSTextView*    sniffer_text;
    // toolbar items
    IBOutlet NSButton*      sniffer_start_stop;
    IBOutlet NSPopUpButton* sniffer_interface;
    IBOutlet NSSearchField* sniffer_filter;
}

- (IBAction) onStartStopClick:(id) sender;
- (IBAction) onIternfaceSelect:(id) sender;
- (IBAction) onSearchKeyDown:(id) sender;

@end

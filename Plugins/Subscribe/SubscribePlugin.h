#import <Cocoa/Cocoa.h>
#import <Plugins/Plugins.h>
#import <WebKit/WebKit.h>


@interface SubscribePlugin : Plugin
{
    IBOutlet NSView* subscribe_view;
    IBOutlet NSView* subscribe_prefs;
    IBOutlet NSView* subscribe_inspector;
    IBOutlet WebView* subscribe_page;

    NSToolbar* subscribe_toolbar;
    
    IBOutlet NSButton* toolbar_subscribe;
    IBOutlet NSButton* toolbar_shop;
    
    NSImage* subscriber_icon;
    
    IBOutlet NSButton* prefs_subscribe;
    IBOutlet NSButton* prefs_activate;
    IBOutlet NSTextField* prefs_email;
}

// IBActions

- (IBAction) onSubscribe:(id) sender;
- (IBAction) onShop:(id) sender;

- (IBAction) onPrefsSubscribe:(id) sender;
- (IBAction) onPrefsActivate:(id) sender;

@end

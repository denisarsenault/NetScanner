
@interface iStumblerPrefs : NSWindowController <NSToolbarDelegate>
{
    IBOutlet NSPopUpButton* nibs_remember_popup;
    IBOutlet NSSlider*      istumbler_slider;
    IBOutlet NSPopUpButton* text_size_popup;
    IBOutlet NSTextField*   text_size_example;
    IBOutlet NSPopUpButton* toolbar_style_popup;
    IBOutlet NSMenu*        sample_seconds_menu;
        
    NSView* default_view;
    NSString* default_title;
}

- (void) pluginSelected:(id<Plugin>) plugin;

/* NSToolbar delgates for prefrences toolbar */

- (void) selectPrefPane:(id) sender;

- (void) updateToolbar:(NSNotification*)note;

- (IBAction) onMemoryPopUp:(id)sender;
- (IBAction) onTextSizePopUp:(id)sender;
- (IBAction) onTextSizeStep:(id) sender;
- (IBAction) onSliderMove:(id) sender;
- (IBAction) onSampleSeconds:(id) sender;
- (IBAction) onToolbarStyle:(id) sender;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under BSD-Style license.   */

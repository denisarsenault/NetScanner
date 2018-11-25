#import "NetScannerInspector.h"

@implementation NetScannerInspector

- (void) dealloc
{
    [default_title release];
    [super dealloc];
}

- (void) awakeFromNib
{
    default_title = NSLocalizedString(@"Inspector", 
	    @"Title of Window followed by Plugin Name which shows detailed information about a device");
    default_view = [[[self window] contentView] retain];
    [[self window] setContentSize:[default_view frame].size];
}

- (void) pluginSelected:(id<Plugin>) plugin
{
    NSView* content  = plugin ? [plugin pluginInspector] : default_view;
    [[self window] setContentView:nil]; // dont't stretch the contents!
    [[self window] setContentSize:[content bounds].size];
    [[self window] setContentView:content];
    if ( ![[self window] makeFirstResponder:content])
        NSLog( @"WARNING plugin's info declines first responder" );
    [[self window] setTitle:( plugin ? 
        [NSString stringWithFormat:@"%@ %@", [plugin pluginName], default_title] : 
        default_title)];
}

@end


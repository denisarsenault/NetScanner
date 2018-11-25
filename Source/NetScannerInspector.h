
@interface NetScannerInspector : NSWindowController
{
    NSString* default_title;
    NSView* default_view;
}

- (void) pluginSelected:(id<Plugin>) plugin;

@end



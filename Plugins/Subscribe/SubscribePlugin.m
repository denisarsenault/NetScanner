#import "SubscribePlugin.h"

@implementation SubscribePlugin

- (id) initWithBundle:(NSBundle*) bundle
{
    self = [super initWithBundle:bundle];
    subscriber_icon = [[NSImage alloc] initByReferencingFile:
                        [bundle pathForImageResource:@"subscribe-logo"]];
    [subscriber_icon setCacheMode:NSImageCacheBySize];
    [subscriber_icon setCachedSeparately:YES]; // better for frequent resizing 
    [subscriber_icon setScalesWhenResized:YES];
    [subscriber_icon setName:@"subscribe-logo"];
    return self;
}

- (void) awakeFromNib
{
    // load the subscribe page
    NSString* path = [[self pluginBundle] pathForResource:@"subscribe"
                                                   ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [subscribe_page setMaintainsBackForwardList:NO];
    [subscribe_page setFrameLoadDelegate:self];

    [[subscribe_page mainFrame] loadRequest:request];
    [subscribe_page setNeedsDisplay:YES];

    // setup the toolbar
    subscribe_toolbar = [[NSToolbar alloc] 
                            initWithIdentifier:@"subscribe.toolbar"];
    [subscribe_toolbar setDelegate:self];
}

#pragma mark IBActions

- (IBAction) onSubscribe:(id) sender
{
    [[NSWorkspace sharedWorkspace] 
        openURL:[NSURL URLWithString:@"http://istumbler.net/subscribe.html"]];

    /*

     */
}

- (IBAction) onShop:(id) sender
{
    [[NSWorkspace sharedWorkspace] 
        openURL:[NSURL URLWithString:@"http://istumbler.net/shop.html"]];
}

- (IBAction) onPrefsSubscribe:(id) sender
{
    
}

- (IBAction) onPrefsActivate:(id) sender
{
    
}


#pragma mark NSPlugin

- (NSView*) pluginView
{
    return subscribe_view;
}

- (NSImage*) pluginIcon
{
    return subscriber_icon;
}

- (NSView*) pluginPreferences
{
    return subscribe_prefs;
}

- (NSImage*) pluginPreferencesIcon
{
    return subscriber_icon;   
}

- (NSView*) pluginInspector
{
    return subscribe_inspector;
}

- (NSToolbar*) pluginToolbar
{
    return subscribe_toolbar;
}

#pragma mark NSToolbar delegate methods

- (NSToolbarItem*) toolbar:(NSToolbar*) toolbar 
     itemForItemIdentifier:(NSString*)ident 
 willBeInsertedIntoToolbar:(BOOL) flag
{
    NSToolbarItem* item = [[NSToolbarItem alloc] initWithItemIdentifier:ident];
    
if ( [@"subscribe.subscribe" isEqualToString:ident])
    {
        [item setLabel:NSLocalizedString(@"Subscribe",@"Subscribe.subscribe label")];
        [item setView:toolbar_subscribe];
        [item setMinSize:[toolbar_subscribe frame].size];
    }
    else if ( [@"subscribe.shop" isEqualToString:ident])
    {
        [item setLabel:NSLocalizedString(@"Shop",@"Subscribe.shop label")];
        [item setView:toolbar_shop];
        [item setMinSize:[toolbar_shop frame].size];
    }

    return item;
}

- (NSArray*) toolbarAllowedItemIdentifiers:(NSToolbar*) toolbar
{
    return [NSArray arrayWithObjects:
        NSToolbarFlexibleSpaceItemIdentifier,
        @"subscribe.subscribe",
//        @"subscribe.shop",
        nil];
}

- (NSArray*) toolbarDefaultItemIdentifiers:(NSToolbar*) toolbar
{
    return [NSArray arrayWithObjects:
        NSToolbarFlexibleSpaceItemIdentifier,
        @"subscribe.subscribe",
//        @"subscribe.shop",
        nil];
}

#pragma mark WebView delegate methods

- (void)                    webView:(WebView*) sender
    didStartProvisionalLoadForFrame:(WebFrame*) frame
{
    NSURL* url = [[[frame provisionalDataSource] request] URL];
    
    /* if the url is not a file:// url then we should open the url in
     a real browser window by asking the workspace to open it */
    if ( (frame == [sender mainFrame]
        && ![@"file" isEqualToString:[url scheme]]))
    {
        [frame stopLoading];
        [[NSWorkspace sharedWorkspace] openURL:url];
    }
}

@end

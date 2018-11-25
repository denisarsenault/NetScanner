#import "NetScannerWindow.h"
#import "ScreenSaver/ScreenSaverView.h"



@implementation NetScannerWindow

- (id) init
{
    self = [super init];
    font = [[NSFont systemFontOfSize:[NSFont smallSystemFontSize]] retain];
    setup_done = NO;
    return self;
}

- (void) awakeFromNib
{
    /* save the default box view */
    default_box_view = [[NetScanner_box contentView] retain];
    
    [[NSNotificationCenter defaultCenter] 
        addObserver:self 
           selector:@selector(applicationDidFinishLaunching:)
               name:NSApplicationDidFinishLaunchingNotification
             object:nil];

    [[NSNotificationCenter defaultCenter] 
        addObserver:self 
           selector:@selector(applicationWillTerminate:)
               name:NSApplicationWillTerminateNotification
             object:nil];
    
    [[NSNotificationCenter defaultCenter] 
        addObserver:self 
           selector:@selector(onStatus:)
               name:@"NetScanner.status"
             object:nil];

    [[NSNotificationCenter defaultCenter] 
        addObserver:self 
           selector:@selector(onPluginLoad:)
               name:@"plugins.plugin.loaded"
             object:nil];
    
    [[NSNotificationCenter defaultCenter] 
        addObserver:self 
           selector:@selector(onTextSizeChange:)
               name:@"NetScanner.fontsize"
             object:nil];
    
    [[NSNotificationCenter defaultCenter] 
        addObserver:self 
           selector:@selector(onToolbarStyleChange:)
               name:@"NetScanner.toolbar.style"
             object:nil];
    
    [NetScanner_split setDelegate:self];
    [[self window] setDelegate:self];
            
    [self updateIcon];
    [self setupSplitView];

    /* setup the metal table header for plugins list 
    NSArray* plugin_columns = [NetScanner_plugins tableColumns];
    NSEnumerator *columns = [plugin_columns objectEnumerator];
    NSTableColumn *col = nil;
    iTableColumnHeaderCell *iHeaderCell;
    float width = 0;
    
    while (col = [columns nextObject]) 
    {
        iHeaderCell = [[iTableColumnHeaderCell alloc] initTextCell:[[col headerCell] stringValue]];
        [col setHeaderCell:iHeaderCell];
        [iHeaderCell release];
        width += [col width];
    }

    // blows out a drawing glitch on the right-hand side of the table
    NSTableColumn* last_column = [plugin_columns lastObject];
    [last_column setWidth:[NetScanner_plugins frame].size.width-(width-[last_column width])]; */
}

- (void) applicationDidFinishLaunching:(NSNotification*) aNotification
{
    if ( ! plugin_manager)
    {
        PluginEnvironment* plugin_env = 
            [PluginEnvironment defaultEnvironment];
        
        [plugin_env setApplicationWindow:[self window]
                    andPreferencesWindow:[NetScanner_prefs window]
                      andInspectorWindow:[NetScanner_inspector window]];

        /* register the NetScanner application events */
        [plugin_env registerEvents:[NSArray arrayWithObjects:
                                                @"NetScanner.note",
                                                @"NetScanner.status",
                                                @"NetScanner.slider.move",
                                                @"NetScanner.slider.pause",
                                                nil]
                     forIdentifier:@"net.NetScanner"];

        /* register the plugin framework events */
        [plugin_env registerEvents:[NSArray arrayWithObjects:
                                                @"plugins.plugin.loaded", 
                                                @"plugins.plugin.unloaded", 
                                                @"plugins.plugin.selected", 
                                                nil]
                     forIdentifier:@"net.NetScanner.plugins"];
        
        /* start up the RSStoreServer */
        /* XXX HACK Hmmmmm, this really shouldn't be here, 
            maybe find a way to encapsulate it in the framework better... */
        server = [[RSStoreServer alloc] initWithStore:[RSStore sharedStore]];
        [server startServer];
        
        /* register the RSRadio Store events */
        [plugin_env registerEvents:[NSArray arrayWithObjects:
                                                @"radiostore.radio.stored",
                                                @"radiostore.radio.removed",
                                                @"radiostore.radio.forgotten",
                                                nil]
                     forIdentifier:@"net.NetScanner.radiostore"];

        /* register the RSRadio formatter */
        NSFormatter* formatter = [[RSRadioFormatter new] autorelease];
        [plugin_env registerFormatter:formatter forClass:[RSRadio class]];
        
        
        /* this call creates the plugin manager which loads the plugins
            from the app bundle and the various system plugin paths */
        plugin_manager = [PluginManager defaultManager];

        /* setup the plugin list */
        [NetScanner_plugins setDataSource:plugin_manager];
        [NetScanner_plugins registerForDraggedTypes:
         [NSArray arrayWithObject:NSFilenamesPboardType]];
        
        /* set the default font size */
        int font_size = [[NSUserDefaults standardUserDefaults]
                                      integerForKey:@"NetScanner.fontsize"];

        [[NSNotificationCenter defaultCenter]
                postNotificationName:@"NetScanner.fontsize"
                              object:[NSFont systemFontOfSize:font_size]];

        [[NSNotificationCenter defaultCenter]
                postNotificationName:@"NetScanner.status"
                              object: NSLocalizedString(@"Welcome to AutoCoupon",
										@"Translate to a fitting welcome greeting")];
        
        /* load the selected plugin */
        [self pluginSelected:[plugin_manager selectedPlugin]];
    }
    
    setup_done = YES;
    
    [NetScanner_plugins selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [NetScanner_plugins setFrame:[NetScanner_plugins frame]];
}

- (void) applicationWillTerminate:(NSNotification *)aNotification
{
    [plugin_manager unloadPlugins];
    [server stopServer];
}

/*
 I'm saving this as an example of the worst code ever. 
 It caused a nasty bug, and offers no value except as a warning to others.
- (void) release
{
    [plugin_manager release];
}
*/

- (void) dealloc
{
    [server release];
    [plugin_manager release];
    [super dealloc];
}

#pragma mark methods

- (void) pluginSelected:(id<Plugin>) plugin
{
    if (plugin)
    {
        [NetScanner_box setContentView:[plugin pluginView]];
        [[self window] setTitle:
            [@"NetScanner - " stringByAppendingString:[plugin pluginName]]];
        
        if ( ![[self window] makeFirstResponder:[plugin pluginView]])
            NSLog( @"WARNING plugin's view declines first responder" );

        /*  
            this seems a bit convuluted but it makes sure that the toolbar
            behaves in a reasonable and perdicatble manner. 

            if the window has no toolbar when the plugin is selected 
            the toolbar is shown
            
            if the window has a toolbar then the new toolbar is put
            in the same visible state as the previous one before being
            added to the window and again after being added to the window
            to ensure that it is shown
        */
        if ( [plugin pluginToolbar])
        {
            BOOL was_visible = ([[self window] toolbar] == nil 
                                ? YES : [[[self window] toolbar] isVisible]);
            [[plugin pluginToolbar] setVisible:was_visible];
            [[plugin pluginToolbar] setDisplayMode:
                [[NSUserDefaults standardUserDefaults] 
                    integerForKey:@"NetScanner.toolbar.style"]];
            [[plugin pluginToolbar] setAllowsUserCustomization:YES];
            [[plugin pluginToolbar] setAutosavesConfiguration:NO];
            [[self window] setToolbar:[plugin pluginToolbar]];
            [[[self window] toolbar] setVisible:was_visible]; // fixes a startup bug
        }
        else
        {
            [[[self window] toolbar] setVisible:NO];
            [[self window] setToolbar:nil];
        }

        /* add a menu item for the plugin */
        if ([NetScanner_menu itemWithTag:1001])
            [NetScanner_menu removeItem:[NetScanner_menu itemWithTag:1001]];

        NSMenuItem* plugin_item = [[NSMenuItem new] autorelease];
        [[plugin pluginMenu] setTitle:[plugin pluginName]];
        [plugin_item setSubmenu:[plugin pluginMenu]];
        [plugin_item setTag:1001];
        [NetScanner_menu insertItem:plugin_item atIndex:3];
    }
    else
    {
        [[self window] setTitle:@"NetScanner"];
        /* this works around a bug that would really fuck up the
        window if you selected a plugin, showed it's toolbar and then 
        took the toolbar away by setting theplugin to nil, next time you 
        select the plugin the window rolls up into it's title bar as if
        it's been hurt!  */
        [[[self window] toolbar] setVisible:NO];
        [[self window] setToolbar:nil];

        [NetScanner_box setContentView:default_box_view];
        
        /* remove the plugin menu item */
        if ([NetScanner_menu itemWithTag:1001])
            [NetScanner_menu removeItem:[NetScanner_menu itemWithTag:1001]];
    }
    
    [[self window] setInitialFirstResponder:[plugin pluginView]];
    [NetScanner_prefs pluginSelected:plugin]; 
    [NetScanner_inspector pluginSelected:plugin];
    [self updateIcon];
}


- (void) updateIcon
{
    NSImage *appImage = [[[NSImage imageNamed:@"NSApplicationIcon"]
        copy] autorelease]; 
    NSImage *badge = [[plugin_manager selectedPlugin] pluginIcon];

    if (badge)
    {
        [badge setScalesWhenResized:YES];
        [badge setSize:NSMakeSize(64, 64)];
        [appImage lockFocus];
        [badge compositeToPoint:NSMakePoint(64, 8)
                      operation:NSCompositeSourceOver];
        [appImage unlockFocus];
    }
    
    [NSApp setApplicationIconImage:appImage];
}

#pragma mark IBActions

- (IBAction) NetScannerNews:(id) sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://Denissarsenault.com"]];
}

- (IBAction) donate:(id) sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://Denissarsenault.com"]];
}

- (IBAction) NetScannerHelp:(id) sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://Denissarsenault.com"]];
}

- (IBAction) pluginHelp:(id) sender
{
    NSString* help = [[[PluginManager defaultManager] 
                            selectedPlugin] pluginHelpURL];
    if (help)
        [[NSWorkspace sharedWorkspace] openURL:
            [NSURL URLWithString:help]];
    else
        [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://Denissarsenault.com"]];
}

- (IBAction) emailDeveloper:(id) sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"mailto:Deniss@2me.com"]];
}

- (IBAction) webSite:(id) sender
{
    [[NSWorkspace sharedWorkspace] openURL:
        [NSURL URLWithString:@"http://Denissarsenault.com"]];
}

- (IBAction) onNote:(id) sender
{
    NSString* note = [sender stringValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NetScanner.note"
                                                        object:note];
    [sender becomeFirstResponder];
}

- (IBAction) onEmptyCache:(id) sender
{
    [[RSStore sharedStore] forgetSamplesBefore:[NSDate distantFuture]];
}

#pragma mark NSNotifications

- (void) onStatus:(NSNotification*) note
{
    [NetScanner_status setStringValue:[[note object] description]];
    [NetScanner_status setTextColor:[NSColor blackColor]];
    
    if (status_timer)
        [status_timer invalidate];
    
    status_timer =  [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(statusFade:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:status_timer
                                 forMode:NSDefaultRunLoopMode];    
}

- (void) onPluginLoad:(NSNotification*) note
{
    [[NSNotificationCenter defaultCenter] 
        postNotificationName:@"NetScanner.status"
                      object:[[note object] pluginInfo]];
}

- (void) onTextSizeChange:(NSNotification*) note
{
    [font release];
    font = [[note object] retain];
    [NetScanner_plugins reloadData];
    int row = [NetScanner_plugins selectedRow];
    [NetScanner_plugins deselectAll:self];
    [NetScanner_plugins selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [NetScanner_plugins setRowHeight:([font pointSize]*1.5)];
    [NetScanner_prefs pluginSelected:nil];
}

- (void) onToolbarStyleChange:(NSNotification*) note
{
    [[[self window] toolbar] setDisplayMode:[[note object] intValue]];   
}

#pragma mark NSTimers

- (void) statusFade:(NSTimer*) timer
{
    float alpha = [[NetScanner_status textColor] alphaComponent];
    if ( alpha > 0.1)
    {
        NSColor* more_trans = [NSColor colorWithCalibratedWhite:0.0
                                                          alpha:(alpha - 0.1)];
        [NetScanner_status setTextColor:more_trans];
//        NSLog( @"Fading Status: %@ to %@", 
//               [NetScanner_status stringValue], more_trans);
    }
    else
    {
//        NSLog( @"Totally Faded: %@", [NetScanner_status stringValue]);
        [NetScanner_status setStringValue:@""];
        [timer invalidate];
        status_timer = nil;
    }
}

#pragma mark NSWindowDelegate

- (NSRect) windowWillUseStandardFrame:(NSWindow*) sender 
                         defaultFrame:(NSRect) frame
{
    NSRect wind = [[self window] frame];
    NSSize min = [[self window] minSize];
    frame = NSMakeRect( wind.origin.x, wind.origin.y, min.width, min.height);
    return frame;
}

#pragma mark NSSplitViewDelegate

- (void)        splitView:(NSSplitView *)sender 
resizeSubviewsWithOldSize:(NSSize) oldSize
{
    /* fetch all the intermediate values ... */
    NSRect split_frame = [sender frame];
    NSRect plugs_frame = [[[NetScanner_plugins superview] superview] frame];
    NSRect   box_frame = [NetScanner_box frame];
    float thickness = [sender dividerThickness];

    // the box should be the width of entire splitter, minus the plugins and the divider
    float new_box_width = split_frame.size.width
        - plugs_frame.size.width
        - thickness;

    /* leave plugs the same width, adjusting it's height */
    NSRect new_plugs = NSMakeRect(
        plugs_frame.origin.x, plugs_frame.origin.y,
        plugs_frame.size.width, split_frame.size.height);

    /* set box to the new width and height */
    NSRect new_box = NSMakeRect( 
        box_frame.origin.x, box_frame.origin.y,
        new_box_width, split_frame.size.height);

    // apply the new rects to their target views
    [NetScanner_box setFrame:new_box];
    [[[NetScanner_plugins superview] superview] setFrame:new_plugs];
}

- (BOOL) splitView:(NSSplitView*) sender 
canCollapseSubview:(NSView*) subview
{
    // allow the split to collapse the plugins view
    return [NetScanner_plugins isDescendantOf:subview];
}

- (float) splitView:(NSSplitView*) sender 
constrainSplitPosition:(float) proposedPosition 
        ofSubviewAt:(int) offset
{
    // constrain the list to no more than 1/3 of the frame width
    return fminf( proposedPosition, ([sender frame].size.width/3));
}

- (void) splitViewDidResizeSubviews:(NSNotification*) note
{
    NSRect plugs_frame = [[[NetScanner_plugins superview] superview] frame];

    [[NSUserDefaults standardUserDefaults]
        setFloat:plugs_frame.size.width+1
          forKey:@"NetScanner.shell.spliter-width"];
}

- (void) setupSplitView
{
    NSString* plugs_width = [[NSUserDefaults standardUserDefaults] stringForKey:@"NetScanner.shell.spliter-width"];
    /* fetch all the intermediate values ... */
    NSRect split_frame = [NetScanner_split frame];
    NSRect plugs_frame = [[[NetScanner_plugins superview] superview] frame];
    NSRect   box_frame = [NetScanner_box frame];
    float thickness = [NetScanner_split dividerThickness];
    float width = plugs_frame.size.width;

    // check to see if the width was saved, substitute the default value
    if (plugs_width)
        width = [plugs_width floatValue]-1;

    // the box should be the width of entire splitter, minus the plugins and the divider
    float new_box_width = (float) split_frame.size.width - width - thickness;
    float new_box_edge = width + thickness;
    
    /* leave plugs the same width, adjusting it's height */
    NSRect new_plugs = NSMakeRect( plugs_frame.origin.x, plugs_frame.origin.y,
                                   width, split_frame.size.height);
    
    /* set box to the new width and height */
    NSRect new_box = NSMakeRect( new_box_edge, box_frame.origin.y,
                                 new_box_width, split_frame.size.height);
    
    // apply the new rects to their target views
    [NetScanner_box setFrame:new_box];
    [[[NetScanner_plugins superview] superview] setFrame:new_plugs];
}

#pragma mark NSOutlineView delegate

- (void) outlineViewSelectionDidChange:(NSNotification*) note
{
    id<Plugin> selected = [plugin_manager selectPlugin:[[note object] selectedRow]];
    [self pluginSelected:selected];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NetScanner.status"
                                                        object:[selected pluginInfo]];
}

- (void) outlineView:(NSOutlineView*) outline
     willDisplayCell:(id) cell
      forTableColumn:(NSTableColumn*) column
                item:(id)item
{
    if( [cell isKindOfClass:[NSImageCell class]] )
    {
        [[cell image] setSize:NSMakeSize(24,24)];
    }
    [cell setFont:font];
}

#pragma mark NSTextView Delegate Methods

- (BOOL) textView:(NSTextView*) text clickedOnLink:(id) link atIndex:(unsigned) index
{
    [[NSWorkspace sharedWorkspace] openURL:link];
    return YES;
}

- (NSRange) textView:(NSTextView*) text willChangeSelectionFromCharacterRange:(NSRange) previous toCharacterRange:(NSRange) next
{
    return NSMakeRange(0,0);
}

#pragma mark NSMenu Validation

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    return YES;
}

@end

#pragma mark -

@implementation PluginCell

-(void)awakeFromNib
{
	imageView = [[NSImageView alloc] init];
    [imageView setImageFrameStyle:NSImageFrameNone];
	[[self controlView] addSubview:imageView];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView*)controlView
{	
	NSRect imageFrame = cellFrame;
    
    CGFloat scale = 1.25;
    CGFloat size = ([[self font] pointSize]*scale);
    CGFloat offset = ([[self font] pointSize]/1.25);
	imageFrame.size.width = size;
    imageFrame.size.height = size;
	imageFrame.origin.x = cellFrame.origin.x-offset;
    imageFrame.origin.y = cellFrame.origin.y;
	
	[imageView setFrame:imageFrame];
	[super drawWithFrame:imageFrame inView:controlView];
}

@end



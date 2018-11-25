#import "NetScannerPrefs.h"

static int const DefaultScanRate = 10;

@implementation NetScannerPrefs

- (void) awakeFromNib
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    [self updateToolbar:nil];
    
    default_title = [[[self window] title] retain];
    default_view = [[[self window] contentView] retain];
    [[self window] setContentSize:[default_view frame].size];
    
    [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInt:600], @"radiostore.rememberseconds", 
        [NSNumber numberWithInt:11], @"NetScanner.fontsize",
        [NSNumber numberWithInt:2], @"NetScanner.toolbar.style", nil]];
    
    /* NSPopUpButton* nibs_remember_seconds; */
    int remember_seconds = [defaults integerForKey:@"radiostore.rememberseconds"];
    {
        int index = 0;
        int count = [nibs_remember_popup numberOfItems];
        while ( index < count)
        {
            NSMenuItem* item = [nibs_remember_popup itemAtIndex:index];
            if ( [item tag] == remember_seconds)
            {
                [nibs_remember_popup selectItemAtIndex:index];
                break;
            }
            index++;
        }
    }

    
    [center postNotificationName:@"radiostore.rememberseconds"
                          object:[NSNumber numberWithInt:remember_seconds]];
    
    /* NSPopUpButton text_size_popup */
    int text_size = [defaults integerForKey:@"NetScanner.fontsize"];
    {
        int index = 0;
        int count = [text_size_popup numberOfItems];
        while ( index < count)
        {
            NSMenuItem* item = [text_size_popup itemAtIndex:index];
            if ( [item tag] == text_size)
            {
                [text_size_popup selectItemAtIndex:index];
                break;
            }
            index++;
        }
    }
    
    /* set the toolbar style */
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"NetScanner.toolbar.style"
                      object:[defaults objectForKey:@"NetScanner.toolbar.style"]];
    
    /* NSPopUpButton* toolbar_style_popup; */
    {
        int style = [defaults integerForKey:@"NetScanner.toolbar.style"];
        int index = 0;
        while ( index < [toolbar_style_popup numberOfItems])
        {
            NSMenuItem* item = [toolbar_style_popup itemAtIndex:index];
            if ( [item tag] == style)
            {
                [toolbar_style_popup selectItemAtIndex:index];
                break;
            }
            index++;
        }
    }
    
    int scan_rate = [defaults integerForKey:@"NetScanner.scan.rate"];
    if (scan_rate > DefaultScanRate)
    {
        [NetScanner_slider setIntValue:scan_rate];
        [self onSliderMove:NetScanner_slider];
    }
    
    /* 
    XXX the ISFontSizeChange message is send by the NetScannerWindow after 
    all the plugins have been loaded. it should be sent after a plugin is
     loaded via drag and drop as well...
    */
    
    [center addObserver:self
               selector:@selector(updateToolbar:)
                   name:@"plugins.plugin.loaded"
                 object:nil];

    [center addObserver:self
               selector:@selector(updateToolbar:)
                   name:@"plugins.plugin.unloaded"
                    object:nil];
    
    [self pluginSelected:nil];
    
    [self onSliderMove:NetScanner_slider];
}

- (void) pluginSelected:(id<Plugin>) plugin
{
    NSView* content = plugin ? [plugin pluginPreferences] : default_view;
    [[self window] setContentView:nil]; // dont' streach the contents!
    [[self window] setContentSize:[content bounds].size];
    [[self window] setContentView:content];
    if ( ![[self window] makeFirstResponder:[plugin pluginPreferences]])
        NSLog( @"WARNING plugin's prefs declines first responder");

    [[self window] setTitle:( plugin ? 
        [NSString stringWithFormat:@"%@ %@", [plugin pluginName], default_title] : 
        default_title)];

    if (plugin)
        [[[self window] toolbar] setSelectedItemIdentifier:[plugin pluginIdentifier]];
    else
        [[[self window] toolbar] setSelectedItemIdentifier:@"net.NetScanner"];
    
}

/* Toolbar delegate methods */

- (void) selectPrefPane:(id) sender
{
    if ([[sender itemIdentifier] isEqualToString:@"net.NetScanner"])
    {
        [self pluginSelected:nil];
    }
    else
    {
        NSEnumerator* plugin_enum = [[[PluginManager defaultManager] 
                                            loadedPlugins] objectEnumerator];
        id<Plugin> the_plugin;
        
        while ( the_plugin = [plugin_enum nextObject])
        {
            if ([[the_plugin pluginIdentifier] isEqualToString:[sender itemIdentifier]])
            {
                [self pluginSelected:the_plugin];
                break;
            }
        }
    }
}

- (NSToolbarItem*) toolbar:(NSToolbar*) toolbar
     itemForItemIdentifier:(NSString*) itemId
 willBeInsertedIntoToolbar:(BOOL) flag
{
    NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:
        itemId] autorelease];

    [item setAction:@selector(selectPrefPane:)];
    [item setTarget:self];

    if ( [itemId isEqualToString:@"net.NetScanner"])
    {
        [item setLabel:@"AutoCoupon"];
        [item setPaletteLabel:[item label]];
        [item setImage:[NSImage imageNamed:@"NSApplicationIcon"]];
        return item;
    }
    else
    {
        NSEnumerator* plugin_enum = [[[PluginManager defaultManager] loadedPlugins] objectEnumerator];
        id<Plugin> the_plugin;

        // TODO check for 'net.NetScanner.application' identifier first
        
        while ( the_plugin = [plugin_enum nextObject]) // this is going to suck for lots of items
        {
            if ([itemId isEqualToString:[the_plugin pluginIdentifier]])
            {
                [item setLabel:[the_plugin pluginName]];
                [item setPaletteLabel:[the_plugin pluginName]];
                [item setImage:[the_plugin pluginPreferencesIcon]];
                return item;
            }
        }
    }
    
    return item;
}

- (NSArray*) toolbarAllowedItemIdentifiers:(NSToolbar*) toolbar
{
    return [[NSArray arrayWithObjects:@"net.NetScanner", NSToolbarSeparatorItemIdentifier, nil] 
        arrayByAddingObjectsFromArray:
            [[PluginManager defaultManager] loadedIdentifiers]];
}

- (NSArray*) toolbarDefaultItemIdentifiers:(NSToolbar*) toolbar
{
    return [[NSArray arrayWithObjects:@"net.NetScanner", NSToolbarSeparatorItemIdentifier, nil] 
        arrayByAddingObjectsFromArray:
            [[PluginManager defaultManager] loadedIdentifiers]];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar
{
    return [[NSArray arrayWithObject:@"net.NetScanner"] 
        arrayByAddingObjectsFromArray:
            [[PluginManager defaultManager] loadedIdentifiers]];
}

- (void) updateToolbar:(NSNotification*) note
{
    NSToolbar* prefs_toolbar = [[[NSToolbar alloc] initWithIdentifier:
        @"NetScanner.prefs.toolbar"] autorelease];
    [prefs_toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
    [prefs_toolbar setSizeMode:NSToolbarSizeModeRegular];
    [prefs_toolbar setVisible:YES];
    [prefs_toolbar setAllowsUserCustomization:NO];
    [prefs_toolbar setDelegate:self];
    [[self window] setToolbar:prefs_toolbar];
}

- (IBAction)onMemoryPopUp:(id)sender
{
    int seconds = [sender selectedItem] ? [[sender selectedItem] tag] : 0;
    [[NSUserDefaults standardUserDefaults]
        setInteger:seconds
            forKey:@"radiostore.rememberseconds"];
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"radiostore.rememberseconds"
                      object:[NSNumber numberWithInt:seconds]];

    NSString* message = [NSString stringWithFormat:
        NSLocalizedString(@"Remembering for %i seconds",
						  @"Displays a message of how many(%i) seconds information is being retained"),
						 seconds];
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"NetScanner.status"
                      object:message];
}

- (IBAction) onTextSizePopUp:(id) sender
{
    int font_size = [[sender selectedItem] tag];
    NSFont* font = [NSFont systemFontOfSize:font_size];

    [text_size_example setFont:font];

    [[NSUserDefaults standardUserDefaults]
        setInteger:font_size
            forKey:@"NetScanner.fontsize"];
    
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"NetScanner.fontsize"
                      object:font];
}

- (IBAction) onTextSizeStep:(id) sender
{
    int change = [sender tag];
    int size = [[text_size_example font] pointSize]+change;
    NSFont* font = [NSFont systemFontOfSize:size];

    if ( (size < 9 || size > 18)) return; // don't let them get out of hand...
    // TODO disable the bigger or smaller item...
    
    int index = 0;
    int count = [text_size_popup numberOfItems];
    [text_size_popup selectItemAtIndex:-1];
    while ( index < count)
    {
        NSMenuItem* item = [text_size_popup itemAtIndex:index];
        if ( [item tag] == size)
        {
            [text_size_popup selectItemAtIndex:index];
            break;
        }
        index++;
    }
    
    [text_size_example setFont:font];
    [[NSUserDefaults standardUserDefaults] setInteger:[font pointSize] forKey:@"NetScanner.fontsize"];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NetScanner.fontsize" object:font];
}

/* send a slider-update message to the notification system. */
- (IBAction)onSliderMove:(id)sender
{
    int seconds = [sender floatValue];
    if ( seconds == (int) [sender maxValue]) // slider moved to 'paused'
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetScanner.slider.move" object:[NSNumber numberWithInt:seconds]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetScanner.slider.pause" object:[NSNumber numberWithInt:seconds]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetScanner.status" object: NSLocalizedString(@"NetScanner Paused", @"Indication that data sampling has been paused")];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]   
            postNotificationName:@"NetScanner.slider.move"
                          object:sender];
        NSString* message = [NSString stringWithFormat: NSLocalizedString(@"Sampling every %i seconds",
            @"The frequency in seconds(%i) at which samples of data are taken"), [sender intValue]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetScanner.status" object:message];

        [[NSUserDefaults standardUserDefaults] setInteger:(seconds > DefaultScanRate)?seconds:DefaultScanRate
                                                   forKey:@"NetScanner.scan.rate"];
    }
}

- (IBAction) onSampleSeconds:(id) sender
{
    int seconds = [sender tag];
    
    if (seconds == 0)
    {
        [[NSNotificationCenter defaultCenter] 
            postNotificationName:@"NetScanner.slider.move"
                          object:[NSNumber numberWithInt:seconds]];
        [[NSNotificationCenter defaultCenter] 
            postNotificationName:@"NetScanner.slider.pause"
                          object:[NSNumber numberWithInt:seconds]];
        [[NSNotificationCenter defaultCenter]
            postNotificationName:@"NetScanner.status" object:
                NSLocalizedString(@"AutoCoupon Paused", 
                @"Indication that AutoCoupon data sampling has been paused")];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]   
            postNotificationName:@"NetScanner.slider.move"
                          object:[NSNumber numberWithInt:seconds]];
        NSString* message = [NSString stringWithFormat:
            NSLocalizedString(@"Sampling every %i seconds",
            @"The frequency in seconds(%i) at which samples of data are taken"),
            seconds];
        [[NSNotificationCenter defaultCenter]
            postNotificationName:@"NetScanner.status"
                          object:message];
    }
    
    if (seconds == 0)
        [NetScanner_slider setIntValue:[NetScanner_slider maxValue]];
    else
        [NetScanner_slider setIntValue:seconds];
}

- (IBAction) onToolbarStyle:(id) sender
{
    int style = [[sender selectedItem] tag];
    
    [[NSUserDefaults standardUserDefaults]
        setInteger:style
            forKey:@"NetScanner.toolbar.style"];
    
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"NetScanner.toolbar.style"
                      object:[NSNumber numberWithInt:style]];
}

#pragma mark NSMenuDelegate

- (void) menuNeedsUpdate:(NSMenu*) menu
{
    if ( menu == sample_seconds_menu)
    {
        int sample_frequency = [NetScanner_slider intValue];
        if ( sample_frequency == (int) [NetScanner_slider maxValue])
            sample_frequency = 0;
        
        NSEnumerator* items_enum = [[menu itemArray] objectEnumerator];
        id enum_item;
        while (enum_item = [items_enum nextObject])
        {
            if ([enum_item tag] == sample_frequency)
                [enum_item setState:NSOnState];
            else
                [enum_item setState:NSOffState];
        }
    }
}

@end


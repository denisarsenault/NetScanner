#import <Cocoa/Cocoa.h>

/*
 
 The Plugins protocol supports additions to the source list in iStumbler.
 
 Plugins should use the default NSNotificationCenter for inter-plugin
 communications. iStumbler provides a global slider notification and will
 listen for notifications to update the status or user interface.
 
 The lifespan of a plugin. 
 
 When iStumbler is launched the PluginManager scans for plugins bundles in
 all the usual places. As it finds the bundles it loads their primary classes
 and caches them in an array.
 
 Each class has it's initPlugin method called with the bundle it was loaded
 from for convenience. The plugin may start a thread or perform any other
 initialization at this stage.
 
 Once the init has completed an instance of the plugin is created. That
 instance is used by iStumbler for the duration of it's run. The plugin
 instance provides the  application with the following information:
 
 plugin icon         16x16 icon for the list
 plugin name         the name to display in the list
 plugin info         plugin name - version - author - (c) notice
 
 plugin view         view for the main window
 plugin menu         plugin's menu to display when selected
 
 plugin toolbar      toolbar to display
 plugin status       status to display in the main window
 
 preferences view     for the preferences
 preferences icon     32x32 icon for the preferences
 
 inspector view      for the inspector icon      24x24 icon for the inspector
 
 These methods will be called every time the application needs them, in
 whatever order we want. Once the application is ready to get rid of the
 plugin, typically it is about to quit it will release the plugin instances
 and then call the stopPlugin method on the class so that it can stop 
 whatever threads it is running, close files and release memory.
 
 */

@protocol Plugin <NSObject>

/*  Called by the IStumberController when the plugin is loaded, the 
plugins bundle object is passed for convenance. The plugin should
return true if it's ready to have an instance created and false
if it cannot.   */
+ (BOOL)initPlugin:(NSBundle*) bundle;

    /*  Create a new instance of this plugin with the object as a parameter.
    May be called multiple times for multiple instances of a plugin object. */
+ (id<Plugin>)createPlugin:(NSBundle*) bundle;

    /*  Called by the PluginManager when the plugin is unloaded. Close
    your files, stop your threads and let those objects go free. */
+ (void)stopPlugin;

    /*  Returns a string which we can display in the window title and
    in the plugin list and menu.  */
- (NSString*) pluginName;

    /*  Returns a string which can be used as the system wide unique
    identifier for the plugin. use reverse domain style names for
    your plugins: net.istumbler.plugin.airport for e.g. */
- (NSString*) pluginIdentifier;

    /*  Returns a string which has the plugin's info, such as copy
    right and legal notices for or display in the info window.  */
- (NSString*) pluginInfo;

    /*  Returns a string with the plugin's help url   */
- (NSString*) pluginHelpURL;

    /* Returns a string with the plugin's home url */
- (NSString*) pluginHomeURL;

    /* Returns a string with the plugin's feed url */
- (NSString*) pluginFeedURL;

    /* Returns the integer release number for this plugin */
- (int) pluginRelease;

    /*  Returns the entire scroll view for the plugin, this view is
    in the main window of iStumbler.    */
- (NSView*) pluginView;

    /*  Returns an icon for the plugin. The image may be any size but
    will be scaled to 16X16 for the outline view, so be ready for that. */
- (NSImage*) pluginIcon;

    /*  Returns the NSToolbar to display while the plugin is selected.  */
- (NSToolbar*) pluginToolbar;

    /*  Returns  an NSMenu for the plugin to be grafted into the 
    applications menu when the plugin is selected and a sub-menu
    of the dock menu while it's loaded  */
- (NSMenu*) pluginMenu;

    /*  Returns the NSView to show in the prefrences window.    */
- (NSView*) pluginPreferences;

    /*  Returns an icon for the preferences toolbar */
- (NSImage*) pluginPreferencesIcon;

    /*  Returns the NSView to show in the inspector panel   */
- (NSView*) pluginInspector;

    /*  Returns an icon for the inspector toolbar   */
- (NSImage*) pluginInspectorIcon;

@end


/*

 The Plugin class defines a basic plugin which
 maintains a link to the bundle it was loaded from.
 
*/
@interface Plugin : NSObject <Plugin>
{
    NSBundle* plugin_bundle;
}

- (id) initWithBundle:(NSBundle*) bundle;
- (NSBundle*) pluginBundle;

@end
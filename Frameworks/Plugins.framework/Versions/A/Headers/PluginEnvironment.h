#import <Plugins/Plugin.h>

/*
 The PluginEnvironment is a singleton which provides a coordinating
 facility for all loaded plugins. It alows access to some iStumbler
 internals and provides a registry of public events and object formatters
 for the plugins and the shell to use for displaying messages to users.
 */
@interface PluginEnvironment : NSObject 
{
    NSWindow* application_window;
    NSWindow* preferences_window;
    NSWindow* inspector_window;
    NSMutableDictionary* event_registry;
    NSMutableDictionary* format_registry;
    NSMutableSet* growl_notifications;
    NSMutableSet* growl_defaults;
}

    /* fetch and relase the default environment */
+ (PluginEnvironment*) defaultEnvironment;
+ (void) releaseDefaultEnvironment;

    /* used to in itilize the plugin environment when the 
    application awakes from the nib */
- (void) setApplicationWindow:(NSWindow*) app
         andPreferencesWindow:(NSWindow*) prefs
           andInspectorWindow:(NSWindow*) info;

    /* returns pointers to the various application windows so that plugins
    can attache sheets, resize or otherwise manipulate them */
- (NSWindow*) applicationWindow;
- (NSWindow*) preferencesWindow;
- (NSWindow*) inspectorWindow;

    /* register and unregister events */
- (void) registerEvents:(NSArray*) events forIdentifier:(NSString*) identifier;
- (void) unregisterEvents:(NSString*) identifier;

/* growl notification names */
- (NSArray*) growlNotifications;
- (NSArray*) growlDefaults;
- (void) registerGrowlNotification:(NSString*) name
                         asDefault:(BOOL) isDefault;
- (void) unregisterGrowlNotification:(NSString*) name;

    /* return the list of identifiers or events for a given identifier */
- (NSArray*) registeredIdentifiers;
- (NSArray*) registeredEvents:(NSString*) identifier;

    /* returns the list of plugin identifiers  */
- (NSArray*) pluginIdentifiers;

    /* returns a plugin with the identifier specified */
- (id<Plugin>) pluginWithIdentifier:(NSString*) ident;

    /* register and unregister formatters for a specific class */
- (void) registerFormatter:(NSFormatter*) formatter
                  forClass:(Class) clazz;
- (void) unregisterFormatter:(Class) clazz;
- (NSFormatter*) formatterForClass:(Class) clazz;

@end

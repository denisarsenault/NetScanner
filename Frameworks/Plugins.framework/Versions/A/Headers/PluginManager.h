#import <Cocoa/Cocoa.h>
#import <Plugins/Plugin.h>

@interface PluginManager : NSObject <NSTableViewDataSource,NSOutlineViewDataSource>
{
	NSMutableDictionary*     plugins;
    id<Plugin> selected;
}

+ (PluginManager*) defaultManager;

- (NSArray*) loadedPlugins;
- (NSArray*) loadedIdentifiers;

- (id<Plugin>) selectPlugin:(int) index;
- (id<Plugin>) selectedPlugin;

- (id<Plugin>) pluginWithIdentifier:(NSString*) ident;

- (void) loadPlugin:(NSString*) path;
- (void) unloadPlugin:(id<Plugin>) unload;

- (void) loadBuiltIns;
- (void) unloadPlugins;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under BSD-Style license.   */

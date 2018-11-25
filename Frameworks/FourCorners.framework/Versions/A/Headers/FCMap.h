#import <Cocoa/Cocoa.h>

#import <FourCorners/FCMapLayer.h>

/**

FCMap is a model of the aggregate map data avaliable as a set
of FCMapLayers.

FCMap manages these layers and their ordering as well as keeping track of
the map legend. As layers are added their 'layerInsertedIntoMap:atIndex:' 
selector is called so that they can add elemets to the legend. As they
are  removed their 'layerRemovedFromMap:' selector is called so the 
elements can be removed.

*/
@interface FCMap : NSObject 
{
    NSString* title;
    BOOL show_title;
    NSMutableDictionary* legend;
    BOOL show_legend;
    NSMutableArray* layers;
}

- (NSString *)title;
- (void)setTitle:(NSString *)aTitle;

#pragma mark Map Legend

- (BOOL) showLegend;
- (void) setShowLegend:(BOOL) show;
- (void) addImageToLegend:(NSImage*) icon withLabel:(NSString*) label;
- (void) removeLegendImageLabeled:(NSString*) label;
- (NSArray*) legendLabels;
- (NSImage*) imageForLegendLabel:(NSString*) label;

#pragma mark Layers

- (unsigned int) countLayers;
- (FCMapLayer*) layerAtIndex:(unsigned int)index;
- (void) addLayer:(FCMapLayer*)layer;
- (void) removeLayer:(FCMapLayer*)layer;
- (void) insertLayer:(FCMapLayer*)layer atIndex:(unsigned int)index;
- (void) removeLayerAtIndex:(unsigned int)index;
- (void) replaceLayerAtIndex:(unsigned int)index withLayer:(FCMapLayer*)layer;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */

#import <Cocoa/Cocoa.h>
#import <RadioStore/RSRadio.h>
#import <RadioStore/RSSample.h>

@interface RSSampleGraph : NSView
{
	BOOL   draw_bg;
	BOOL   draw_border;
    BOOL   draw_grid;
    BOOL   update;
    
    double grid_size;
	double falloff;
    double update_frequency;
    
	NSColor* fill_color;
	NSColor* border_color;
	NSColor* noise_color;
	NSColor* signal_color;
	NSColor* grid_color;
    
	RSRadio*  radio; // the node who's signal trend we're graphing
	RSSample* last_sample; // the last encouter we graphed
    
    NSTimer* animation_timer;
}

- (void) setRadio:(RSRadio*) node;
- (void) setFalloff:(double) fall;
- (void) setBgColor:(NSColor*) color;
- (void) setBorderColor:(NSColor*) color;
- (void) setSignalColor:(NSColor*) color;
- (void) setNoiseColor:(NSColor*) color;
- (void) setGridColor:(NSColor*) color;
- (void) setDrawBg:(BOOL) draw;
- (void) setDrawBorder:(BOOL) draw;
- (void) setDrawGrid:(BOOL) draw;
- (void) update:(id) sender;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */

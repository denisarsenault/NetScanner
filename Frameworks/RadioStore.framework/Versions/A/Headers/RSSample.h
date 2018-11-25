#import <Foundation/Foundation.h>
 
@interface RSSample : NSObject
{
    int             signal_dbi;
    int             noise_dbi;
    int             ism_channel;
    float           sample_signal;
    float           sample_noise;
    float           sample_freq;
    NSDate*         sample_date;
    NSDictionary*   sample_attrs;
}

/* initilizers set all attributes, and may set the attribute */

- (RSSample*) initWithSignalDBM:(int) signal
                       noiseDBM:(int) noise
                     ISMChannel:(int) channel;

- (RSSample*) initWithSignal:(float) signal
                       noise:(float) noise
                        freq:(float) freq;

- (RSSample*) initWithSignal:(float) signal
                       noise:(float) noise
                        freq:(float) freq
                        date:(NSDate*) date;

/* accessors for dbi information */

- (int) signalDBM;
- (int) noiseDBM;
- (int) ISMChannel;

/* accessors for the basic attributes, samples are read-only */

- (float) signal;
- (NSNumber*) signalValue;

- (float) noise;
- (NSNumber*)  noiseValue;

- (float) freq;
- (NSNumber*) freqValue;
- (NSString*) freqMhz;

- (int) channel;
- (NSNumber*) channelValue;

- (NSDate*) date;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */


/* the type of radio, there's one of these for each plugin */
enum RSRadioType
{
    RSTypeUnknown = -1,
    RSTypeAirPort,
    RSTypeBluetooth,
};

enum RSRadioSecure
{
    RSSecureUnknown = -1,
    RSSecureAirPortOpen	= 0,
    RSSecureAirPortWEP,
    RSSecureAirPortWPA_PSK,
    RSSecureAirPortWPA2_PSK,
    RSSecureAirPortWPA_Enterprise,
    RSSecureAirPortWPA2_Enterprise,
    RSSecureAirPortWPS,
    RSSecureDynamicWEP,
    RSSecureBluetoothMixed,
    RSSecureBluetoothEncrypted
}; // see CWSecurityMode

/* 

Channels in the ISM band range from: 2400 MHz – 2483.5 MHz

North America, Austraila and New Zeland use channnels 1 through 11

Eurpoe ETSI uses channels 1 through 13

Japan uses channels 1 through 13 

Mexico is included in the North America  regulatory domain; however, 
only channels 9 through 11 can be used in  Mexico. 

Israel is included in the ETSI  regulatory domain; however,
only channels 3 through 9 can be used in  Israel. 

France is included in the ETSI  regulatory domain; however,
only channels 10 through 13 can be used in  France. 

*/
static int const RSRadioISMChannelOffset = 5; // channels are offset 5mhz from each other

static int const RSRadio2ghzChannelWidth = 30; // channels are 30mhz wide

typedef enum // in Mhz
{
    ISMChannel1  = 2412,
    ISMChannel2  = 2417,
    ISMChannel3  = 2422,
    ISMChannel4  = 2427,
    ISMChannel5  = 2432,
    ISMChannel6  = 2437,
    ISMChannel7  = 2442,
    ISMChannel8  = 2447,
    ISMChannel9  = 2452,
    ISMChannel10 = 2457,
    ISMChannel11 = 2462,
    ISMChannel12 = 2467,
    ISMChannel13 = 2472,
    ISMChannel14 = 2477
}
RSRadio2ghzISMFrequencies;

static int const RSRadio5ghzChannelOffset = 20; // channels are offset 20mhz from each other
static int const RSRadio2ghz5ghzGap = 2773; // not sure if this is important, but why not?

typedef enum
{
    ISMChannel36 = 5180, // this is ISMChannel0 + 2773
    ISMChannel40 = 5200,
    ISMChannel44 = 5220,
    ISMChannel48 = 5240,
    ISMChannel52 = 5260,
    ISMChannel56 = 5280,
    ISMChannel60 = 5300,
    ISMChannel64 = 5320
}
RSRadio5ghzABandISMFrequencies;

typedef enum
{
    ISMChannel100 = 5500,
    ISMChannel104 = 5520,
    ISMChannel108 = 5540,
    ISMChannel112 = 5560,
    ISMChannel116 = 5580,
    ISMChannel120 = 5600,
    ISMChannel124 = 5620,
    ISMChannel128 = 5640,
    ISMChannel132 = 5660,
    ISMChannel136 = 5680,
    ISMChannel140 = 5700,
}
RSRadio5ghzBBandISMFrequencies;

typedef enum
{
    ISMChannel149 = 5745,
    ISMChannel153 = 5765,
    ISMChannel157 = 5785,
    ISBChannel161 = 5805
}
RSRadio5ghzCBandISMFrequencies;


@class RSSample;

/*!
    @class
    @abstract    model class for radio info from AirPort or Bluetooth Sources
    @discussion  
*/
@interface RSRadio : NSObject <NSPasteboardWriting>
{
    NSString*               radio_mac;
    NSString*               radio_name;
    enum RSRadioType        radio_type;
    enum RSRadioSecure      radio_secure;
    NSImage*				radio_icon;
    NSImage*				radio_small_icon;
    NSString*               radio_info;
    NSMutableDictionary*    radio_props;
    NSMutableArray*         radio_samples;
    RSSample*               best_sample;
}

+ (float) frequencyOfChannel:(int) channel;
+ (int) channelOfFrequency:(float) freq;

+ (float) signalDBIAsPercentage:(int) signal;

+ (NSString*) radioTypeString:(enum RSRadioType) type;

- (RSRadio*) initWithMac:(NSString*) mac 
                    name:(NSString*) name 
                    type:(enum RSRadioType) type 
                    secure:(enum RSRadioSecure) secure;

- (RSRadio*) initWithMac:(NSString*) mac 
                    name:(NSString*) name 
                    type:(enum RSRadioType) type 
                    secure:(enum RSRadioSecure) secure
                   props:(NSDictionary*) props;

/* these are the standard mutators for the principal attributes */

- (NSString*) mac;

- (NSString*) macVendor;

- (void) setMac:(NSString*)mac;

- (NSString*) name;
- (void) setName:(NSString*)mac;

- (enum RSRadioType) type;
- (void) setType:(enum RSRadioType)radio;

- (enum RSRadioSecure) secure;
- (void) setSecure:(enum RSRadioSecure) secure;

- (NSString*) info;
- (void) setInfo:(NSString*) info;

- (NSImage*) icon;
- (void) setIcon:(NSImage*) icon;
- (NSImage*) smallIcon;

/* string conversion conveniences  */

- (NSString*) typeAsString;
- (NSString*) secureAsString;

/* methods to manage the properties of the radio */

- (NSEnumerator*) propertyNames;
- (id) property:(NSString*) name;
- (void) setProperty:(NSObject*) prop forName:(NSString*) name;
- (void) removeProperty:(NSString*) name;
- (void) addPropertiesFromDictionary:(NSDictionary*) props;

/* methods to examine the samples taken of the radios signal */

- (void) addSample: (RSSample*) sample;
- (NSArray*) samples;
- (int) countSamples;
- (RSSample*) lastSample;
- (RSSample*) bestSample;

/* conveniance for addSample */

- (RSSample*) sampleSignalDBI:(int) signal
                     noiseDBI:(int) noise
                   ISMChannel:(int) channel;

- (RSSample*) sampleSignal:(float) signal
                     noise:(float) noise
                      freq:(float) freq;

/* methods to manage the population of samples by forgetting old ones */

- (int) forgetSamplesBefore:(NSDate*) thirty;

- (int) forgetSamplesBefore:(NSDate*) thirty saveLast:(BOOL) save;

/* get the radio's info in a convenient dictionary */
- (NSDictionary*) radioInfo;

- (NSString*) debugDescription;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */

#import <Foundation/Foundation.h>
#import "RSRadio.h"
#import "RSSample.h"

@interface RSStore : NSObject 
{
    BOOL                    store_unsaved;
    BOOL                    store_forgetful;
    int                     store_memory;

    NSMutableDictionary*    store_radios; // all radios by MAC
    NSMutableDictionary*    store_types;  // dict of NSMutableArrays for each type
    NSMutableDictionary*    store_names;  // dict of NSMutableArrays for each name
    
    /* TODO chrono index which can be quickly searched by date, 
        probably a labeled (dated) linked list */
}

/* returns an RSStore which is shared with all callers */
+ (RSStore*) sharedStore;

/* create a new RSStore and initilize it's indexes */
- (RSStore*) init;

/* stores the radio provided and send an
    radiostore.radio.stored notification with the node */
- (RSRadio*) storeRadio:(RSRadio*) node;

/* removes the radio provided and sends an 
    radiostore.radio.removed notificaion with the radio */
- (void) removeRadio:(RSRadio*) radio;

/* returns a RSRadio with the corresponding mac address */
- (RSRadio*) radioWithMAC:(NSString*) mac;

/* returns an NSArray of all the RSRadios in the RSStore */
- (NSArray*) radios;

/* returns the number of radios in the store */
- (int) countRadios;

/* returns an NSArray of NSStrings listing the types in the store */
- (NSArray*) radioTypes;

/* returns an NSArray of RSRadios of the type provided */
- (NSArray*) radiosOfType:(NSString*) type;

/* returns a count of the RSRadios of the type provided */
- (int) countRadiosOfType:(NSString*) type;

/* removes all radios of the type provided from the store */
- (void) removeRadiosOfType:(NSString*) type;

/* returns and NSArray of NSStrings listing the names in the store */
- (NSArray*) radioNames;

/* returns an NSArray of RSRadios with the name provided */
- (NSArray*) radiosOfName:(NSString*) string;

/* returns a count of the RSRadios with the name provided */
- (int) countRadiosOfName:(NSString*) string;

/* check the contents of the store for the mac provided */
- (BOOL) isMACStored:(NSString*) mac;

/*  Purges the store of RSRadios who's lastEncouter was before the
    date provided, sending a radiostore.radio.forgotten notification.
    The remaining nodes are forwarded the message and date so that
    they will purges their samples.
*/
- (int) forgetSamplesBefore:(NSDate*) thirty;

/*  purges the store of samples before a given date,
    if saveLast is YES the last encouter with each node will be
    saved and the nodes will be retained in the store even if
    they have not been seen since the date provided 
*/
- (int) forgetSamplesBefore:(NSDate*) thirty saveLast:(BOOL) save;

/* updates the stores notion of how long to remember samples */
- (void) onRememberSeconds:(NSNotification*)note;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */

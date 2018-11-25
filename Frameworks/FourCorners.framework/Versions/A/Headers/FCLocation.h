#import <Cocoa/Cocoa.h>

#import "FCCoordinate.h"

extern NSString* const FCLocationEstablishedNotification;
extern NSString* const FCLocationMovedNotification;
extern NSString* const FCLocationForgottenNotification;

#pragma mark -

typedef enum
{
    FCLocationNowhere,
    FCLocationAnywhere,
    FCLocationRestricted,
} FCSpecialLocation;

/**

The FCLocation protocol is for objects with a location.

It provides for an FCCoordinate, name, url, icon
and type information which can be used for
showing a location in a list or drawing a pin
on a map.

The FCLocation object sends FCLocationUpdated notifications
with the modified insance as it's object when the setters
are called. During 

*/
@protocol FCLocation <NSObject, NSCopying>

/** the FCCoordinate describing this location */
- (FCCoordinate*) coordinate;

/** set's the location of an object, sends
FCLocationEstablished notification if the 
location was previously nil */
- (void) setCoordinate:(FCCoordinate*)destination;

/** the display name of the location */
- (NSString*) locationName;

/** a URL pointing to information about this location */
- (NSString*) locationURL;

/** the Image to display for this location */
- (NSImage*) locationIcon;

/** the type, or class, of the location */
- (NSString*) locationType;

@end

/**

FCLocation is a basic implementation of the FCLocation protocol.

It illustrates the subtleties of sending the 
FCLocationEstablishedNotification and FCLocationUpdateNotifications,
it boils down to: don't send a flood of Updates them when you're 
creating the object, but be sure to let the listeners know when 
you have modified it so they can update their display. 

*/
@interface FCLocation : NSObject <FCLocation> // <NSCopying>
{
    BOOL send_notes;
    FCCoordinate*  location;
    NSString* name;
    NSString* url;
    NSString* type;
    NSImage*  icon;
}

+ (FCLocation*) specialLocation:(FCSpecialLocation) special;

- (id) initWithCoordinate:(FCCoordinate*) aPoint
                   name:(NSString*) aName;
- (id) initWithCoordinate:(FCCoordinate*) aPoint
                   name:(NSString*) aName
                   type:(NSString*) aString
                    URL:(NSString*) aURL
                   icon:(NSImage*) anIcon;
- (FCLocation*) copyWithZone:(NSZone*)zone;

- (void) setLocationName:(NSString*) name;
- (void) setLocationURL:(NSString*) url;
- (void) setLocationIcon:(NSImage*) image;
- (void) setLocationType:(NSString*) type;

@end


/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */

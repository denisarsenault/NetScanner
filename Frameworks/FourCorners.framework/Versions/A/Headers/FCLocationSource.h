#import <Cocoa/Cocoa.h>
#import <FourCorners/FCLocation.h>

#import "FCCoordinate.h"

extern NSString* const kFCLocationUpdate;
extern NSString* const kFCLocationSource;

/*! @class
    
    @abstract    Provides an interface for objects which can
                 provide an FCLocation for the current position
                 or translate a string into an FCLocation.
    @discussion  FCLocationSource is an abstract base class
    for all the location sources in the FourCorners framework
    it provides a generic interface for determining the current
    location converting location description strings to GPS
    locations and providing position and course updates for 
    some location sources.

    Location sources are either singletons tied to the current
    location of the computer and able to convert provided
    strings into FCLocation objects or are tied to a specific local device or network service 
*/
@interface FCLocationSource : NSObject 
{
}

#pragma mark Class Methods

+ (NSArray*) locationSources;

/*!
    @method     
    @abstract   Returns an FCLocationSource for a GPS Device
    @discussion Given a BSD devicename attemtps to open an
    NMEA serial device to read current GPS location data.
*/
+ (FCLocationSource*) GPSLocationSource:(NSString*) devicename;

/*!
    @method     
    @abstract   Returns an FCLocationSource for a GPSD Server
    @discussion Given a gpsd url in the form gpsd:host:port
    attempts to open a connection to the GPSD service and read
    GPS location data from the remote host.
*/
+ (FCLocationSource*) GPSDLocatoinSource:(NSString*) gpsd_url;

/*!
    @method     
    @abstract   Returns an FCLocationSource for the local IP
    @discussion Attempts to read the local IP or the external
    IP for the current private network then procedes to lookup
    that IP in an online databse mapping addresses to locations. 
*/
+ (FCLocationSource*) IPLocationSource;

/*!
    @method     
    @abstract   Returns GPS coordinates for world cities
    @discussion Consults a static table of GPS locations
    for major cities and returns the rough GPS location.
*/
+ (FCLocationSource*) CityLocationSource;

/*!
    @method     
    @abstract   Returns GPS coordinattes for an address
    @discussion Attempts to convert an address string to
    an FCLocation by looking up on public geocoding services.
*/
+ (FCLocationSource*) AddressLocationSource;

/*!
    @method     
    @abstract   Returns GPD Coordinates for a hostname
    @discussion Requests GPS informatoin from the DNS
    system for a particular hostname. Hostnames in the
    local domain are resolved via mDNS, FQDNs are 
    resolved via unicast DNS.
*/
+ (FCLocationSource*) DNSLocationSource:(NSString*) hostname;

/*!
 @method
 @abstract Returns a location source which uses CoreLocation for it's location data
 @discussion Requests GPS Location from CoreLocation
 */
+ (FCLocationSource*) CoreLocationSource;


+ (NSArray*) avaliableSources;

#pragma mark Instance Methods

// these methods provide meta information for the location source
- (NSString*) sourceName;
- (NSString*) sourceType;
- (FCDistance) horizontalAccuracy;
- (FCDistance) verticalAccuracy;

// determines if the source knows the current coordinates
- (BOOL) knowsCurrentCoordinates;
- (FCCoordinate*) currentCoordinates;

// determines if the source can convert a string to coordinates
- (BOOL) canConvertCoordinateString:(NSString*) description;
- (FCCoordinate*) coordinateForString:(NSString*) description;

// determines if the source provides updates of it's coordinates
- (BOOL) providesCoordinateUpdates;
- (void) startCoordinateUpdates;
- (void) stopCoordinateUpdates;

@end

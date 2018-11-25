// Copyright (c) 2003 Michael Rosellini. All rights reserved.
// See COPYING for terms of license.

#import <Foundation/Foundation.h>

typedef double FCDegrees;
typedef double FCDistance; // in meters
typedef double FCSpeed; // in meters / second
typedef double FCDirection; // in degrees, 0 is true north

extern FCDistance FCDistanceMax;
extern FCSpeed FCSpeedMax;
extern FCDirection FCDirectionMax;

typedef const char FCCardinal;
extern FCCardinal FCNorth; // = 'N';
extern FCCardinal FCSouth; // = 'S';
extern FCCardinal FCEast; // = 'E';
extern FCCardinal FCWest; // = 'W';

@interface FCCoordinate : NSObject <NSCopying> 
{
    FCDegrees latitude;
    FCDegrees longitude;
    FCDistance altitude;
    FCDistance precision;
}

@property(assign) FCDegrees latitude;
@property(assign) FCDegrees longitude;
@property(assign) FCDistance altitude;
@property(assign) FCDistance precision;

#pragma mark -

+ (FCCoordinate*)coordinate;
+ (FCCoordinate*)nowhere;
+ (FCCoordinate*)anywhere;
+ (FCCoordinate*)restricted;

+ (FCCoordinate*)coordinateWithCoordinate:(FCCoordinate*)p;

+ (FCCoordinate*)coordinateWithLongitude:(FCDegrees)lng
                                latitude:(FCDegrees)lat
                                altitude:(FCDistance)alt
                               precision:(FCDistance)dop;

+ (FCCoordinate*)coordinateWithLongitudeHemisphere:(FCCardinal)longitudeHemisphere
                                  longitudeDegrees:(FCDegrees)longitudeDegrees
                                  longitudeMinutes:(FCDegrees)longitudeMinutes
                                latitudeHemisphere:(FCCardinal)latitudeHemisphere
                                   latitudeDegrees:(FCDegrees)latitudeDegrees
                                   latitudeMinutes:(FCDegrees)latitudeMinutes
                                          altitude:(FCDistance)a
                                         precision:(FCDistance)d;

+ (FCCoordinate*)coordinateWithString:(NSString*)str;

#pragma mark -

- (FCCoordinate*)initWithCoordinate:(FCCoordinate*)p;

- (FCCoordinate*)initWithLongitude:(FCDegrees)lng
                          latitude:(FCDegrees)lat
                          altitude:(FCDistance)alt
                         precision:(FCDistance)d;

- (FCCoordinate*)initWithLongitudeHemisphere:(FCCardinal)longitudeHemisphere
                            longitudeDegrees:(FCDegrees)longitudeDegrees
                            longitudeMinutes:(FCDegrees)longitudeMinutes
                          latitudeHemisphere:(FCCardinal)latitudeHemisphere
                             latitudeDegrees:(FCDegrees)latitudeDegrees
                             latitudeMinutes:(FCDegrees)latitudeMinutes
                                    altitude:(FCDistance)a
                                   precision:(FCDistance)d;

- (FCCoordinate*)initWithString:(NSString*)str;

#pragma mark -

- (FCCardinal)longitudeHemisphere;
- (FCDegrees)longitudeDegrees;
- (FCDegrees)longitudeMinutes;
- (FCDegrees)longitudeSeconds;

#pragma mark -

- (FCCardinal)latitudeHemisphere;
- (FCDegrees)latitudeDegrees;
- (FCDegrees)latitudeMinutes;
- (FCDegrees)latitudeSeconds;

#pragma mark -

/** @returns the distance to the specified point, in meters */
- (FCDistance) distanceTo:(FCCoordinate*) point;

/** @returns the bearing to the specified point, in degrees */
- (FCDirection) directionTo:(FCCoordinate*) point;

#pragma mark -

- (NSString*)description;

@end

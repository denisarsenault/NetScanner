//
//  FCDeadReckoning.h
//  FourCorners
//
//  Created by alf on 2009.08.23.
//  Copyright 2009 istumbler.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FCCoordinate.h"

/*!
    @class
    @abstract    Provides inertial navigation estimates for distance and direction
    @discussion  Uses the accelerometer to provide approximate travel distance 
 				 Uses a magnitomiter or location sources, to provide approximate direction of travel
*/

@interface FCDeadReckoning : NSObject 
{
	FCCoordinate* startPoint;
    FCCoordinate* reckonedPoint;
    FCDistance distanceAccuracy;
    FCDegrees directionAccuracy;
@private
    NSMutableDictionary* trackingPoints; // maps point names provided to FCCoordinates
}

@property(retain) FCCoordinate* startPoint;
@property(retain) FCCoordinate* reckonedPoint;
@property(readonly) FCDistance distanceAccuracy;
@property(readonly) FCDegrees directionAccuracy;

#pragma mark -

- (void) startReckoning;
- (void) stopReckoning;

#pragma mark -

- (FCDistance) distanceTravelled;
- (FCDegrees) directionTravelled;

#pragma mark -

- (void) addTrackingPoint:(NSString*) pointName;
- (void) addTrackingPoint:(NSString*) pointName atPoint:(FCCoordinate*) trackingPoint;
- (void) removeTrackingPoint:(NSString*) pointName;

- (FCDistance) distaceFromTrackingPoint:(NSString*) pointName;
- (FCDistance) accuracyFromTrackingPoint:(NSString*) pointName;

- (FCDegrees) directionFromTrackingPoint:(NSString*) pointName;
- (FCDegrees) declinationFromTrackingPoint:(NSString*) pointName;

@end

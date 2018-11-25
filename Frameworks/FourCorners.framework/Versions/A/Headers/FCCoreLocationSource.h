//
//  FCCoreLocationSource.h
//  FourCorners
//
//  Created by alf on 2009.08.16.
//  Copyright 2009 istumbler.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>

#import "FCLocationSource.h";

@interface FCCoreLocationSource : FCLocationSource <CLLocationManagerDelegate>
{
	CLLocationManager* manager;
    FCCoordinate* current;
}

@property(retain) CLLocationManager* manager;
@property(retain) FCCoordinate* current;

+ (FCCoreLocationSource*) coreLocationSource;


@end

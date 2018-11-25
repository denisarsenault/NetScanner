/** @protocol RSRemote store provides a lightweigth interface to 
    the RadioStore for distributed objects applications. */

@protocol RSRemoteStore

/** @returns an NSArray of mac addresses seen since */
- (bycopy NSArray*) macsSince:(in NSNumber*) seconds;

/** @returns an NSDictionary of the RSRadios info */
- (bycopy NSDictionary*) radioInfo:(in NSString*) mac 
                             since:(in NSNumber*) seconds;

- (bycopy NSArray*) radioInfoArray:(in NSString*) mac
                             since:(in NSNumber*) seconds;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
 Redistribution and use permitted under BSD-Style license.   */

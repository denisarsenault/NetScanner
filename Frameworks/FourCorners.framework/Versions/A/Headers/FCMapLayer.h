#import <Cocoa/Cocoa.h>


@interface FCMapLayer : NSObject 
{
    NSString* name;
    NSString* info;
}

- (NSString *)name;
- (void)setName:(NSString *)aName;

- (NSString *)info;
- (void)setInfo:(NSString *)anInfo;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */

#import <RadioStore/RSRadio.h>
#import <RadioStore/RSSample.h>
#import <RadioStore/RSStore.h>
#import <RadioStore/RSRemoteStore.h>

/** 

@class RSStoreServer is default implementation of the RSRemoteStore protocol
it adds methos for creating a local instance via it's initWithStore: method
or a class method for creating a remote instance via i'ts remoteStore: method.

*/
@interface RSStoreServer : NSObject <RSRemoteStore,NSConnectionDelegate>
{
    RSStore* store;
    NSConnection* listener;
    NSTimeInterval timeframe;
}

- (id) initWithStore:(RSStore*) store;

/** @returns BOOL if the server was started */
- (BOOL) startServer;

/** @returns BOOL if the server was stopped */
- (BOOL) stopServer;

@end

/* Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license. */

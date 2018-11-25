#import <Foundation/Foundation.h>

#import <RadioStore/RSStore.h>
#import <RadioStore/RSRadio.h>
#import <RadioStore/RSSample.h>

@interface RSStoreTable : NSObject <NSTableViewDataSource>
{
    RSStore* store;
    NSString* type;
}

- (id) initWithStore:(RSStore*) theStore;
- (id) initWithStore:(RSStore*) theStore typeFilter:(NSString*) type;

- (RSRadio*) tableView:(NSTableView*) table radioForRow:(int) row;
- (NSColor*) tableView:(NSTableView*) table textColorForRow:(int) row;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */

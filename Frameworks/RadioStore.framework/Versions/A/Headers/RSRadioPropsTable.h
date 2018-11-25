#import <Cocoa/Cocoa.h>
#import <RadioStore/RSRadio.h>

@interface RSRadioPropsTable : NSObject <NSTableViewDataSource>
{
    RSRadio* radio;
}

- (void) setRadio:(RSRadio*) theRadio;
- (int) numberOfRowsInTableView:(NSTableView*) theTable;
- (id)              tableView:(NSTableView*) theTable 
    objectValueForTableColumn:(NSTableColumn*) aTableColumn 
                          row:(int) rowIndex;

@end

/*  Copyright (c) 2010, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license.   */

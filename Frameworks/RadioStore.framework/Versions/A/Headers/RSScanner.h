#import <Cocoa/Cocoa.h>

/*
 
RSScanner is a base class for tasks which are controlled
by the iStumbler slider. Tasks may be run in the existing 
thread or a new thread.
 
*/
@interface RSScanner : NSObject 
{
	double  scan_interval;
    NSTimer* scan_timer;
    NSRunLoop* scan_loop;
    
    /* thread state info */
	BOOL is_scanning;
    BOOL is_threaded;
}

- (id) init;
- (void) destroy;

/* scanner properties */
- (double) scanInterval;
- (void) setScanInterval:(double) interval;

- (BOOL) isThreaded;
- (void) setThreaded:(BOOL) threaded;

/* methods for starting and stopping the scanner */
- (BOOL) isScanning;
- (void) startScanning:(id) sender;
- (void) stopScanning:(id) sender;

/* thread body */
- (void) run:(id) sender;
- (void) runOnce;

/*  methods overriden by subclass 
    TODO maybe use a delegate instead? */
- (void) scanStarting;
- (void) scanTask:(NSDate*) naptime;
- (void) scanTimer:(NSTimer*) timer;
- (void) scanStopping;

/* notifications */
- (void) onSliderMove:(NSNotification*) note;
- (void) onSliderPause:(NSNotification*) note;

@end

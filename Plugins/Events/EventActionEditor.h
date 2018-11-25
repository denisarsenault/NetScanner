#import <Cocoa/Cocoa.h>

#import "Event.h"
#import "EventAction.h"

/* Controls an action editor view and */
@interface EventActionEditor : NSObject 
{
    EventAction* edited;
}

- (id) initWithAction:(EventAction*) action;

- (void) setAction:(EventAction*) action;
- (EventAction*) action;

@end

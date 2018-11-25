//
//  TouchAppDelegate.h
//  Touch
//
//  Created by alf on 2009.10.26.
//  Copyright istumbler.net 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

//
//  AAAppDelegate.m
//  A-Algorithm
//
//  Created by TheSooth on 7/29/13.
//  Copyright (c) 2013 TheSooth. All rights reserved.
//

#import "AAAppDelegate.h"
#import "AARootViewController.h"

@implementation AAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    AARootViewController *rootVC = [AARootViewController new];
    
    self.window.rootViewController = rootVC;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end

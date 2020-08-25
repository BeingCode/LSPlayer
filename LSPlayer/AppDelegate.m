//
//  AppDelegate.m
//  LSPlayer
//
//  Created by next on 2020/8/24.
//  Copyright © 2020 next. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    EasyNavigationController *navVC = [[EasyNavigationController alloc] initWithRootViewController:[ViewController new]];
    self.window.rootViewController  = navVC ;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

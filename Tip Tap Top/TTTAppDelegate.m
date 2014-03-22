//
//  TTTAppDelegate.m
//  Tip Tap Top
//
//  Created by Jo Albright on 3/20/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

#import "TTTAppDelegate.h"

#import "TTTRootVC.h"
#import "TTTNavController.h"

@implementation TTTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    TTTNavController *navController = [[TTTNavController alloc] initWithRootViewController:[[TTTRootVC alloc] init]];
    
//    self.window.rootViewController = [[TTTRootVC alloc] init];
    self.window.rootViewController = navController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

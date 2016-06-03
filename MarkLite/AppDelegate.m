//
//  AppDelegate.m
//  MarkLite
//
//  Created by zhubch on 11/3/15.
//  Copyright (c) 2015 zhubch. All rights reserved.
//

#import "AppDelegate.h"
#import "Configure.h"
#import "TabBarController.h"
#import "FileManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UITabBar appearance] setTintColor:kThemeColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:kThemeColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if (launchOptions && launchOptions[UIApplicationLaunchOptionsShortcutItemKey]) {
        return NO;
    }

    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    [Configure sharedConfigure].launchOptions = @{@"type":shortcutItem.type,@"path":shortcutItem.localizedSubtitle};
    if (kDevicePhone) {
        [[TabBarController currentViewContoller].navigationController popToViewController:[TabBarController currentViewContoller].navigationController.viewControllers[1] animated:NO];
        [TabBarController currentViewContoller].selectedIndex = 0;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"launchFormShortCutItem" object:@{@"type":shortcutItem.type,@"path":shortcutItem.localizedSubtitle}];
    completionHandler(YES);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[FileManager sharedManager].root archive];
    [[Configure sharedConfigure] saveToFile];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[FileManager sharedManager].root archive];
    [[Configure sharedConfigure] saveToFile];
}

@end

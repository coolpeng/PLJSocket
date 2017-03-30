//
//  AppDelegate.m
//  PLJSocket
//
//  Created by Edward on 17/3/30.
//  Copyright © 2017年 coolpeng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setWindowRootViewController];
    return YES;
}

//  设置Window的rootViewController
- (void)setWindowRootViewController {
    UITabBarController *mainTabBarController = [[UITabBarController alloc] init];
    mainTabBarController.tabBar.translucent = NO;
    mainTabBarController.tabBar.tintColor = [UIColor blackColor];
    
    //  类名
    NSArray *classNames = @[
                            @"ViewController",
                            @"SecondViewController",
                            ];
    //  标题名
    NSArray *titles = @[
                        @"服务器",
                        @"客户端",
                        ];
    
    //  分别实例化并添加到nav中
    for (int i = 0 ; i<classNames.count; i++) {
        Class class = NSClassFromString(classNames[i]);
        UIViewController *oneVC = [[class alloc] init];
        oneVC.title = titles[i];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:oneVC];
        navVC.navigationBar.translucent = NO;
        navVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:nil tag:i];
        [mainTabBarController addChildViewController:navVC];
    }
    
    self.window.rootViewController = mainTabBarController;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

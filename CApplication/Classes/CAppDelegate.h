//
//  CAppDelegate.h
//  CApplication
//
//  Created by 张九州 on 2017/12/28.
//  Copyright © 2017年 张九州. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

@protocol CAppEventListener

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

@end

@interface CAppDelegate : NSObject <UIApplicationDelegate>

+ (void)addEventListener:(id<CAppEventListener>)listener;
+ (void)removeEventListener:(id<CAppEventListener>)listener;

@end

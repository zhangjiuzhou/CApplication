//
//  CAppDelegate.h
//  CApplication
//
//  Created by 张九州 on 2017/12/28.
//  Copyright © 2017年 张九州. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

#define CExportAppEventListener \
    + (void)load { \
        [CAppDelegate addEventListener:[self sharedInstance]]; \
    } \
    + (instancetype)sharedInstance { \
        static id instance; \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            instance = [self new]; \
        }); \
        return instance; \
    } \

@protocol IAppEventListener <NSObject>

@optional

- (BOOL)willFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (BOOL)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)didBecomeActive;
- (void)willResignActive;
- (void)willEnterForeground;
- (void)didEnterBackground;
- (void)willTerminate;
- (void)didReceiveMemoryWarning;
- (BOOL)openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
- (BOOL)performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler;

@end

@interface CAppDelegate : NSObject <UIApplicationDelegate>

+ (void)addEventListener:(id<IAppEventListener>)listener;
+ (void)removeEventListener:(id<IAppEventListener>)listener;

@end

//
//  CAppDelegate.m
//  CApplication
//
//  Created by 张九州 on 2017/12/28.
//  Copyright © 2017年 张九州. All rights reserved.
//

#import "CAppDelegate.h"
#import "CURLRouter.h"

@interface CAppDelegate ()

@property (nonatomic, strong) NSMutableSet<id<CAppEventListener>> *listeners;

@end

@implementation CAppDelegate

+ (void)addEventListener:(id<CAppEventListener>)listener {
    CAppDelegate *delegate = (CAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.listeners addObject:listener];
}

+ (void)removeEventListener:(id<CAppEventListener>)listener {
    CAppDelegate *delegate = (CAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.listeners removeObject:listener];
}

- (instancetype)init {
    if (self = [super init]) {
        self.listeners = [NSMutableSet set];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    for (id<UIApplicationDelegate> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(application:willFinishLaunchingWithOptions:)]) {
            if (![listener application:application willFinishLaunchingWithOptions:launchOptions]) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    for (id<UIApplicationDelegate> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
            if (![listener application:application didFinishLaunchingWithOptions:launchOptions]) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    for (id<UIApplicationDelegate> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [listener applicationDidBecomeActive:application];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    for (id<UIApplicationDelegate> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(applicationWillResignActive:)]) {
            [listener applicationWillResignActive:application];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    for (id<UIApplicationDelegate> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(applicationWillEnterForeground:)]) {
            [listener applicationWillEnterForeground:application];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    for (id<UIApplicationDelegate> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [listener applicationDidEnterBackground:application];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    for (id<UIApplicationDelegate> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(applicationWillTerminate:)]) {
            [listener applicationWillTerminate:application];
        }
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    for (id<UIApplicationDelegate> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(applicationDidReceiveMemoryWarning:)]) {
            [listener applicationDidReceiveMemoryWarning:application];
        }
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    for (id<UIApplicationDelegate> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(application:openURL:options:)]) {
            if ([listener application:app openURL:url options:options]) {
                return YES;
            }
        }
    }

    if ([CURLRouter openURL:url]) {
        return YES;
    }

    return NO;
}

@end

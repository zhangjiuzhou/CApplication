//
//  CAppDelegate.m
//  CApplication
//
//  Created by 张九州 on 2017/12/28.
//  Copyright © 2017年 张九州. All rights reserved.
//

#import "CAppDelegate.h"
#import "CURLRouter.h"

static CAppDelegate *appDelegate = nil;

@interface CAppDelegate ()

@property (nonatomic, strong) NSMutableSet<id<IAppEventListener>> *listeners;

@end

@implementation CAppDelegate

+ (void)addEventListener:(id<IAppEventListener>)listener {
    CAppDelegate *delegate = [self sharedDelegate];
    [delegate.listeners addObject:listener];
}

+ (void)removeEventListener:(id<IAppEventListener>)listener {
    CAppDelegate *delegate = [self sharedDelegate];
    [delegate.listeners removeObject:listener];
}

+ (instancetype)sharedDelegate {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appDelegate = [super allocWithZone:zone];
    });
    return appDelegate;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appDelegate = [super init];
        appDelegate.listeners = [NSMutableSet set];
    });
    return appDelegate;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    for (id<IAppEventListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(willFinishLaunchingWithOptions:)]) {
            if (![listener willFinishLaunchingWithOptions:launchOptions]) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    for (id<IAppEventListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(didFinishLaunchingWithOptions:)]) {
            if (![listener didFinishLaunchingWithOptions:launchOptions]) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    for (id<IAppEventListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(didBecomeActive)]) {
            [listener didBecomeActive];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    for (id<IAppEventListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(willResignActive)]) {
            [listener willResignActive];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    for (id<IAppEventListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(willEnterForeground)]) {
            [listener willEnterForeground];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    for (id<IAppEventListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(didEnterBackground)]) {
            [listener didEnterBackground];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    for (id<IAppEventListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(willTerminate)]) {
            [listener willTerminate];
        }
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    for (id<IAppEventListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(didReceiveMemoryWarning)]) {
            [listener didReceiveMemoryWarning];
        }
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    for (id<IAppEventListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(openURL:options:)]) {
            if ([listener openURL:url options:options]) {
                return YES;
            }
        }
    }

    if ([CURLRouter openURL:url]) {
        return YES;
    }

    return NO;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    for (id<IAppEventListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(performActionForShortcutItem:completionHandler:)]) {
            if ([listener performActionForShortcutItem:shortcutItem completionHandler:completionHandler]) {
                return;
            }
        }
    }
}

@end

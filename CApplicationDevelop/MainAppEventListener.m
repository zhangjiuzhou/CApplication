//
//  MainAppEventListener.m
//  CApplicationDevelop
//
//  Created by 张九州 on 2017/12/29.
//  Copyright © 2017年 张九州. All rights reserved.
//

#import "MainAppEventListener.h"
#import "ViewController.h"

@interface MainAppEventListener ()

@property (nonatomic, strong) UIWindow *window;

@end

@implementation MainAppEventListener

CExportAppEventListener

- (BOOL)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [UIWindow new];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

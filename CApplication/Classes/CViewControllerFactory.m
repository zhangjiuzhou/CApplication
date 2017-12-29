//
//  CViewControllerFactory.m
//  CApplication
//
//  Created by 张九州 on 2017/12/29.
//  Copyright © 2017年 张九州. All rights reserved.
//

#import "CViewControllerFactory.h"

@implementation CViewControllerFactory

+ (UIViewController *)viewControllerWithClass:(Class)kclass params:(NSDictionary *)params {
    return [self viewControllerWithClass:kclass params:params complete:nil];
}

+ (UIViewController *)viewControllerWithClass:(Class)kclass
                                       params:(NSDictionary *)params
                                     complete:(CViewControllerComplete)complete {
    NSAssert([kclass isSubclassOfClass:[UIViewController class]], nil);

    UIViewController *viewController = [kclass new];

    if ([kclass respondsToSelector:@selector(paramNames)] && params) {
        for (NSString *paramName in [kclass paramNames]) {
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [paramName capitalizedString]]);
            if ([viewController respondsToSelector:selector] && params[paramName]) {
                [viewController setValue:params[paramName] forKey:paramName];
            }
        }
    }

    if ([viewController respondsToSelector:@selector(setComplete:)] && complete) {
        [(id<IViewController>)viewController setComplete:complete];
    }

    return viewController;
}

@end

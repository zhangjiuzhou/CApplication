//
//  CViewControllerFactory.h
//  CApplication
//
//  Created by 张九州 on 2017/12/29.
//  Copyright © 2017年 张九州. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CViewControllerComplete)(
                                        UIViewController *viewController,
                                        id data,
                                        NSError *error);

@protocol IViewController

@optional
+ (NSArray *)paramNames;
- (void)setComplete:(CViewControllerComplete)complete;

@end

@interface CViewControllerFactory : NSObject

+ (UIViewController *)viewControllerWithClass:(Class)kclass params:(NSDictionary *)params;
+ (UIViewController *)viewControllerWithClass:(Class)kclass
                                       params:(NSDictionary *)params
                                     complete:(CViewControllerComplete)complete;

@end

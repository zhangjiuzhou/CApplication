//
//  ViewController.m
//  CApplicationDevelop
//
//  Created by 张九州 on 2017/12/26.
//  Copyright © 2017年 张九州. All rights reserved.
//

#import "ViewController.h"
#import <CApplication/CApplication.h>
#import "IFListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"CApplication";
    self.view.backgroundColor = [UIColor whiteColor];

    [CURLRouter setDefaultScheme:@"zjz"];
    [[CURLRouter router] addRoute:@"/info/detail/:type/:id" callback:^(CURLParts *parts) {
        NSLog(@"%@", parts);
    }];
    [CURLRouter openURL:[NSURL URLWithString:@"//info//////detail/12/1331?uid=SADFS"]];

//    id vc = [CViewControllerFactory viewControllerWithClass:[IFListViewController class]
//                                                     params:@{@"type":@"5"}];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController pushViewController:vc animated:YES];
//    });

    [CURLRouter URLWithRoute:@"/:module/:page" params:@{
                                                        @"module": @"fund",
                                                        @"page": @"detail",
                                                        @"id": @1001
                                                        }];
}

@end

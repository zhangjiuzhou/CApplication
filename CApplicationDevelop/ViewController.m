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
    [[CURLRouter router] addRoute:@"/info/list/:type" callback:^(CURLParts *parts) {
        id vc = [CViewControllerFactory viewControllerWithClass:[IFListViewController class]
                                                         params:parts.params];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [CURLRouter openURL:[CURLRouter URLWithRoute:@"/info/list/:type" params:@{@"type": @15}]];
    });
}

@end

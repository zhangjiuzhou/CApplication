//
//  IFListViewController.m
//  CApplicationDevelop
//
//  Created by 张九州 on 2017/12/29.
//  Copyright © 2017年 张九州. All rights reserved.
//

#import "IFListViewController.h"
#import <CApplication/CApplication.h>

@interface IFListViewController () <IViewController>

@property (nonatomic, assign) NSInteger type;

@end

@implementation IFListViewController

+ (NSArray *)paramNames {
    return @[@"type"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"列表%ld", (long)self.type];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end

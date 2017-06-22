//
//  CustomNavigationController.m
//  WeChatLocationDemo
//
//  Created by 周英斌 on 2017/6/22.
//  Copyright © 2017年 周英斌. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Overwrite


- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
- (UIViewController *)childViewControllerForStatusBarHidden{
    return self.topViewController;
}

@end

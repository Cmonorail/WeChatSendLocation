//
//  ViewController.m
//  WeChatLocationDemo
//
//  Created by 周英斌 on 2017/6/17.
//  Copyright © 2017年 周英斌. All rights reserved.
//

#import "ViewController.h"
#import "YBLocationPickerViewController.h"
#import "YBShowLocationVC.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;
@property (strong, nonatomic) NSDictionary *locationInfo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:17/255.0f green:16/255.0f blue:19/255.0f alpha:1]];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)selectAddressAction:(id)sender {

    YBLocationPickerViewController *picker = [[YBLocationPickerViewController alloc] init];
    [self.navigationController pushViewController:picker animated:YES];
    picker.locationSelectBlock = ^(id locationInfo, YBLocationPickerViewController *locationPickController) {
        NSLog(@"%@",locationInfo);
        //返回name address pt pt为坐标
        self.addresslabel.text = [NSString stringWithFormat:@"%@ %@",locationInfo[@"name"],locationInfo[@"address"]];
        self.locationInfo = locationInfo;
    };
}

- (IBAction)showAddressAction:(id)sender {
    if (self.locationInfo) {
        double lat = [[self.locationInfo[@"pt"] componentsSeparatedByString:@","].firstObject doubleValue];
        double lng = [[self.locationInfo[@"pt"] componentsSeparatedByString:@","].lastObject doubleValue];
        CLLocationCoordinate2D coordinate = {lat,lng};
        YBShowLocationVC *vc = [[YBShowLocationVC alloc] initWithCoordinate:coordinate];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

@end

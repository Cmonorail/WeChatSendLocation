//
//  YBShowPanoranaVC.m
//  9999md-doctor
//
//  Created by 周英斌 on 2017/6/19.
//  Copyright © 2017年 ZhouYingbin. All rights reserved.
//

#import "YBShowPanoranaVC.h"
#import <BaiduPanoSDK/BaiduPanoramaView.h>

#define kPanoranaKey @"yRaVnE0fOqG1ratuy5bFKyHBGdkKQGm7"
@interface YBShowPanoranaVC ()
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) BaiduPanoramaView  *panoranaView;
@end

@implementation YBShowPanoranaVC

#pragma mark - LifeCycle


- (instancetype)initWithlat:(double)lat lon:(double)lon
{
    self = [super init];
    if (self) {
        _coordinate = CLLocationCoordinate2DMake(lat, lon);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"全景展示";
    self.panoranaView = [[BaiduPanoramaView alloc] initWithFrame:self.view.bounds key:kPanoranaKey];
    [self.panoranaView setPanoramaWithLon:self.coordinate.longitude lat:self.coordinate.latitude];
    [self.view addSubview:self.panoranaView];
}

@end

//
//  BaiduPanoImageOverlay.h
//  BaiduPanoSDK
//
//  Created by baidu on 15/4/23.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "BaiduPanoOverlay.h"
@interface BaiduPanoImageOverlay : BaiduPanoOverlay
@property(strong, nonatomic) NSURL   *url;
@property(assign, nonatomic) CGSize  size;
@property(strong, nonatomic) UIImage *image;
@end

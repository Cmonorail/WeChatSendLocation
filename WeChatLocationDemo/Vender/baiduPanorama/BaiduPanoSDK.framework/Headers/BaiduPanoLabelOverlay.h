//
//  BaiduPanoLabelOverlay.h
//  BaiduPanoSDK
//
//  Created by baidu on 15/4/23.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduPanoOverlay.h"
#import <UIKit/UIKit.h>

@interface BaiduPanoLabelOverlay : BaiduPanoOverlay
@property(copy, nonatomic) NSString       *text;
@property(strong, nonatomic) UIColor      *textColor;
@property(strong, nonatomic) UIColor      *backgroundColor;
@property(assign, nonatomic) NSInteger    fontSize;
@property(assign, nonatomic) UIEdgeInsets edgeInsets;
@end


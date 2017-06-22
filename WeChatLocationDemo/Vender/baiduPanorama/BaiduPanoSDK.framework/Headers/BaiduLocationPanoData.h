//
//  BaiduLocationPanoData.h
//  BaiduPanoSDK
//
//  Created by bianheshan on 15/7/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "BaiduPanoData.h"

@interface BaiduLocationPanoData : BaiduPanoData

@property (copy, nonatomic) NSString *pid;// 某一地点的全景图区唯一ID
@property (copy, nonatomic) NSString *roadName;// 当前地点道路名称
@property (copy, nonatomic) NSString *mode; // 模式

@end

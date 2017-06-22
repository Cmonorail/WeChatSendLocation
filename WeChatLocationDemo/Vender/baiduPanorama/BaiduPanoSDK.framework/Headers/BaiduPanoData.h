//
//  BaiduPanoData.h
//  BaiduPanoSDK
//
//  Created by bianheshan on 15/5/4.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaiduPanoData : NSObject

@property (assign, nonatomic) double   panoX;//采集车墨卡托x坐标
@property (assign, nonatomic) double   panoY;//采集车墨卡托y坐标
@property (assign, nonatomic) double   x; // POI 坐标点墨卡托x坐标
@property (assign, nonatomic) double   y; // POI 坐标点墨卡托y坐标
@property (copy, nonatomic) NSString *type; // 街景类型
@property (copy, nonatomic)   NSString *sdkVersion;// SDK版本
@property (assign, nonatomic) int errorCode;// 错误编码
@property (copy, nonatomic)   NSString *desc;// 错误描述
@property (assign, nonatomic) BOOL     hasPanorama; // 是否有全景

@end

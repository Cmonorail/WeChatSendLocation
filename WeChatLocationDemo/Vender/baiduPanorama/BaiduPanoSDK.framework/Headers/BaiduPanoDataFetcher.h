//
//  BaiduPanoDataFetcher.h
//  BaiduPanoSDK
//
//  Created by bianheshan on 15/5/4.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduPoiPanoData.h"
#import "BaiduLocationPanoData.h"
@interface BaiduPanoDataFetcher : NSObject

/**
 * @abstract 获取室内全景描述信息,其中包含室内相册相关信息，需要开发者自己解析
 * @param   iid 室内信息的唯一ID，可以通过POI查询获取到
 */
+ (NSString *)requestPanoramaIndoorDataWithIid:(NSString *)iid;

/**
 * @abstract 获取某一个pid下对应的周边推荐信息
 * @param   pid 全景pid
 */
+ (NSString *)requestPanoramaRecommendationServiceDataWithPid:(NSString *)pid;

/**
 * @abstract 通过uid获取该poi下的全景描述信息，以此来判断此UID下是否有全景
 * @param    pid
 * @result   json string
 */
+ (BaiduPoiPanoData *)requestPanoramaInfoWithUid:(NSString *)uid;

/**
 * @abstract  通过墨卡托坐标获取坐标下全景的相关信息。
 * @param
 * @result   json string
 */
+ (BaiduLocationPanoData *)requestPanoramaInfoWithX:(double)x Y:(double)y;

/**
 * @abstract 通过经纬度获取经纬度下全景相关信息，例如pid，全景类型等
 * @param    pid
 * @result   json string
 */
+ (BaiduLocationPanoData *)requestPanoramaInfoWithLon:(double)lon Lat:(double)lat;
@end

//
//  BaiduPoiPanoData.h
//  BaiduPanoSDK
//
//  Created by bianheshan  on 15/7/9.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "BaiduPanoData.h"

@interface BaiduPoiPanoData : BaiduPanoData
@property (assign, nonatomic) double direction;
@property (copy, nonatomic)   NSString *pid;// 当前POI点下的全景图区唯一ID
@property (copy, nonatomic)   NSString *uid;// 该POI的唯一ID
@property (copy, nonatomic)   NSString *iid;// 假如有室内全景，那么这是室内信息的唯一ID
@property (copy, nonatomic)   NSString *interstartpid;// 假如有室内全景，那么这是相册中的第一个全景 pid
@property (copy, nonatomic)   NSString *name;// 该POI名称
@property (copy, nonatomic)   NSString *std_tag; // 标签
@property (assign, nonatomic) BOOL     hasStreet; // 该POI下是否有街景
@property (assign, nonatomic) BOOL     hasInterior;// 该POI下是否有室内全景
@end

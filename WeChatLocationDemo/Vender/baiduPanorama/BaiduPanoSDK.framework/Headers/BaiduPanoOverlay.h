//
//  BaiduPanoOverlay.h
//  BaiduPanoSDK
//
//  Created by bianheshan on 15/4/23.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef enum : NSUInteger {
    BaiduPanoOverlayTypeLabel,
    BaiduPanoOverlayTypeImage,
    BaiduPanoOverlayTypeUnknown,
} BaiduPanoOverlayType;
@interface BaiduPanoOverlay : NSObject
@property(strong, nonatomic) NSString *overlayKey;
@property(assign, nonatomic) BaiduPanoOverlayType type;
@property(assign, nonatomic) CLLocationCoordinate2D coordinate;
@property(assign, nonatomic) double    height;
@end

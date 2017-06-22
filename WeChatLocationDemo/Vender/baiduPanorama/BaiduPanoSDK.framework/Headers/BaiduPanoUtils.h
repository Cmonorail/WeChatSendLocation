//
//  BaiduPanoUtils.h
//  BaiduPanoSDK
//
//  Created by baidu on 15/4/28.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
typedef struct MecatorPoint
{
    double x;
    double y;
    MecatorPoint():x(0.0), y(0.0) {}
    MecatorPoint(double dx, double dy):x(dx), y(dy) {}
}MECATORPOINT, *BPMECATORPOINT;

typedef enum : NSUInteger {
    COOR_TYPE_BDLL = 1,//百度坐标
    COOR_TYPE_BDMC = 2,//百度墨卡托坐标
    COOR_TYPE_GPS     = 3,//GPS原始坐标
    COOR_TYPE_COMMON  = 4,//其他坐标，腾讯，高德，google等
} COOR_TYPE;

@interface BaiduPanoUtils : NSObject

+ (MECATORPOINT)getMcWithLon:(double)lon lat:(double)lat;
+ (const char *)convertUIImageToBitmapRGBA8:(UIImage *)image;
+ (CLLocationCoordinate2D)baiduCoorEncryptLon:(double)lon lat:(double)lat coorType:(COOR_TYPE)type;
+ (unsigned long) hexFromUIColor: (UIColor*) color;
+ (float) hexFromUIEdgeInsets:(UIEdgeInsets)edgeInsets;

+ (NSString *)distanceMcX1:(double) x1 mcY1:(double) y1 mcX2:(double) x2 mcY2:(double) y2;
@end

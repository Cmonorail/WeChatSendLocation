//
//  BaiduPanoramaView.h
//  BaiduPanoSDK
//
//  Created by bianheshan on 15/4/19.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "BaiduPanoImageOverlay.h"
#import "BaiduPanoLabelOverlay.h"
#import <CoreLocation/CoreLocation.h>
typedef enum : NSUInteger {
    ImageDefinitionHigh   = 5,// 高清图
    ImageDefinitionMiddle = 4,// 标准图
    ImageDefinitionLow    = 3,// 低清图
} ImageDefinition;

typedef enum : NSUInteger {
    BaiduPanoErrorEngineInitFailed      = 101,// 引擎初始化失败
    BaiduPanoErrorDescriptionLoadFailed = 102,// 引擎描述信息加载失败
    BaiduPanoErrorPanoramaLoadFailed    = 103,// 全景加载失败
    BaiduPanoErrorInteriorLoadFailed    = 201,// 全景室内图加载失败
    BaiduPanoErrorNoIndoorAlbumPlugin   = 202, // 全景室内图的插件没有安装
    BaiduPanoErrorNoIndoorAlbumPluginFunc   = 203 // 全景室内图的插件无对应方法
} BaiduPanoError;

typedef enum : NSUInteger {
    BaiduPanoramaTypeStreet =1,
    BaiduPanoramaTypeInterior =2,
} BaiduPanoramaType;

@class BaiduPanoramaView;
@class BaiduPoiPanoData;
@protocol BaiduPanoramaViewDelegate <NSObject>
@optional


#pragma mark - 全景回掉
/**
 * @abstract 全景图将要加载
 * @param panoramaView 当前全景视图
 */
- (void)panoramaWillLoad:(BaiduPanoramaView *)panoramaView;

/**
 * @abstract 全景图加载完毕
 * @param panoramaView 当前全景视图
 * @param jsonStr 全景单点信息
 *
 */
- (void)panoramaDidLoad:(BaiduPanoramaView *)panoramaView descreption:(NSString *)jsonStr;

/**
 * @abstract 全景图加载失败
 * @param panoramaView 当前全景视图
 * @param error 加载失败的返回信息
 *
 */
- (void)panoramaLoadFailed:(BaiduPanoramaView *)panoramaView error:(NSError *)error;

/**
 * @abstract 全景图中的覆盖物点击事件
 * @param overlayId 覆盖物标识
 */
- (void)panoramaView:(BaiduPanoramaView *)panoramaView overlayClicked:(NSString *)overlayId;

- (void)panoramaView:(BaiduPanoramaView *)panoramaView didReceivedMessage:(NSDictionary *)dict;

#pragma mark 室内相册回调

/**
 * @abstract 开发者自己设置的室内相册 View
 * @return 开发者创建的室内相册，如果不实现此代理，或者返回的 View 是空的话，那么仍然会调用默认相册
 */
- (UIView *)indoorAlbumViewForPanoramaView:(BaiduPanoramaView *)panoramaView poiData:(BaiduPoiPanoData *)data;


@end

@interface BaiduPanoramaView : UIView

@property(weak, nonatomic) id<BaiduPanoramaViewDelegate> delegate;

#pragma mark - 获取全景

/**
 * @abstract 全景视图初始化
 * @param frame 视图的frame
 * @param key   百度LBS开放平台接入密钥
 */
- (id)initWithFrame:(CGRect)frame key:(NSString *)key;

/**
 * @abstract 全景视图初始化
 * @param frame 视图的frame
 */
- (id)initWithFrame:(CGRect)frame;

/**
 * @abstract 全景视图初始化
 * @param frame 视图的frame
 * @param mcX   百度墨卡托坐标x
 * @param mcY   百度墨卡托坐标y
 */
- (id)initWithFrame:(CGRect)frame mcX:(NSInteger)x mcY:(NSInteger)y;

/**
 * @abstract 切换全景场景至指定全景pid
 * @param pid 全景唯一id
 *
 */
- (void)setPanoramaWithPid:(NSString *)pid;

/**
 * @abstract 设定应用接入密钥
 * @param key 通过LBS开放平台创建应用获得
 *
 */
- (void)setPanoramaAccessKey:(NSString *)key;
/**
 * @abstract 切换全景场景至指定的地理坐标
 * @param lon 百度地理坐标经度
 * @param lat 百度地理坐标纬度
 */
- (void)setPanoramaWithLon:(double)lon lat:(double)lat;

/**
 * @abstract 切换全景场景至指定的百度墨卡托坐标
 * @param x 百度墨卡托投影坐标x
 * @param y 百度墨卡托投影坐标y
 */
- (void)setPanoramaWithX:(NSInteger)x Y:(NSInteger)y;

/**
 * @abstract 切换全景场景至指定的UID下,UID为百度地图中POI唯一ID
 * @param uid 百度全景uid
 */
- (void)setPanoramaWithUid:(NSString *)uid;

/**
 * @abstract 根据POI指定UID显示全景，设置对应的街景，内景属性，因为有些POI下既有圈景又有内景
 * @param uid POI唯一ID
 * @param type 全景类型  室内  街景
 */
- (void)setPanoramaWithUid:(NSString *)uid type:(BaiduPanoramaType)type;

#pragma mark - 全景图属性设置以及获取
/**
 * @abstract 设置全景场景缩放级别
 * @param level 级别：1~5 缩放级别依次变大 默认值: 2
 *
 */
- (void)setPanoramaZoomLevel:(int)level;

/**
 * @abstract 设置全景场景使用图片级别
 * @param level 图片级别 清晰度:ImageDefinition，默认值:middle
 *
 */
- (void)setPanoramaImageLevel:(ImageDefinition)imageDefinition;

/**
 * @abstract 设置全景图的俯仰角
 * @param pitch 俯仰角:-90~90 度    默认值: 0 度
 */
- (void)setPanoramaPitch:(float)pitch;

/**
 * @abstract 设置全景图偏航角
 * @param heading 偏航角: 0~360 度  默认值: 0 度
 */
- (void)setPanoramaHeading:(float)heading;

/**
 * @abstract 设置道路剪头image
 * @param image UIImage对象
 */
- (void)setDirectionArrowImage:(UIImage *)image;

/**
 * @abstract 设置道路箭头指引,通过image的url
 * @param url 图片资源url
 */
- (void)setDirectionArrowByUrl:(NSString *)url;

/**
 * @abstract 是否显示道路箭头
 * @param isShow YES or NO
 */
- (void)showDirectionArrow:(BOOL) isShow;

/**
 * @abstract 是否开启快速前进
 * @param isOpen YES or NO
 */
- (void)enableFastMoving:(BOOL)isOpen;

/**
 * 是否处于开启中
 */
- (BOOL)isEnableFastMoving;

/**
 * @abstract 获取当前全景缩放级别
 */
- (float)getPanoramaZoomLevel;

/**
 * @abstract 获取当前全景俯仰角
 */
- (float)getPanoramaPitch;

/**
 * @abstract 获取当前全景朝向
 */
- (float)getPanoramaHeading;

/**
 * @abstract 获取当前全景FOV
 */
- (float)getPanoramaFOV;
#pragma mark - 全景图覆盖物
/**
 * @abstract 添加覆盖物
 * @param   overlay 抽象覆盖物
 */
- (void)addOverlay:(BaiduPanoOverlay *)overlay;

/**
 * @abstract 移除覆盖物
 * @param   overlayId
 */
- (void)removeOverlay:(NSString *)overlayId;

/**
 * @abstract 隐藏所有定制覆盖物
 * @param   overlayId
 */
- (void)setAllCustomOverlaysHidden:(BOOL)hidden;

/**
 * @abstract 隐藏 poi 覆盖物
 * @param   overlayId
 */
- (void)setPoiOverlayHidden:(BOOL)hidden;
/*
 *  @abstract 移除所有覆盖物
 *
 */
- (void)removeAllOverlay;

/**
 * @abstract 添加文字覆盖物
 * @param   key   覆盖物key
 * @param   x      x锚点
 * @param   y      y锚点
 */
- (void)setCustomOverlayAnchor:(NSString *)key x:(float)x y:(float)y;

/**
 * @abstract 添加文字覆盖物
 * @param   overlayid   覆盖物id
 * @param   coordinate  经纬度坐标
 * @param   height      覆盖物高度
 * @param   text        显示的文字
 */
- (void)addLabelOverlayById:(NSString *)overlayId
                 coordinate:(CLLocationCoordinate2D)coor
                     height:(double)height
                       text:(NSString *)text;

/**
 * @abstract 添加图片覆盖物
 * @param   overlayid   覆盖物id
 * @param   coordinate  经纬度坐标
 * @param   height      覆盖物高度
 * @param   image       覆盖物image
 */
- (void)addImageOverlayById:(NSString *)overlayId
                 coordinate:(CLLocationCoordinate2D)coor
                     height:(double)height
                      image:(UIImage *)image;
/**
 * @abstract 添加文字覆盖物
 * @param   overlayid   覆盖物id
 * @param   x   墨卡托坐标x
 * @param   y   墨卡托坐标y
 * @param   z   覆盖物高度z
 * @param   text    显示的文字
 */
- (void)addLabelOverlayById:(NSString *)overlayId
                          X:(NSInteger)x
                          Y:(NSInteger)y
                          Z:(NSInteger)z
                       text:(NSString *)text;

/**
 * @abstract 添加图片覆盖物
 * @param   overlayid   覆盖物id
 * @param   x   墨卡托坐标x
 * @param   y   墨卡托坐标y
 * @param   z   覆盖物高度z
 * @param   image    显示的图片
 */
- (void)addImageOverlayById:(NSString *)overlayId
                          X:(NSInteger)x
                          Y:(NSInteger)y
                          Z:(NSInteger)z
                      image:(UIImage *)image;

#pragma mark 屏幕坐标转化

- (void)convertCoorFromScreenX:(float)sX Y:(float)sY toMercatorX:(double *)mX Y:(double *)mY Z:(double *)mZ;
@end


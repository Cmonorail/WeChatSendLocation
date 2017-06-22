//
//  YBLocationSearchResultViewController.h
//  9999md-doctor
//
//  Created by 周英斌 on 2017/6/14.
//  Copyright © 2017年 ZhouYingbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLocationSearchResultViewController;
@class BMKPoiInfo;


@protocol YBLocationSearchResultViewControllerDelegate <NSObject>

- (void)YBLocationSearchResultViewController:(YBLocationSearchResultViewController *)searchResultController didSelectPoiWithPoiInfo:(BMKPoiInfo *)poiInfo keyword:(NSString *)keyword;

@end
@interface YBLocationSearchResultViewController : UITableViewController

@property (weak, nonatomic) id<YBLocationSearchResultViewControllerDelegate> delegate;


/**
 搜索关键字
 */
@property (copy, nonatomic) NSString *keyword;

/**
 定位地址
 */
@property (copy, nonatomic) NSString *userCity;

@end

//
//  YBLocationPickerViewController.h
//  9999md-doctor
//
//  Created by 周英斌 on 2017/6/14.
//  Copyright © 2017年 ZhouYingbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLocationPickerViewController;
typedef void(^locationSelectBlock)(id locationInfo,YBLocationPickerViewController *locationPickController);
@protocol YBLocationPickerViewControllerDelegate <NSObject>

- (void)locationPickerViewController:(YBLocationPickerViewController *)locationPickController didSelectAddressWithLocationInfo:(id)locationInfo;

@end

@interface YBLocationPickerViewController : UIViewController

@property (weak, nonatomic) id<YBLocationPickerViewControllerDelegate> delegate;
@property (copy, nonatomic) locationSelectBlock locationSelectBlock;
@end

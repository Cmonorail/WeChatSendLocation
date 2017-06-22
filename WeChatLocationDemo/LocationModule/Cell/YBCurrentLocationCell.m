//
//  YBCurrentLocationCell.m
//  9999md-doctor
//
//  Created by 周英斌 on 2017/6/14.
//  Copyright © 2017年 ZhouYingbin. All rights reserved.
//

#import "YBCurrentLocationCell.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface YBCurrentLocationCell ()
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation YBCurrentLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkImageView.hidden = !selected;
}

- (void)configureForData:(BMKPoiInfo *)data{
    self.namelabel.text = [NSString stringWithFormat:@"%@(%@)",data.name,data.address];
}
@end

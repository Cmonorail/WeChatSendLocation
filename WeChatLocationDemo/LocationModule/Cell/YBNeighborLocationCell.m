//
//  YBNeighborLocationCell.m
//  9999md-doctor
//
//  Created by 周英斌 on 2017/6/14.
//  Copyright © 2017年 ZhouYingbin. All rights reserved.
//

#import "YBNeighborLocationCell.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface YBNeighborLocationCell ()
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation YBNeighborLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkImageView.hidden = !selected;
}

- (void)configureForData:(BMKPoiInfo *)data{
    self.namelabel.text = data.name;
    self.addresslabel.text = data.address;
}
- (void)configureForData:(BMKPoiInfo *)data keyword:(NSString *)keyword{
    [self configureForData:data];
    if (keyword) {
        self.namelabel.attributedText = [self highlightKeyword:keyword origintext:data.name];
        self.addresslabel.attributedText = [self highlightKeyword:keyword origintext:data.address];
    }
}
- (NSMutableAttributedString *)highlightKeyword:(NSString *)keyword origintext:(NSString *)origintext{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:origintext];
    NSMutableArray *indexArray = @[].mutableCopy;
    for(int i =0; i < [origintext length]; i++)
    {
        NSString *temp = [origintext substringWithRange:NSMakeRange(i,1)];
        if ([keyword containsString:temp]) {
            [indexArray addObject:[NSValue valueWithRange:NSMakeRange(i, 1)]];
        }
    }
    
    [indexArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [obj rangeValue];
         [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:23/255.0f green:182/255.0f blue:0 alpha:1] range:range];
    }];
    return attributeStr;
}
@end

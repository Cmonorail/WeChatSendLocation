//
//  YBLocationSearchResultViewController.m
//  9999md-doctor
//
//  Created by 周英斌 on 2017/6/14.
//  Copyright © 2017年 ZhouYingbin. All rights reserved.
//

#import "YBLocationSearchResultViewController.h"
#import "YBNeighborLocationCell.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

static NSString *kSearchlocationResutlCellId = @"kSearchlocationResutlCellId";
@interface YBLocationSearchResultViewController ()<BMKPoiSearchDelegate>
@property (strong, nonatomic) NSMutableArray *searchResultArray;
@property (strong, nonatomic) BMKPoiSearch *poiSearch;
@end
@implementation YBLocationSearchResultViewController

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userCity = @"青岛市"; //默认
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"YBNeighborLocationCell" bundle:nil] forCellReuseIdentifier:kSearchlocationResutlCellId];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 60;
    [self.tableView setSeparatorColor:[UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1]];
    self.poiSearch = [[BMKPoiSearch alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.poiSearch.delegate = self;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.poiSearch.delegate = nil;

}
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    
    [self.searchResultArray removeAllObjects];
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        [self.searchResultArray addObjectsFromArray:poiResult.poiInfoList];
    }
    [self.tableView reloadData];
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YBNeighborLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchlocationResutlCellId];
    [cell configureForData:self.searchResultArray[indexPath.row] keyword:self.keyword];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BMKPoiInfo *poiInfo = self.searchResultArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(YBLocationSearchResultViewController:didSelectPoiWithPoiInfo:keyword:)]) {
        [self.delegate YBLocationSearchResultViewController:self didSelectPoiWithPoiInfo:poiInfo keyword:self.keyword];
    }    
}

#pragma mark - Private

- (void)_searchlocation{
    

    BMKCitySearchOption *option = [[BMKCitySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 30;
    option.keyword = self.keyword;
    option.city = self.userCity.length == 0?@"青岛市":self.userCity;
    BOOL flag = [self.poiSearch poiSearchInCity:option];

    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}
#pragma mark - Getter

- (NSMutableArray *)searchResultArray{
    if (!_searchResultArray) {
        _searchResultArray = @[].mutableCopy;
    }
    return _searchResultArray;
}
#pragma mark - Setter

- (void)setKeyword:(NSString *)keyword{
    _keyword = keyword;
    [self _searchlocation];
}

@end

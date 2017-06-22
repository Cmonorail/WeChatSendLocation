//
//  YBLocationPickerViewController.m
//  9999md-doctor
//
//  Created by 周英斌 on 2017/6/14.
//  Copyright © 2017年 ZhouYingbin. All rights reserved.
//

#import "YBLocationPickerViewController.h"
#import "YBNeighborLocationCell.h"
#import "YBCurrentLocationCell.h"
#import "YBLocationSearchResultViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@interface YBLocationPickerViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,YBLocationSearchResultViewControllerDelegate,UISearchResultsUpdating, UISearchControllerDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) BMKMapView *mapView;
@property (strong, nonatomic) BMKLocationService *locService;
@property (strong, nonatomic) BMKGeoCodeSearch *geoCodeSearch;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *redPinBtn;//中心位置大头针
@property (strong, nonatomic) UIButton *locationBtn;//定位按钮
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) YBLocationSearchResultViewController *searchResultController;
@property (strong, nonatomic) NSMutableArray<BMKPoiInfo *> *nearbylocations;//附近的地址
@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;
@property (assign, nonatomic, getter=isGeocode) BOOL geocode;
@property (assign, nonatomic, getter=isFirstlocation) BOOL firstlocation;
@property (copy, nonatomic) NSString *searchKeyword;

@end

static NSString *const kNearbylocationCellId = @"kNearbylocationCellId";
static NSString *const kCurrentlocationCellId = @"kCurrentlocationCellId";

@implementation YBLocationPickerViewController

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _statusBarStyle = UIStatusBarStyleLightContent;
        _geocode        = YES;
        _firstlocation  = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //config viewcontroller
    self.navigationItem.title = @"位置";
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.definesPresentationContext = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(saveLocationInfo)];
    sendItem.tintColor = [UIColor colorWithRed:39/255.0f green:225/255.0f blue:25/255.0f alpha:1];
    self.navigationItem.rightBarButtonItem = sendItem;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    cancelItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    //地理编码检索
    
    self.geoCodeSearch =[[BMKGeoCodeSearch alloc]init];
    
    //定位
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    //启动LocationService
    [self.locService startUserLocationService];
    
    
    [self.view addSubview:self.searchController.searchBar];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.redPinBtn];
    [self.view addSubview:self.locationBtn];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.geoCodeSearch.delegate = self;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.geoCodeSearch.delegate = nil;

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat mapHeight = 240;
    CGFloat scaleBarToBottom = 10;
    CGFloat scaleBarToleft = 15;
    CGFloat locationBtnToBottom = 30;
    CGFloat locationBtnToRight = 10;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screentHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.mapView.frame   = CGRectMake(0,CGRectGetHeight(self.searchController.searchBar.frame), screenWidth,mapHeight);
    self.mapView.mapScaleBarPosition = CGPointMake(scaleBarToleft,CGRectGetHeight(self.mapView.frame)-scaleBarToBottom-self.mapView.mapScaleBarSize.height);
    [self.redPinBtn setFrame:CGRectMake(0, 0, self.redPinBtn.currentImage.size.width, self.redPinBtn.currentImage.size.height)];
    [self.redPinBtn setCenter:self.mapView.center];
    [self.locationBtn setFrame:CGRectMake(CGRectGetWidth(self.view.frame)-locationBtnToRight-self.locationBtn.currentImage.size.width, CGRectGetMaxY(self.mapView.frame)-locationBtnToBottom-self.locationBtn.currentImage.size.height, self.locationBtn.currentImage.size.width, self.locationBtn.currentImage.size.height)];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.mapView.frame), screenWidth, screentHeight-CGRectGetMaxY(self.mapView.frame)-64);
}
#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (self.isFirstlocation) {
        self.searchResultController.userCity = result.addressDetail.city;
        self.firstlocation = NO;
    }
    [self.nearbylocations removeAllObjects];
    [self.nearbylocations addObjectsFromArray:result.poiList];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        self.searchKeyword = @"";
    });
}

#pragma mark - BMKLocationServiceDelegate
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    if (self.isFirstlocation) {
        [self _reverseGeoSearch:userLocation.location.coordinate];
        [self.mapView setCenterCoordinate:self.locService.userLocation.location.coordinate animated:YES];
        self.locationBtn.selected = YES;
    }
}

#pragma mark - BMKMapViewDelegate

//改变区域后
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    CLLocationCoordinate2D centerlocation= [mapView convertPoint:mapView.center toCoordinateFromView:mapView];

    BMKMapPoint centerPoint = BMKMapPointForCoordinate(centerlocation);
    BMKMapPoint userPoint   = BMKMapPointForCoordinate(self.locService.userLocation.location.coordinate);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(centerPoint,userPoint);
    if (distance <=100) {
        self.locationBtn.selected = YES;
    }else{
        self.locationBtn.selected = NO;
    }
    if (self.isGeocode) {
        [self _reverseGeoSearch:centerlocation];
    }
    
    self.geocode = YES;
}

#pragma mark - YBLocationSearchResultViewControllerDelegate

- (void)YBLocationSearchResultViewController:(YBLocationSearchResultViewController *)searchResultController didSelectPoiWithPoiInfo:(BMKPoiInfo *)poiInfo keyword:(NSString *)keyword{
    
    [self.searchController setActive:NO];
    self.searchKeyword = keyword;
    [self.mapView setCenterCoordinate:poiInfo.pt animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return self.nearbylocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    BMKPoiInfo*info = self.nearbylocations[indexPath.row];
    if (self.searchKeyword.length == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:indexPath.row == 0?kCurrentlocationCellId:kNearbylocationCellId];
        if ([cell isKindOfClass:[YBCurrentLocationCell class]]) {
            [(YBCurrentLocationCell *)cell configureForData:info];
        }else{
            [(YBNeighborLocationCell *)cell configureForData:info keyword:self.searchKeyword];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:kNearbylocationCellId];
        [(YBNeighborLocationCell *)cell configureForData:info keyword:self.searchKeyword];
    }
    return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BMKPoiInfo *info = [self.nearbylocations objectAtIndex:indexPath.row];
    //刷信地图位置
    [self.mapView setCenterCoordinate:info.pt animated:YES];
    self.geocode = NO;
}
#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    self.searchResultController.keyword = searchString;
    
}
#pragma mark - UISearchControllerDelegate

//切换状态栏颜色
- (void)willPresentSearchController:(UISearchController *)searchController{
    self.statusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)willDismissSearchController:(UISearchController *)searchController{
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}


#pragma mark - UIScrollViewDelegate


- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarStyle;
}
#pragma mark - Target

- (void)saveLocationInfo{
    //取选中的地址
    NSIndexPath *selectIndex = [self.tableView indexPathForSelectedRow];
    if (selectIndex.row >= 0) {
        BMKPoiInfo *info = [self.nearbylocations objectAtIndex:selectIndex.row];
        NSMutableDictionary *locationDic = [NSMutableDictionary dictionary];
        [locationDic setObject:info.name forKey:@"name"];
        [locationDic setObject:info.address forKey:@"address"];
        [locationDic setObject:[NSString stringWithFormat:@"%f,%f",info.pt.latitude,info.pt.longitude] forKey:@"pt"];
        if ([self.delegate respondsToSelector:@selector(locationPickerViewController:didSelectAddressWithLocationInfo:)]) {
            [self.delegate locationPickerViewController:self didSelectAddressWithLocationInfo:locationDic];
        }
        if (self.locationSelectBlock) {
            self.locationSelectBlock(locationDic, self);
        }
        [self cancel];
    }
}

- (void)manuallocation:(UIButton *)sender{
    [self.mapView setCenterCoordinate:self.locService.userLocation.location.coordinate animated:YES];
    if (!sender.isSelected) {
        sender.selected = YES;
    }
}
//取消
- (void)cancel{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Private

- (void)_reverseGeoSearch:(CLLocationCoordinate2D)coordinate{
    
    CLLocationCoordinate2D pt = coordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}
#pragma mark - Getter
- (NSMutableArray<BMKPoiInfo *> *)nearbylocations{
    if (!_nearbylocations) {
        _nearbylocations = @[].mutableCopy;
    }
    return _nearbylocations;
}
- (BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectZero];
        _mapView.showsUserLocation = YES;
        _mapView.layer.borderColor = [UIColor whiteColor].CGColor;
        _mapView.layer.borderWidth = .5;
        [_mapView setLogoPosition:BMKLogoPositionRightBottom];
        _mapView.showMapScaleBar = YES;
        _mapView.zoomLevel = 20;
    }
    return _mapView;
}
- (UIButton *)redPinBtn{
    if (!_redPinBtn) {
        _redPinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *redPinImg = [UIImage imageNamed:@"redPinIcon"];
        [_redPinBtn setImage:redPinImg forState:UIControlStateNormal];
        [_redPinBtn setImage:redPinImg forState:UIControlStateHighlighted];
        _redPinBtn.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
    }
    return _redPinBtn;
}

- (UIButton *)locationBtn{
    if (!_locationBtn) {
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *locationImgNor = [UIImage imageNamed:@"locationBtnIcon"];
        UIImage *locationImgSelected = [UIImage imageNamed:@"locationBtnSelectedIcon"];
        [_locationBtn setImage:locationImgNor forState:UIControlStateNormal];
        [_locationBtn setImage:locationImgSelected forState:UIControlStateSelected];
        [_locationBtn addTarget:self action:@selector(manuallocation:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _locationBtn;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:[UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1]];
        [_tableView registerNib:[UINib nibWithNibName:@"YBNeighborLocationCell" bundle:nil] forCellReuseIdentifier:kNearbylocationCellId];
        [_tableView registerNib:[UINib nibWithNibName:@"YBCurrentLocationCell" bundle:nil] forCellReuseIdentifier:kCurrentlocationCellId];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 60;
    }
    return _tableView;
}
- (UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
        _searchController.searchBar.barTintColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
        _searchController.searchBar.placeholder = @"搜索地点";
        _searchController.searchBar.subviews.firstObject.subviews.firstObject.layer.borderColor = [UIColor colorWithRed:198/255.0f green:198/255.0f blue:198/255.0f alpha:1].CGColor;
        _searchController.searchBar.subviews.firstObject.subviews.firstObject.layer.borderWidth = .5;
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
    }
    return _searchController;
}

- (YBLocationSearchResultViewController *)searchResultController{
    if (!_searchResultController) {
        _searchResultController = [[YBLocationSearchResultViewController alloc] init];
        _searchResultController.delegate = self;
    }
    return _searchResultController;
}
#pragma mark - Setter

@end

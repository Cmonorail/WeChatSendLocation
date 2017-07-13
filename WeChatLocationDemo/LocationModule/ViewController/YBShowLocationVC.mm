//
//  YBShowLocationVC.m
//  9999md-doctor
//
//  Created by 周英斌 on 2017/6/16.
//  Copyright © 2017年 ZhouYingbin. All rights reserved.
//

#import "YBShowLocationVC.h"
#import "YBShowPanoranaVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
@interface YBShowLocationVC ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKRouteSearchDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (strong, nonatomic) BMKGeoCodeSearch *geoSearcher;
@property (strong, nonatomic) BMKLocationService *locationService;
@property (strong, nonatomic) BMKRouteSearch *routeSearcher;

@property (nonatomic)CLLocationCoordinate2D coordinate;

@end

@implementation YBShowLocationVC

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView setLogoPosition:BMKLogoPositionRightBottom];
    self.mapView.showMapScaleBar = YES;
    self.mapView.mapScaleBarPosition = CGPointMake(15,CGRectGetMaxY(self.mapView.frame)-20-self.mapView.mapScaleBarSize.height);
    self.mapView.zoomLevel = 18;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = BMKUserTrackingModeHeading;
    [self.mapView setCenterCoordinate:self.coordinate animated:YES];
    
    
    self.geoSearcher = [[BMKGeoCodeSearch alloc] init];
    self.locationService = [[BMKLocationService alloc] init];
    
    [self.locationService startUserLocationService];
    self.routeSearcher = [[BMKRouteSearch alloc] init];
    self.routeSearcher.delegate = self;
    [self _reverseGeoCode];
    [self _addCurrentAnnotation]; 
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.geoSearcher.delegate = self;
    self.locationService.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.geoSearcher.delegate = nil;
    self.locationService.delegate = nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

- (IBAction)showMenuAction:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"显示路线"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self showRoute];
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"街景"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self showPanorana];
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self baiduMapNavigation];
                                }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self amapNavigation];
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"苹果地图"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self appleMapNaviagation];
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action)
                                {
                                    
                                }]];
    [self presentViewController:alertController animated:YES completion:^{}];
    
}

- (IBAction)locationAction:(UIButton *)sender {
    
    [self.mapView setCenterCoordinate:self.locationService.userLocation.location.coordinate animated:YES];
    if (!sender.isSelected) {
        sender.selected = YES;
    }
    
}
- (IBAction)squalBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private

- (void)_reverseGeoCode{
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = self.coordinate;
    BOOL flag = [self.geoSearcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)_addCurrentAnnotation{
    BMKPointAnnotation *annotation=[[BMKPointAnnotation alloc]init];
    annotation.coordinate=self.coordinate;
    [self.mapView addAnnotation:annotation];
}


#pragma mark - Target Method
- (void)showRoute{

    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = self.coordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt   = self.locationService.userLocation.location.coordinate;
    BMKDrivingRoutePlanOption *option = [[BMKDrivingRoutePlanOption alloc]init];
    option.from = start;
    option.to = end;
    
    //发起检索
    BOOL flag = [self.routeSearcher drivingSearch:option];
    if(flag) {
        NSLog(@"驾车检索发送成功");
    } else {
        NSLog(@"驾车检索发送失败");
    }
    
}

- (void)showPanorana{
    YBShowPanoranaVC *vc = [[YBShowPanoranaVC alloc] initWithlat:self.coordinate.latitude lon:self.coordinate.longitude];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)baiduMapNavigation{
    
    NSString *urlStr = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.coordinate.latitude, self.coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"需要下载百度地图" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}


- (void)amapNavigation{
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    
    NSString *urlStr = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&t=0",[appInfo objectForKey:@"CFBundleDisplayName"],self.coordinate.latitude, self.coordinate.longitude,@"目的地"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"需要下载高德地图" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

- (void)appleMapNaviagation{
    
    NSString *urlStr = [[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&saddr=Current+Location",self.coordinate.latitude, self.coordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}



#pragma mark - BMKMapViewDelegate

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id)annotation{
    
    BMKPinAnnotationView *customAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"customAnnotation"];
    customAnnotationView.animatesDrop = YES;
    customAnnotationView.annotation = annotation;
    customAnnotationView.image = [UIImage imageNamed:@"redPinIcon"];
    return customAnnotationView;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        CGFloat r = 116/255.0f;
        CGFloat g = 112/255.0f;
        CGFloat b = 246/255.0f;
        polylineView.fillColor = [[UIColor alloc] initWithRed:r green:g blue:b alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:r green:g blue:b alpha:1];
        polylineView.layer.cornerRadius = 3;
        polylineView.layer.masksToBounds = YES;
        polylineView.lineWidth = 6.0;
        return polylineView;
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    BMKMapPoint targetPoint = BMKMapPointForCoordinate(self.mapView.centerCoordinate);
    BMKMapPoint userPoint   = BMKMapPointForCoordinate(self.locationService.userLocation.location.coordinate);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(targetPoint,userPoint);
    if (distance <=100) {
        self.locationBtn.selected = YES;
    }else{
        self.locationBtn.selected = NO;
    }
}
#pragma mark - BMKRouteSearchDelegate

- (void)onGetDrivingRouteResult:(BMKRouteSearch *)searcher result:(BMKDrivingRouteResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if(error == BMK_SEARCH_NO_ERROR){
        //绘制线路
        [self.mapView removeOverlays:self.mapView.overlays];
        BMKDrivingRouteLine *plan = (BMKDrivingRouteLine *)[result.routes objectAtIndex:0];
        int size = (int)[plan.steps count];
        int pointCount = 0;
        for (int i = 0; i< size; i++) {
            BMKDrivingStep *step = [plan.steps objectAtIndex:i];
            pointCount += step.pointsCount;
        }
        BMKMapPoint *points = new BMKMapPoint[pointCount];
        int k = 0;
        for (int i = 0; i< size; i++) {
            BMKDrivingStep *step = [plan.steps objectAtIndex:i];
            for (int j= 0; j<step.pointsCount; j++) {
                points[k].x = step.points[j].x;
                points[k].y = step.points[j].y;
                k++;
            }
        }
        BMKPolyline *polyLine = [BMKPolyline polylineWithPoints:points count:pointCount];
        [self.mapView addOverlay:polyLine];

    }
}

#pragma mark -  BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [self.mapView updateLocationData:userLocation];
}

#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    self.namelabel.text = result.sematicDescription;
    self.addresslabel.text = result.address;
}
@end

//
//  MapViewController.m
//  MessageFly
//
//  Created by xll on 15/3/23.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MapViewController.h"
#import "SelectCityViewController.h"
#import "BMapKit.h"
#import "BMKPoiSearch.h"
#import "BMKSearchComponent.h"
@interface MapViewController ()<UITextFieldDelegate,CitySelectDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
{
    NSString *keyWord;
    UILabel *placeLabel;
    UITextField *textField;
    
    BMKMapView  * _mapView;
    
    BMKLocationService  *_locService;
    BOOL isFirstLoad;
    
//    BMKPointAnnotation *searchPointAnnotation;
    
    NSMutableDictionary *selInfo;
    BOOL ifLongPress;
    BMKGeoCodeSearch *longSearch;
}


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ifLongPress = YES;
    isFirstLoad = YES;
    self.title = @"长按选择地址";
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIButton *commitBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"确定" selector:@selector(commit) target:self];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commitBtn];
    [self createSearhView];
    [self createMap];
    
}
-(void)commit
{
    if (selInfo) {
        self.myLocaltionBlock(selInfo);
    }
    [self GoBack];
}
#pragma mark   createSearhView
-(void)createSearhView
{
    UIImageView *searhView = [MyControll createImageViewWithFrame:CGRectMake(10, 10, WIDTH-20, 40) imageName:@"8"];
    searhView.userInteractionEnabled = YES;
    [self.view addSubview:searhView];
    
    placeLabel = [MyControll createLabelWithFrame:CGRectMake(5, 5, 60, 30) title:@"北京市" font:14];
    placeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    placeLabel.textAlignment = NSTextAlignmentCenter;
    placeLabel.userInteractionEnabled = YES;
    [searhView addSubview:placeLabel];
    
    UIButton *placeBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:nil title:nil selector:@selector(choseCity) target:self];
    [placeLabel addSubview:placeBtn];
    
    UIImageView *arrow_xia = [MyControll createImageViewWithFrame:CGRectMake(65, 0, 12, 40) imageName:@"9"];
    arrow_xia.contentMode = UIViewContentModeScaleAspectFit;
    [searhView addSubview:arrow_xia];
    
    
    UIView *line1 = [MyControll createViewWithFrame:CGRectMake(85, 10, 1, 20)];
    line1.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    [searhView addSubview:line1];
    
    textField = [MyControll createTextFieldWithFrame:CGRectMake(90, 5, searhView.frame.size.width-90-40, 30) text:nil placehold:@"" font:13];
    textField.returnKeyType = UIReturnKeySearch;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    [searhView addSubview:textField];
    
    UIView *line2 = [MyControll createViewWithFrame:CGRectMake(searhView.frame.size.width-40, 10, 1, 20)];
    line2.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    [searhView addSubview:line2];
    
    UIButton *mapBtn = [MyControll createButtonWithFrame:CGRectMake(searhView.frame.size.width-39, 0, 38, 40) bgImageName:nil imageName:@"10" title:nil selector:@selector(showUser) target:self];
    [searhView addSubview:mapBtn];
}
-(void)showUser
{
    ifLongPress = YES;
    isFirstLoad = YES;
    [_locService stopUserLocationService];
    [_locService startUserLocationService];
}
-(void)choseCity
{
    SelectCityViewController *vc = [[SelectCityViewController alloc]init];
    vc.cDelegate = self;
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)selectCity:(NSString *)cityName ID:(NSString *)id
{
    placeLabel.text = cityName;
    if([cityName isEqualToString:@"#全部省份"])
    {
        placeLabel.text = @"全国";
    }
    else
    {
        placeLabel.text = cityName;
    }
    textField.text = @"";
     [self gotoCheckCity];
}
-(void)gotoCheckCity
{
    if (![placeLabel.text isEqualToString:@"全国"]) {
        BMKGeoCodeSearch *searcher =[[BMKGeoCodeSearch alloc]init];
        searcher.delegate = self;
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geoCodeSearchOption.city = placeLabel.text;
        geoCodeSearchOption.address = placeLabel.text;
        BOOL flag = [searcher geoCode:geoCodeSearchOption];
        if(flag)
        {
            NSLog(@"geo检索发送成功");
        }
        else
        {
            NSLog(@"geo检索发送失败");
        }
    }
    else
    {
        [_locService stopUserLocationService];
        [_locService startUserLocationService];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self mapClick];
    [self.view endEditing:YES];
    return YES;
}
-(void)mapClick
{
    [self.view endEditing:YES];
    //逆地理编码
    if ([textField.text isEqualToString:@""]) {
        [self showMsg:@"输入框不能为空"];
        return;
    }
    
    //初始化检索对象
    BMKGeoCodeSearch *searcher =[[BMKGeoCodeSearch alloc]init];
    searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= placeLabel.text;
    geoCodeSearchOption.address = textField.text;
    BOOL flag = [searcher geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}
-(void)createMap
{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,60,WIDTH, HEIGHT-60-64)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.showMapScaleBar = YES;
    _mapView.zoomLevel = 13;
    [self.view addSubview:_mapView];
    
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:0.1f];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService stopUserLocationService];
    [_locService startUserLocationService];

}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [_locService stopUserLocationService];
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (!searcher.delegate) {
        return;
    }
    if (error == 0) {
//         searchPointAnnotation.title = result.address;
            if (longSearch == searcher) {
                textField.text = result.address;
                placeLabel.text = result.addressDetail.city;
                selInfo =[NSMutableDictionary dictionaryWithCapacity:0];
                [selInfo setObject:textField.text forKey:@"placename"];
                [selInfo setObject:[NSString stringWithFormat:@"%f",result.location.latitude] forKey:@"lat"];
                [selInfo setObject:[NSString stringWithFormat:@"%f",result.location.longitude] forKey:@"lng"];
                [selInfo setObject:placeLabel.text forKey:@"cityname"];
                [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
            }
            else
            {
                if (ifLongPress) {
                    textField.text = result.address;
                    placeLabel.text = result.addressDetail.city;
                    selInfo =[NSMutableDictionary dictionaryWithCapacity:0];
                    [selInfo setObject:textField.text forKey:@"placename"];
                    [selInfo setObject:[NSString stringWithFormat:@"%f",result.location.latitude] forKey:@"lat"];
                    [selInfo setObject:[NSString stringWithFormat:@"%f",result.location.longitude] forKey:@"lng"];
                    [selInfo setObject:placeLabel.text forKey:@"cityname"];
                    [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
                }
                else
                {
                     placeLabel.text = result.addressDetail.city;
                }
            }
        }
}
-(void)delay
{
    ifLongPress = NO;
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
       [_mapView setCenterCoordinate:result.location animated:YES];
        
//        searchPointAnnotation.coordinate = result.location;
//        searchPointAnnotation.title = result.address;
        selInfo =[NSMutableDictionary dictionaryWithCapacity:0];
        [selInfo setObject:result.address forKey:@"placename"];
        [selInfo setObject:[NSString stringWithFormat:@"%f",result.location.latitude] forKey:@"lat"];
        [selInfo setObject:[NSString stringWithFormat:@"%f",result.location.longitude] forKey:@"lng"];
        [selInfo setObject:placeLabel.text forKey:@"cityname"];

    }
    else
    {
        [self showMsg:[NSString stringWithFormat:@"在%@没有叫%@的地方",placeLabel.text,textField.text]];
    }
}
#pragma mark 选择某个网点的响应
-(void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    ifLongPress = YES;
    [_mapView removeAnnotations:_mapView.annotations];
    BMKPointAnnotation * searchPointAnnotation = [[BMKPointAnnotation alloc]init];
    [_mapView addAnnotation:searchPointAnnotation];
    searchPointAnnotation.coordinate = coordinate;
    if (!longSearch) {
        longSearch = [[BMKGeoCodeSearch alloc]init];
         longSearch.delegate=self;
    }
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = coordinate;
    [longSearch reverseGeoCode:rever];
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
        BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc]init];
        search.delegate=self;
        BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
        rever.reverseGeoPoint = mapView.centerCoordinate;
        [search reverseGeoCode:rever];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    //如果annotation为用户自身位置的小蓝点  就什么都不做
    
    if ([annotation isKindOfClass:[BMKUserLocation class]]) {
        
        return nil;
        
    }
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        
        newAnnotationView.annotation=annotation;
        
        newAnnotationView.image = [UIImage imageNamed:@"green@2x"];   //把大头针换成别的图片
        
        return newAnnotationView;
        
    }
    return nil;
}
-(void)dealloc
{
    longSearch.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

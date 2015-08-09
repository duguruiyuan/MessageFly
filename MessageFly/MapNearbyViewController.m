//
//  MapNearbyViewController.m
//  MessageFly
//
//  Created by xll on 15/4/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MapNearbyViewController.h"
#import "SelectCityViewController.h"
#import "BMapKit.h"
#import "BMKSearchComponent.h"
#import "MyAnnotationView.h"
@interface MapNearbyViewController ()<UITextFieldDelegate,CitySelectDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
{
    NSString *keyWord;
    UILabel *placeLabel;
    UITextField *textField;
    
    BMKMapView  * _mapView;
    
    BMKLocationService  *_locService;
    
    BOOL _isSetMapSpan;
    
    NSString *slat;
    NSString *slng;
    NSString *city;
    
    NSString *order;
    BOOL ifLoad;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation MapNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ifLoad = YES;
    city = @"0";
    order = @"2";
    _isSetMapSpan = NO;
    self.title = @"附近";
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"santiaogang" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

    [self createSearhView];
    [self createMap];
    
}
-(void)GoBack
{
    [_mapView removeAnnotations:_mapView.annotations];
    [super GoBack];
}
#pragma mark   createSearhView
-(void)createSearhView
{
    UIImageView *searhView = [MyControll createImageViewWithFrame:CGRectMake(10, 10, WIDTH-20, 40) imageName:@"8"];
    searhView.userInteractionEnabled = YES;
    [self.view addSubview:searhView];
    
    placeLabel = [MyControll createLabelWithFrame:CGRectMake(5, 5, 60, 30) title:@"北京" font:14];
    if (_selectCity) {
        placeLabel.text=_selectCity;
        city = _cityId;
    }
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
    if (_selectPlace) {
        textField.text = _selectPlace;
    }
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
    textField.text = @"";
    slat = @"";
    slng = @"";
    keyWord = @"";
    [_locService stopUserLocationService];
    [_locService startUserLocationService];
}
-(void)choseCity
{
    SelectCityViewController *vc = [[SelectCityViewController alloc]init];
    vc.cDelegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)selectCity:(NSString *)cityName ID:(NSString *)id
{
    city = id;
    if([cityName isEqualToString:@"#全部省份"])
    {
        placeLabel.text = @"全国";
    }
    else
    {
        placeLabel.text = cityName;
    }
    textField.text = @"";
    
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
    //初始化检索对象
    
    BMKGeoCodeSearch *searcher =[[BMKGeoCodeSearch alloc]init];
    searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    if ([placeLabel.text isEqualToString:@"全国"]) {
        if (textField.text.length == 0) {
            slat = @"";
            slng = @"";
            [_locService stopUserLocationService];
            [_locService startUserLocationService];
        }
        else
        {
            geoCodeSearchOption.address = textField.text;
            geoCodeSearchOption.city = @"";
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
    }
    else
    {
        if (textField.text.length == 0) {
            geoCodeSearchOption.address = placeLabel.text;
            geoCodeSearchOption.city= placeLabel.text;
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
            geoCodeSearchOption.address = textField.text;
            geoCodeSearchOption.city= placeLabel.text;
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
    }

}
-(void)createMap
{
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0,60,WIDTH, HEIGHT-60-64-49)];
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
    ifLoad = NO;
    [self gotoCheckCity];
    for (int i = 0; i<self.dataArray.count; i++) {
        NSDictionary *dic = self.dataArray[i];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"lat"] floatValue], [dic[@"lng"] floatValue]);
        BMKPointAnnotation *  searchPointAnnotation = [[BMKPointAnnotation alloc]init];
        searchPointAnnotation.coordinate = coordinate;
        searchPointAnnotation.title = [NSString stringWithFormat:@"%d",i];
        [_mapView addAnnotation:searchPointAnnotation];

    }
}
-(void)gotoCheckCity
{
    if (![placeLabel.text isEqualToString:@"全国"]) {
        BMKGeoCodeSearch *searcher =[[BMKGeoCodeSearch alloc]init];
        searcher.delegate = self;
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geoCodeSearchOption.city = placeLabel.text;
        if (_selectPlace) {
            geoCodeSearchOption.address = _selectPlace;
        }
        else
        {
           geoCodeSearchOption.address = placeLabel.text;
        }
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

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{

}
-(void)didFailToLocateUserWithError
{
    
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    [_mapView updateLocationData:userLocation];
    BMKCoordinateRegion region = BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(0.5, 0.5));
    [_mapView setRegion:region];
    //    物理地址
    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc]init];
    search.delegate=self;
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    rever.reverseGeoPoint = userLocation.location.coordinate;
    [search reverseGeoCode:rever];
    [_locService stopUserLocationService];
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKCoordinateRegion region = BMKCoordinateRegionMake(result.location, BMKCoordinateSpanMake(0.5, 0.5));
        [_mapView setRegion:region];
        textField.text = result.address;
    }
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKCoordinateRegion region = BMKCoordinateRegionMake(result.location, BMKCoordinateSpanMake(0.5, 0.5));
        [_mapView setRegion:region];
        keyWord = @"";
        slat = [NSString stringWithFormat:@"%f",result.location.latitude];
        slng = [NSString stringWithFormat:@"%f",result.location.longitude];
        if (ifLoad) {
            [self loadData];
        }
        else
        {
            ifLoad = YES;
        }
    }
    else
    {
        keyWord = textField.text;
        slat = @"";
        slng = @"";
        [self loadData];
    }
}

#pragma mark 选择某个网点的响应
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    //    textField.text =searchPointAnnotation.title;
    
}
-(void)loadData
{
    [self StartLoading];
    NSString *str = [keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@indexlist?uid=%@&token=%@&pro=%@&city=%@&order=%@&where=%@&lat=%@&lng=%@&limit=50&page=%d&dlat=%@&dlng=%@",SERVER_URL,@"",@"",@"",city,@"2",str,_uLat,_uLng,1,slat,slng];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf endSomething];
            
            if (data && data.length>0) {
                id jsonStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([jsonStr isKindOfClass:[NSArray class]]) {
                    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if (array&&array.count>0) {
                        [weakSelf.dataArray removeAllObjects];
                        [weakSelf.dataArray addObjectsFromArray:array];
                        [weakSelf addAnnotation];
                    }
                }
                else
                {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [weakSelf showMsg:dict[@"message"]];
                }
            }
        }
        else
        {
            [weakSelf endSomething];
            [weakSelf showMsg:@"请检查你的网络"];
        }
    }];
}
-(void)endSomething
{
    [self StopLoading];
}
-(void)addAnnotation
{
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (int i = 0; i<self.dataArray.count; i++) {
        NSDictionary *dic = self.dataArray[i];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dic[@"lat"] floatValue], [dic[@"lng"] floatValue]);
        BMKPointAnnotation *  searchPointAnnotation = [[BMKPointAnnotation alloc]init];
        searchPointAnnotation.coordinate = coordinate;
        searchPointAnnotation.title = [NSString stringWithFormat:@"%d",i];
        [_mapView addAnnotation:searchPointAnnotation];
        
    }
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
    [_locService stopUserLocationService];
    _mapView.delegate = nil; // 不用时，置nil
    
}


- (BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    //如果annotation为用户自身位置的小蓝点  就什么都不做
    
    if ([annotation isKindOfClass:[BMKUserLocation class]]) {
        
        return nil;
        
    }
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        MyAnnotationView *  newAnnotationView = [[MyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        int a = [[annotation title] intValue];
        NSDictionary *dic = self.dataArray[a];
        [newAnnotationView config:dic];
        newAnnotationView.delegate = self;
        
        if ([dic[@"state"] isEqualToString:@"0"]) {
            newAnnotationView.image = [UIImage imageNamed:@"green@2x"];
        }
        else if ([dic[@"state"] isEqualToString:@"1"])
        {
            newAnnotationView.image = [UIImage imageNamed:@"huang@2x"];
        }
        else if ([dic[@"state"] isEqualToString:@"2"])
        {
            newAnnotationView.image = [UIImage imageNamed:@"red@2x"];
        }
        else if ([dic[@"state"] isEqualToString:@"3"])
        {
            newAnnotationView.image = [UIImage imageNamed:@"hui@2x"];
        }
        return newAnnotationView;
        
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{

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

//
//  MyLocaltion.m
//  MessageFly
//
//  Created by xll on 15/3/31.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MyLocaltion.h"
static MyLocaltion *DefaultManager = nil;

@interface MyLocaltion()

-(void)initiate;

@end
@implementation MyLocaltion
+(id)getSharedInstance{
    if (!DefaultManager) {
        DefaultManager = [[self allocWithZone:NULL]init];
        [DefaultManager initiate];
    }
    return DefaultManager;
}
-(void)initiate{
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:0.1f];
    locationManager = [[BMKLocationService alloc]init];
    locationManager.delegate = self;
    //初始化检索对象
    searcher =[[BMKGeoCodeSearch alloc]init];
    searcher.delegate = self;
    
}

-(void)startUpdating{
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
//    {
//        //设置定位权限 仅ios8有意义
////        [locationManager requestWhenInUseAuthorization];// 前台定位
//        
//          [locationManager requestAlwaysAuthorization];// 前后台同时定位
//    }
//    else
//    {
//
//    }
    [locationManager startUserLocationService];
}

-(void) stopUpdating{
    [locationManager stopUserLocationService];
}
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if ([self.delegate respondsToSelector:@selector
         (didUpdateToLocation:fromLocation:)])
    {
        [self.delegate didUpdateToLocation:userLocation.location
                              fromLocation:userLocation.location];
        
    }
}
- (void)didFailToLocateUserWithError:(NSError *)error
{
     [self.delegate didFailWithError:error];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:
(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if ([self.delegate respondsToSelector:@selector
         (didUpdateToLocation:fromLocation:)])
    {
        [self.delegate didUpdateToLocation:oldLocation
                              fromLocation:newLocation];
        
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.delegate didFailWithError:error];
}
#pragma mark  获取经纬度
-(void)getLatLng:(NSString *)str inCity:(NSString *)city
{
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.city= city;
    geoCodeSearchOption.address = str;
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
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        if ([self.delegate respondsToSelector:@selector
             (didGetLatAndLng:Lng:)])
        {
            [self.delegate didGetLatAndLng:[NSString stringWithFormat:@"%f",result.location.latitude] Lng:[NSString stringWithFormat:@"%f",result.location.longitude]];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didFailGet)]) {
             [self.delegate didFailGet];
        }
    }
}
@end

//
//  MyLocaltion.h
//  MessageFly
//
//  Created by xll on 15/3/31.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

#import "BMapKit.h"
#import "BMKSearchComponent.h"
@protocol LocationHandlerDelegate <NSObject>

@required
-(void) didUpdateToLocation:(CLLocation*)newLocation
               fromLocation:(CLLocation*)oldLocation;
- (void)didFailWithError:(NSError *)error;

-(void)didGetLatAndLng:(NSString *)slat Lng:(NSString *)slng;
-(void)didFailGet;
@end
@interface MyLocaltion : NSObject<CLLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
{
    BMKLocationService *locationManager;
    BMKGeoCodeSearch *searcher;
}
@property(nonatomic,strong) id<LocationHandlerDelegate> delegate;

+(id)getSharedInstance;
-(void)startUpdating;
-(void) stopUpdating;
-(void)getLatLng:(NSString *)str inCity:(NSString *)city;
@end

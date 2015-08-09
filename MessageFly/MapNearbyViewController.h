//
//  MapNearbyViewController.h
//  MessageFly
//
//  Created by xll on 15/4/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADViewController.h"

@interface MapNearbyViewController : BaseADViewController
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *selectPlace;
@property(nonatomic,strong)NSString *selectCity;
@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,strong)NSString *uLat;
@property(nonatomic,strong)NSString *uLng;
@end

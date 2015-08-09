//
//  MapViewController.h
//  MessageFly
//
//  Created by xll on 15/3/23.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADViewController.h"


@interface MapViewController : BaseADViewController
@property(nonatomic,copy)void(^myLocaltionBlock)(NSDictionary *dic);
@end

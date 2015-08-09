//
//  SubOrderViewController.h
//  MessageFly
//
//  Created by xll on 15/4/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADViewController.h"

@interface SubOrderViewController : BaseADViewController
@property(nonatomic)int type;
@property(nonatomic)int state;
-(void)controllerRefresh;
@end

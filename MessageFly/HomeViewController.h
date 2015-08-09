//
//  HomeViewController.h
//  MessageFly
//
//  Created by xll on 15/2/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectTabBar.h"
#import "NearbyViewController.h"
#import "OrderViewController.h"
#import "PressViewController.h"
#import "SpreadViewController.h"
#import "MyViewController.h"
#import "NavRootViewController.h"
@interface HomeViewController : UITabBarController<SelectTabBarDelegate,UIAlertViewDelegate>
{
    NSArray *array;
}
@property(nonatomic)SelectTabBar *  mTabView;

@property(nonatomic,strong)NSDictionary *notificationDic;
-(void)dealNotificationDic;
-(void)dealNotificationDicActive;;
@end

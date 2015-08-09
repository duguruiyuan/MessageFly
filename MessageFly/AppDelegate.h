//
//  AppDelegate.h
//  MessageFly
//
//  Created by xll on 15/2/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "HomeViewController.h"
#import "WXApi.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    UIImageView *mLoadView;
    BMKMapManager* _mapManager;
     BOOL isActive;
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)HomeViewController *homeVC;
-(void)registPush:(NSDictionary *)launchOptions;
@property(nonatomic,strong)NSDictionary *launchDic;


//- (void)sendPay:(NSDictionary *)dict;
@end


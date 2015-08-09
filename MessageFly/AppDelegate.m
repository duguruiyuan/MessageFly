//
//  AppDelegate.m
//  MessageFly
//
//  Created by xll on 15/2/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"

#import "WXApi.h"

#import <AlipaySDK/AlipaySDK.h>
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize homeVC,launchDic;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"KsH04bjF05RVcwer6WKnpphF"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
   
    
    
    homeVC  = [[HomeViewController alloc]init];
    isActive = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
     sleep(2);
    self.window.rootViewController =homeVC;
    
    //微信支付
    [WXApi registerApp:WX_AppId withDescription:@"MessageFly"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendPay:) name:wx_sendPay object:nil];
    //
    
    //*********************友盟分享***************
    
    [UMSocialData setAppKey:@"552f8da3fd98c5834c000d63"];
    [UMSocialData openLog:YES];
    
    
    [UMSocialWechatHandler setWXAppId:WX_AppId appSecret:@"4c57c9af3f2d5e8132cd033919db3a74" url:@"http://202.85.214.88/xiner/down.html"];
    
    [UMSocialQQHandler setQQWithAppId:@"1104471623" appKey:@"d8WyDBasWqs0RERC" url:@"http://202.85.214.88/xiner/down.html"];
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    //********************************************
    
    
    //*********************极光推送*******************************************
    launchDic = [NSDictionary dictionaryWithDictionary:launchOptions];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ifMessage =[user objectForKey:@"messagestate"];
    if (ifMessage&&[ifMessage isEqualToString:@"0"]) {
        
    }
    else
    {
        [self registPush:launchDic];
    }
    //*********************极光推送*******************************************
    
    
    
    return YES;
  
}
-(void)registPush:(NSDictionary *)launchOptions
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [APService setupWithOption:launchOptions];

}
#pragma mark  JPush
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
    NSString *deviceTokenStr =[APService registrationID];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:deviceTokenStr forKey:@"deviceToken"];
    [user synchronize];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]!=NULL) {
        homeVC.notificationDic = [NSDictionary dictionaryWithDictionary:userInfo];
        if (isActive) {
            [homeVC dealNotificationDicActive];
        }
        else
        {
            [homeVC performSelector:@selector(dealNotificationDic) withObject:nil afterDelay:1];
        }
        
    }
    else {
        //第三种情况
        //这里定义自己的处理方式
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
      [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    isActive = NO;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    isActive = YES;
    application.applicationIconBadgeNumber = 0;
    [APService setBadge:0];
     [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
    [UMSocialSnsService  applicationDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark  友盟系统回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"-------------UMSocialSnsService------");
    if ([UMSocialSnsService handleOpenURL:url]) {
        return [UMSocialSnsService handleOpenURL:url];
    }
    else{
        return [WXApi handleOpenURL:url delegate:self];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                  }]; }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    NSLog(@"-------------UMSocialSnsService------");
    if ([UMSocialSnsService handleOpenURL:url]) {
        return [UMSocialSnsService handleOpenURL:url];
    }
    else{
        return [WXApi handleOpenURL:url delegate:self];
    }
}
#pragma mark  微信支付
- (void)sendPay:(NSNotification *)noti {
    /*
     {"response":{"flag":"0", "tip":"微信支付下单成功"}, "bizData":{"timestamp":1427188856,"sign":"4AA0208E5F34A7DFAC87E7941ABF0E5E","partnerid":"1232401402","noncestr":"CqHyPCXrdZsTLfT2","prepayid":"wx201503241720582f8b7ca5650379195396","package":"Sign=WXPay","appid":"wx9c564fd34737b05e"}}
     */
    NSDictionary *dict = noti.object;
    PayReq *request = [[PayReq alloc] init];
    request.openID = WX_AppId;
    request.partnerId = dict[@"partnerid"];
    request.prepayId= dict[@"prepayid"];
    request.package = dict[@"package"];
    request.nonceStr= dict[@"noncestr"];
    request.timeStamp = [dict[@"timestamp"] intValue];
    request.sign= dict[@"sign"];
    [WXApi sendReq:request];
}
- (void)onResp:(BaseResp *)resp {
    NSLog(@"resp-----》%d\n----->%@",resp.errCode,resp.errStr);
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:wx_PayFinish object:nil];
                break;
            default:
                NSLog(@"支付失败， retcode=%d   %@",resp.errCode,resp.errStr);
                break;
        }
    }
}
@end

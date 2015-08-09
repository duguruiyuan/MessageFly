//
//  HomeViewController.m
//  MessageFly
//
//  Created by xll on 15/2/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "HomeViewController.h"
#import "NavRootViewController.h"
#import "OrderDetailOnViewController.h"
#import "OrderDetailOnForSearchViewController.h"
#import "NearbyDetailNotViewController.h"
#import "SearchPeopleViewController.h"
#import "ReplyInfoViewController.h"
#import "OrderDetailDidViewController.h"
#import "OrderDetailDidForSearchViewController.h"
#import "MyMessageViewController.h"
@interface HomeViewController ()
{
     BOOL isBusy;
}
@end

@implementation HomeViewController
@synthesize mTabView,notificationDic;
//@synthesize nearVC,orderVC,pressVC,spreadVC,myVC;
- (void)viewDidLoad {
    [super viewDidLoad];
    isBusy = NO;
    NearbyViewController*nearVC = [[NearbyViewController alloc]init];
   OrderViewController * orderVC = [[OrderViewController alloc]init];
   PressViewController * pressVC = [[PressViewController alloc]init];
   SpreadViewController * spreadVC = [[SpreadViewController alloc]init];
   MyViewController * myVC = [[MyViewController alloc]init];
    NavRootViewController *nav1 = [[NavRootViewController alloc]initWithRootViewController:nearVC];
    NavRootViewController *nav2 = [[NavRootViewController alloc]initWithRootViewController:orderVC];
    NavRootViewController *nav3 = [[NavRootViewController alloc]initWithRootViewController:pressVC];
    NavRootViewController *nav4 = [[NavRootViewController alloc]initWithRootViewController:spreadVC];
    NavRootViewController *nav5 = [[NavRootViewController alloc]initWithRootViewController:myVC];
    
    array = @[nav1,nav2,nav3,nav4,nav5];
    self.viewControllers = array;
    self.selectedIndex = 0;
//
    
    mTabView = [[SelectTabBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    mTabView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    mTabView.delegate = self;
    [self.tabBar addSubview:mTabView];
    
    [self OnTabSelect:mTabView];
}
- (void)OnTabSelect:(SelectTabBar *)sender {
    int index = sender.miIndex;
    NSLog(@"OnTabSelect:%d", index);
    self.selectedIndex = index;
    [self.tabBar bringSubviewToFront:mTabView];
    
}
-(BOOL)CanSelectTab:(SelectTabBar *)sender :(int)index
{
    return YES;
}
#pragma mark   推送处理
-(void)dealNotificationDic
{
    NSLog(@"dealNotificationDic");
    int tabSelectIndex =(int)self.selectedIndex;
    NavRootViewController *navRootVC = (NavRootViewController *)array[tabSelectIndex];
    UIViewController *topCtrl = navRootVC.topViewController;
    if ([[notificationDic[@"style"] stringValue] isEqualToString:@"1"]) {
        if ([notificationDic[@"type"] isEqualToString:@"1"]) {
            NearbyDetailNotViewController *vc = [[NearbyDetailNotViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.detaiID = notificationDic[@"targetid"];
            [topCtrl.navigationController pushViewController:vc animated:YES];
        }
        else if ([notificationDic[@"type"] isEqualToString:@"2"])
        {
            UIStoryboard *mainstory =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SearchPeopleViewController *vc = [mainstory instantiateViewControllerWithIdentifier:@"SearchPeopleViewController"];
            vc.detaiID = notificationDic[@"targetid"];
            vc.hidesBottomBarWhenPushed = YES;
            [topCtrl.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([[notificationDic[@"style"] stringValue] isEqualToString:@"2"])
    {
         if ([notificationDic[@"type"] isEqualToString:@"1"])
             {
                 OrderDetailOnViewController *vc = [[OrderDetailOnViewController alloc]init];
                 vc.tid = notificationDic[@"targetid"];
                 vc.hidesBottomBarWhenPushed = YES;
                 [topCtrl.navigationController pushViewController:vc animated:YES];
             }
        else if ([notificationDic[@"type"] isEqualToString:@"2"])
        {
            OrderDetailOnForSearchViewController *vc = [[OrderDetailOnForSearchViewController alloc]init];
            vc.tid = notificationDic[@"targetid"];
            vc.hidesBottomBarWhenPushed = YES;
            [topCtrl.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([[notificationDic[@"style"] stringValue] isEqualToString:@"3"])
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uid = [user objectForKey:@"uid"];
        if ([uid isEqualToString:notificationDic[@"uid"]]) {
            ReplyInfoViewController *vc = [[ReplyInfoViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = notificationDic[@"tid"];
            vc.detailId = notificationDic[@"targetid"];
            vc.ifBottom = 1;
            [topCtrl.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            if ([notificationDic[@"type"] isEqualToString:@"1"]) {
                OrderDetailDidViewController *vc = [[OrderDetailDidViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.tid = notificationDic[@"targetid"];
                vc.type = 1;
                [topCtrl.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                OrderDetailDidForSearchViewController *vc = [[OrderDetailDidForSearchViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.tid = notificationDic[@"targetid"];
                vc.type = 1;
                [topCtrl.navigationController pushViewController:vc animated:YES];
                
            }
        }
    }
    else if ([[notificationDic[@"style"] stringValue] isEqualToString:@"4"]||[[notificationDic[@"style"] stringValue] isEqualToString:@"5"])
    {
        if ([notificationDic[@"type"] isEqualToString:@"1"]) {
            OrderDetailDidViewController *vc = [[OrderDetailDidViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = notificationDic[@"targetid"];
            [topCtrl.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            OrderDetailDidForSearchViewController *vc = [[OrderDetailDidForSearchViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = notificationDic[@"targetid"];
            [topCtrl.navigationController pushViewController:vc animated:YES];
        }

    }
    else if ([[notificationDic[@"style"] stringValue] isEqualToString:@"7"]||[[notificationDic[@"style"] stringValue] isEqualToString:@"10"])
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"1" forKey:@"ifHaveMessage"];
        [user synchronize];
        MyMessageViewController *vc = [[MyMessageViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [topCtrl.navigationController pushViewController:vc animated:YES];
    }
    else if ([[notificationDic[@"style"] stringValue] isEqualToString:@"8"])
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"1" forKey:@"ifHaveMessage"];
        [user setObject:@"2" forKey:@"flag"];
        [user synchronize];
    }
    else if ([[notificationDic[@"style"] stringValue] isEqualToString:@"9"])
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"1" forKey:@"ifHaveMessage"];
        [user setObject:@"3" forKey:@"flag"];
        [user synchronize];
    }
}
-(void)dealNotificationDicActive
{
    if ([[notificationDic[@"style"] stringValue] isEqualToString:@"7"]||[[notificationDic[@"style"] stringValue] isEqualToString:@"8"]||[[notificationDic[@"style"] stringValue] isEqualToString:@"9"])
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@"1" forKey:@"ifHaveMessage"];
        [user synchronize];
    }
    if (isBusy) {
        return;
    }
    isBusy = YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收到新的推送，是否去查看" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     isBusy = NO;
    if (buttonIndex == 1) {
        [self dealNotificationDic];
    }
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

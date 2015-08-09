//
//  OrderViewController.m
//  MessageFly
//
//  Created by xll on 15/2/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "OrderViewController.h"
#import "MyPressViewController.h"
#import "MyQIanDanViewController.h"
#import "LoginViewController.h"
@interface OrderViewController ()<UIAlertViewDelegate>
{
    UIView *orderLeftView;
    UIView *ordeRightView;
    UIImageView *biaosiView;
}
@end

@implementation OrderViewController


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        [self gotoLogin];
    }
}
-(void)gotoLogin
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你还没有登录，是否登录？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 301;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 301) {
        if (buttonIndex == 1) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user removeObjectForKey:@"uid"];
            [user removeObjectForKey:@"token"];
            [user removeObjectForKey:@"flag"];
            [user synchronize];
            LoginViewController *vc = [[LoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:@[@"我的发布",@"我的抢单"]];
    seg.tintColor = [UIColor whiteColor];
    seg.frame = CGRectMake(0, 0, 160, 35);
    seg.selectedSegmentIndex = 0;
    [seg setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]} forState:UIControlStateNormal];
    [seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    
    biaosiView = [MyControll createImageViewWithFrame:CGRectMake((90-10)/2, 35, 10, 5) imageName:@"biaosi"];
    biaosiView.contentMode = UIViewContentModeScaleAspectFit;
    [seg addSubview:biaosiView];
    
    [self makeUI];
    
    // Do any additional setup after loading the view.
}
-(void)segClick:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        orderLeftView.hidden = NO;
        ordeRightView.hidden = YES;
        biaosiView.frame = CGRectMake((90-10)/2, 35, 10, 5);
    }
    else if (sender.selectedSegmentIndex == 1)
    {
        orderLeftView.hidden = YES;
        ordeRightView.hidden = NO;
        biaosiView.frame = CGRectMake(160-(80-10)/2, 35, 10, 5);
    }
}
-(void)makeUI
{
    orderLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-50-40)];
    orderLeftView.hidden = NO;
    [self.view addSubview:orderLeftView];
    MyPressViewController * orderLeftVC = [[MyPressViewController alloc]init];
    orderLeftVC.delegate = self;
    [orderLeftVC makeUI];
    [self addChildViewController:orderLeftVC];
    CGRect rect = orderLeftVC.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = WIDTH;
    rect.size.height =HEIGHT-64-50-40;
    orderLeftVC.view.frame = rect;
    [orderLeftView addSubview:orderLeftVC.view];
    if (!ordeRightView) {
        ordeRightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-50-40)];
        ordeRightView.hidden = YES;
        [self.view addSubview:ordeRightView];
        
        MyQIanDanViewController * orderRightVC = [[MyQIanDanViewController alloc]init];
        orderRightVC.delegate = self;
        [orderRightVC makeUI];
        [self addChildViewController:orderRightVC];
        CGRect rect1 = orderRightVC.view.frame;
        rect1.origin.x = 0;
        rect1.origin.y = 0;
        rect1.size.width = WIDTH;
        rect1.size.height =HEIGHT-64-50-40;
        orderRightVC.view.frame = rect1;
        [ordeRightView addSubview:orderRightVC.view];
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

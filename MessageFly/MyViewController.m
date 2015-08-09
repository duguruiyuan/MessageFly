//
//  MyViewController.m
//  MessageFly
//
//  Created by xll on 15/2/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MyViewController.h"
#import "SelfInfoViewController.h"
#import "MyAccountViewController.h"
#import "MyMessageViewController.h"
#import "MyProfitViewController.h"
#import "SelfHonestViewController.h"
#import "RealNameViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
@interface MyViewController ()<UIAlertViewDelegate>
{
    UIScrollView *mainSC;
    UIView *firstView;
    UILabel *nameLabel;
    UIButton *headView;
    UIButton *loginOutBtn;
    UIImageView *messagePoint;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@end

@implementation MyViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *ifShow = [user objectForKey:@"ifHaveMessage"];
    if ([ifShow isEqualToString:@"1"]) {
        messagePoint.hidden = NO;
    }
    else
    {
        messagePoint.hidden = YES;
    }
    if (!uid||!token) {
        [self.dataDic removeAllObjects];
        [self refreshUI];
    }
}
-(void)gotoLogin
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你还没有登录，是否登录？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = 301;
    [alert show];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"我的" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *setBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"m9" title:nil selector:@selector(settingClick) target:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setBtn];
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    [self makeUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:CHANGEUSER object:nil];
    // Do any additional setup after loading the view.
}
-(void)settingClick
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        [self gotoLogin];
        return;
    }
    SettingViewController *vc = [[SettingViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 500);
    [self.view addSubview:mainSC];
    firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, WIDTH, 90)];
    firstView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:firstView];
    
    headView = [MyControll createButtonWithFrame:CGRectMake(30, 10, 70, 70) bgImageName:@"touxiang" imageName:nil title:nil selector:@selector(checkInfoCLick) target:self];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 35;
    [firstView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(130, 10, WIDTH-130, 25) title:@"前往登录" font:20];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    [firstView addSubview:nameLabel];
    
    UILabel *fdStarLabel = [MyControll createLabelWithFrame:CGRectMake(130, 35, 70, 20) title:@"发单诚信" font:14];
    fdStarLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:fdStarLabel];
    UILabel *jdStarLabel = [MyControll createLabelWithFrame:CGRectMake(130, 55, 70, 20) title:@"接单诚信" font:14];
    jdStarLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:jdStarLabel];
    
    
    UIImageView *arrow =[MyControll createImageViewWithFrame:CGRectMake(WIDTH-27, 0, 10, 90) imageName:@"m3@2x"];
    arrow.contentMode = UIViewContentModeScaleAspectFit;
    [firstView addSubview:arrow];
    
    for (int i= 0; i<5; i++) {
        UIImageView *star = [MyControll createImageViewWithFrame:CGRectMake(200+18*i, 35, 16, 20) imageName:@"m16@2x_16"];
        star.tag =80000+i;
        star.contentMode = UIViewContentModeScaleAspectFit;
        [firstView addSubview:star];
        UIImageView *star1 = [MyControll createImageViewWithFrame:CGRectMake(200+18*i, 55, 16, 20) imageName:@"m16@2x_16"];
        star1.contentMode = UIViewContentModeScaleAspectFit;
        star1.tag=90000+i;
        [firstView addSubview:star1];
    }
    
    
    UIButton *checkSelfInfoBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH, 90) bgImageName:nil imageName:nil title:nil selector:@selector(checkInfoCLick) target:self];
    [firstView addSubview:checkSelfInfoBtn];
    
    
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, WIDTH, 150)];
    secView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:secView];
    
    NSArray *iconArray = @[@"m4@2x",@"m5@2x",@"m6@2x"];
    NSArray *titleArray = @[@"我的账户",@"我的消息",@"我的收益"];
    
    for (int i = 0; i<3; i++) {
        UIImageView *iconImageView = [MyControll createImageViewWithFrame:CGRectMake(20, i*50, 20, 50) imageName:iconArray[i]];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [secView addSubview:iconImageView];
        
        UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(55, i*50, WIDTH-55-40, 50) title:titleArray[i] font:16];
        [secView addSubview:titleLabel];
        
        UIImageView *arrow =[MyControll createImageViewWithFrame:CGRectMake(WIDTH-27, i*50, 10, 50) imageName:@"m3@2x"];
        arrow.contentMode = UIViewContentModeScaleAspectFit;
        [secView addSubview:arrow];
        if (i!=0) {
            UIView *line = [MyControll createViewWithFrame:CGRectMake(20, i*50, WIDTH-20, 0.5)];
            line.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
            [secView addSubview:line];
        }
        
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, i*50, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(firstViewClick:) target:self];
        btn.tag = 100+i;
        [secView addSubview:btn];
    }
    
    messagePoint = [MyControll createImageViewWithFrame:CGRectMake(WIDTH-50, 50, 10, 50) imageName:@"m19@2x"];
    messagePoint.contentMode = UIViewContentModeScaleAspectFit;
    messagePoint.hidden = YES;
    [secView addSubview:messagePoint];
    
    UIView *thirdView =[MyControll createViewWithFrame:CGRectMake(0, 285, WIDTH, 100)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:thirdView];
    
    NSArray *iconArray2 = @[@"m7@2x",@"m8@2x"];
    NSArray *titleArray2 = @[@"个人诚信",@"实名认证"];
    
    for (int i = 0; i<2; i++) {
        UIImageView *iconImageView = [MyControll createImageViewWithFrame:CGRectMake(20, i*50, 20, 50) imageName:iconArray2[i]];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [thirdView addSubview:iconImageView];
        
        UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(55, i*50, WIDTH-55-40, 50) title:titleArray2[i] font:16];
        [thirdView addSubview:titleLabel];
        
        UIImageView *arrow =[MyControll createImageViewWithFrame:CGRectMake(WIDTH-27, i*50, 10, 50) imageName:@"m3@2x"];
        arrow.contentMode = UIViewContentModeScaleAspectFit;
        [thirdView addSubview:arrow];
        if (i!=0) {
            UIView *line = [MyControll createViewWithFrame:CGRectMake(20, i*50, WIDTH-20, 0.5)];
            line.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
            [thirdView addSubview:line];
        }
        
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, i*50, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(secViewClick:) target:self];
        btn.tag = 200+i;
        [thirdView addSubview:btn];
    }
    
    loginOutBtn = [MyControll createButtonWithFrame:CGRectMake(0, 410, WIDTH, 60) bgImageName:nil imageName:nil title:@"退出登录" selector:@selector(loginOutClick) target:self];
    loginOutBtn.backgroundColor = [UIColor whiteColor];
    loginOutBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [mainSC addSubview:loginOutBtn];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        loginOutBtn.hidden = YES;
    }
    else
    {
        loginOutBtn.hidden = NO;
    }
    
}
-(void)checkInfoCLick
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    SelfInfoViewController *vc = [[SelfInfoViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.dataDic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)firstViewClick:(UIButton *)sender
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        [self gotoLogin];
        return;
    }
    int index = (int)sender.tag - 100;
    if (index == 0) {
        MyAccountViewController *vc = [[MyAccountViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 1)
    {
        MyMessageViewController *vc = [[MyMessageViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 2)
    {
        MyProfitViewController *vc = [[MyProfitViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)secViewClick:(UIButton *)sender
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        [self gotoLogin];
        return;
    }
    int index = (int)sender.tag - 200;
    if (index == 0) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uid = [user objectForKey:@"uid"];
        SelfHonestViewController *vc = [[SelfHonestViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.uid = uid;
        vc.type = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 1)
    {
        RealNameViewController *vc = [[RealNameViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)loginOutClick
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要退出该账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 300;
    [alert show];
}
-(void)loadData
{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        return;
    }
    [self StartLoading];
    NSString *url = [NSString stringWithFormat:@"%@userinfo?uid=%@&token=%@",SERVER_URL,uid,token];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf endSomething];
            
            if (data && data.length>0) {
                id jsonStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([jsonStr isKindOfClass:[NSArray class]]) {
                    
                }
                else
                {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSString *code = [dict[@"code"] stringValue];
                    if (!code) {
                        weakSelf.dataDic = [NSMutableDictionary dictionaryWithDictionary:dict];
                        [weakSelf refreshUI];
                    }
                    else{
                        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                        [user removeObjectForKey:@"uid"];
                        [user removeObjectForKey:@"token"];
                        [user removeObjectForKey:@"flag"];
                        [user synchronize];
                    }
                }
            }
        }
        else
        {
            [weakSelf endSomething];
            [weakSelf showMsg:@"请检查你的网络"];
        }
    }];
    
}
-(void)endSomething
{
    [self StopLoading];
}
-(void)refreshUI
{
    if (!self.dataDic[@"name"]||[self.dataDic[@"name"] isEqualToString:@""]) {
        nameLabel.text = @"请登录";
    }
    else
    {
        nameLabel.text = self.dataDic[@"name"];
    }
    [headView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang"]];
    for (int i = 0; i<5; i++) {
        if (i<[self.dataDic[@"sendcerity"]intValue]) {
            UIImageView *star =(UIImageView *)[firstView viewWithTag:80000+i];
            star.image = [UIImage imageNamed:@"m16@2x_14"];
        }
        else
        {
            UIImageView *star =(UIImageView *)[firstView viewWithTag:80000+i];
            star.image = [UIImage imageNamed:@"m16@2x_16"];
        }
        if (i<[self.dataDic[@"getcerity"]intValue]) {
            UIImageView *star =(UIImageView *)[firstView viewWithTag:90000+i];
            star.image = [UIImage imageNamed:@"m16@2x_14"];
        }
        else
        {
            UIImageView *star =(UIImageView *)[firstView viewWithTag:90000+i];
            star.image = [UIImage imageNamed:@"m16@2x_16"];
        }
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        loginOutBtn.hidden = YES;
    }
    else
    {
        loginOutBtn.hidden = NO;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 300) {
        if (buttonIndex == 1) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user removeObjectForKey:@"uid"];
            [user removeObjectForKey:@"token"];
            [user removeObjectForKey:@"flag"];
            [user synchronize];
            [self.dataDic removeAllObjects];
            [self refreshUI];
            LoginViewController *vc = [[LoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (alertView.tag==301)
    {
        if (buttonIndex == 1) {
            LoginViewController *vc = [[LoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
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

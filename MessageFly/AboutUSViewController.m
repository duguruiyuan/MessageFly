//
//  AboutUSViewController.m
//  MessageFly
//
//  Created by xll on 15/2/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "AboutUSViewController.h"
#import "ShareView.h"
@interface AboutUSViewController ()
{
    UIScrollView *mainSC;
    
    UIImageView *iconImageView;
    
    UILabel *nameLabel;
    UILabel *editionLabel;
    
    UILabel *servicePhone;
    UILabel *netLabel;
    UILabel *emailLabel;
    UILabel *descLabel;
}
@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"关于我们" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *shareBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"p21" title:nil selector:@selector(shareClick) target:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    [self makeUI];

}
-(void)shareClick
{
    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, sHEIGHT)];
    shareView.delegate = self;
    [self.tabBarController.view addSubview:shareView];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 520);
    [self.view addSubview:mainSC];
    
    iconImageView = [MyControll createImageViewWithFrame:CGRectMake((WIDTH-100)/2, 100, 100, 100) imageName:@"Icon60@2x"];
    [mainSC addSubview:iconImageView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake((WIDTH-150)/2, 220, 150, 30) title:@"信儿快飞" font:20];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [mainSC addSubview:nameLabel];
    editionLabel = [MyControll createLabelWithFrame:CGRectMake((WIDTH-150)/2, 250, 150, 20) title:@"V1.0" font:15];
    editionLabel.textColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.69f alpha:1.00f];
    editionLabel.textAlignment = NSTextAlignmentCenter;
    [mainSC addSubview:editionLabel];
    
    servicePhone = [MyControll createLabelWithFrame:CGRectMake(0, 320, WIDTH, 20) title:@"服务热线：400-700-8080" font:15];
    servicePhone.textColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.69f alpha:1.00f];
    servicePhone.textAlignment = NSTextAlignmentCenter;
    [mainSC addSubview:servicePhone];
    
    netLabel = [MyControll createLabelWithFrame:CGRectMake(0, 340, WIDTH, 20) title:@"官网：www.laiwangzhibang.org" font:15];
    netLabel.textColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.69f alpha:1.00f];
    netLabel.textAlignment = NSTextAlignmentCenter;
    [mainSC addSubview:netLabel];
    emailLabel = [MyControll createLabelWithFrame:CGRectMake(0, 360, WIDTH, 20) title:@"E-Mail:laiwang@163.com" font:15];
    emailLabel.textColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.69f alpha:1.00f];
    emailLabel.textAlignment = NSTextAlignmentCenter;
    [mainSC addSubview:emailLabel];
    
    descLabel= [MyControll createLabelWithFrame:CGRectMake(0, 460, WIDTH, 20) title:@"信儿快飞  版权所有" font:15];
    descLabel.textColor = [UIColor colorWithRed:0.68f green:0.68f blue:0.69f alpha:1.00f];
    descLabel.textAlignment = NSTextAlignmentCenter;
    [mainSC addSubview:descLabel];
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

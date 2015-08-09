//
//  LoseEffectMyOrderViewController.m
//  MessageFly
//
//  Created by xll on 15/2/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "LoseEffectMyOrderViewController.h"
#import "PicSCView.h"
#import "ReplyViewController.h"
@interface LoseEffectMyOrderViewController ()<UIAlertViewDelegate>
{
    UIScrollView *mainSC;
    UIImageView *headView;
    UILabel *nameLabel;
    UILabel *phoneLabel;
    UIImageView *playStaus;
    UILabel *timeLength;
    UIView *contentView;
    UILabel *contentLabel;
    UIView *picView;
    
    UIView *thirdView;
    
    UILabel *moneyLabel;
    UILabel *endTimeLabel;
    UILabel *distanceLabel;
    UILabel *stausLabel;
    
}
@end

@implementation LoseEffectMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"已失效详情" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(10, 0, 40, 30) bgImageName:nil imageName:nil title:@"回复" selector:@selector(reply) target:self];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)reply
{
    ReplyViewController *vc = [[ReplyViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 680);
    [self.view addSubview:mainSC];
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    firstView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:firstView];
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"发布人信息" font:15];
    [firstView addSubview:tishi1];
    
    UIView*line = [[UIView alloc]initWithFrame:CGRectMake(20, 40, WIDTH-20, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [firstView addSubview:line];
    
    headView = [MyControll createImageViewWithFrame:CGRectMake(20, 50, 60, 60) imageName:@"picdefault@2x"];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius=30;
    [firstView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(90, 50, WIDTH-90-50, 20) title:@"" font:18];
    [firstView addSubview:nameLabel];
    
    UILabel * tishi2 = [MyControll createLabelWithFrame:CGRectMake(90, 70, 70, 20) title:@"联系电话:" font:13];
    tishi2.textColor = [UIColor lightGrayColor];
    [firstView addSubview:tishi2];
    
    UILabel *tishi3 = [MyControll createLabelWithFrame:CGRectMake(90, 90, 70, 20) title:@"发单诚信" font:13];
    tishi3.textColor = [UIColor lightGrayColor];
    [firstView addSubview:tishi3];
    
    phoneLabel = [MyControll createLabelWithFrame:CGRectMake(160, 70, WIDTH-160-50, 20) title:@"" font:13];
    phoneLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:phoneLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH-50, 50, 1, 60)];
    line2.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [firstView addSubview:line2];
    
    UIButton *contactBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-45, 40, 40, 80) bgImageName:nil imageName:@"11116" title:nil selector:@selector(contactClick) target:self];
    [firstView addSubview:contactBtn];
    
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 135, WIDTH, 345)];
    secView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:secView];
    
    UILabel *tishi4 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"详情" font:15];
    [secView addSubview:tishi4];
    
    UIView*line3 = [[UIView alloc]initWithFrame:CGRectMake(20, 40, WIDTH-20, 1)];
    line3.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [secView addSubview:line3];
    
    UILabel *tishi5 = [MyControll createLabelWithFrame:CGRectMake(20, 50, 150, 20) title:@"语音" font:14];
    tishi5.textColor = [UIColor lightGrayColor];
    [secView addSubview:tishi5];
    
    UIButton *voiceBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH-200)/2, 70, 200, 50) bgImageName:@"15@2x" imageName:nil title:nil selector:@selector(voiceClick) target:self];
    [secView addSubview:voiceBtn];
    
    playStaus =[MyControll createImageViewWithFrame:CGRectMake(40, 0, 25, 50) imageName:@"16@2x_25"];
    playStaus.contentMode = UIViewContentModeScaleAspectFit;
    [voiceBtn addSubview:playStaus];
    
    timeLength = [MyControll createLabelWithFrame:CGRectMake(65, 0, 200-65-10, 50) title:@"10秒" font:14];
    timeLength.textAlignment = NSTextAlignmentCenter;
    timeLength.textColor = [UIColor whiteColor];
    [voiceBtn addSubview:timeLength];
    
    UIView*line4 = [[UIView alloc]initWithFrame:CGRectMake(20, 135, WIDTH-20, 1)];
    line4.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [secView addSubview:line4];
    
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 135, WIDTH, 90)];
    [secView addSubview:contentView];
    
    UILabel *tishi6 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"文字" font:14];
    tishi6.textColor = [UIColor lightGrayColor];
    [contentView addSubview:tishi6];
    
    contentLabel = [MyControll createLabelWithFrame:CGRectMake(20, 35, WIDTH-40, 45) title:@"我需要帮忙订一份午饭，土豆牛腩盖饭，再加分宫保鸡丁盖饭吧，快点呀" font:15];
    [contentView addSubview:contentLabel];
    
    picView =[[UIView alloc]initWithFrame:CGRectMake(0, 235, WIDTH, 110)];
    [secView addSubview:picView];
    
    UIView*line5 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIDTH-20, 1)];
    line5.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [picView addSubview:line5];
    
    UILabel *tishi7 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"图片" font:14];
    tishi7.textColor = [UIColor lightGrayColor];
    [picView addSubview:tishi7];
    
    NSArray *picArray = @[@"picdefault@2x",@"picdefault@2x",@"picdefault@2x",@"picdefault@2x",@"picdefault@2x",@"picdefault@2x",@"picdefault@2x",@"picdefault@2x",@"picdefault@2x"];
    
    PicSCView *picSCView = [[PicSCView alloc]initWithFrame:CGRectMake(0, 35, WIDTH, 65)];
    picSCView.rect = CGRectMake(20, 0, 60, 60);
    picSCView.distance = 10;
    picSCView.delegate = self;
    [picSCView loadPicArray:picArray];
    [picView addSubview:picSCView];
    
    
    thirdView = [MyControll createToolView4WithFrame:CGRectMake(0, 495, WIDTH, 160) withColor:[UIColor whiteColor] withNameArray:@[@"酬      金:",@"剩余时长:",@"投放地址:",@"抢单状态:"]];
    [mainSC addSubview:thirdView];
    
    moneyLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH-100, 0, 90, 40) title:@"10元/人" font:15];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:moneyLabel];
    endTimeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH-100, 40, 90, 40) title:@"20:00" font:15];
    endTimeLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:endTimeLabel];
    distanceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH-100, 80, 90, 40) title:@"海淀上地七街" font:15];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:distanceLabel];
    stausLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH-100, 120, 90, 40) title:@"已失效" font:15];
    stausLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:stausLabel];
}
-(void)contactClick
{
    
}
-(void)voiceClick
{
    
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

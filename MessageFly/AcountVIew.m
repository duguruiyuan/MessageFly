//
//  AcountVIew.m
//  MessageFly
//
//  Created by xll on 15/4/10.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "AcountVIew.h"
#import "ChargeViewController.h"
#import "ApplyForCashViewController.h"
@implementation AcountVIew

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    self.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.95f alpha:1.00f];
    UIImageView *bgView = [MyControll createImageViewWithFrame:CGRectMake(0, 0, sWIDTH, 150) imageName:@"m16"];
    [self addSubview:bgView];
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(20, 5, 150, 20) title:@"当前余额" font:15];
    tishi.textColor =[UIColor whiteColor];
    [bgView addSubview:tishi];
    
    
    countNum= [MyControll createLabelWithFrame:CGRectMake(20, 40, sWIDTH-40, 45) title:@"￥0.00" font:30];
    countNum.textAlignment = NSTextAlignmentCenter;
    countNum.textColor = [UIColor whiteColor];
    [bgView addSubview:countNum];
    
    UIButton *chargeBtn = [MyControll createButtonWithFrame:CGRectMake((sWIDTH/2-140)/2, 90, 140, 40) bgImageName:nil imageName:@"m17" title:nil selector:@selector(chargeClick) target:self];
    [bgView addSubview:chargeBtn];
    UIButton *getOutBtn = [MyControll createButtonWithFrame:CGRectMake((sWIDTH/2-140)/2+sWIDTH/2, 90, 140, 45) bgImageName:nil imageName:@"m18" title:nil selector:@selector(getOutClick) target:self];
    [bgView addSubview:getOutBtn];
    
    UIView*whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 165, sWIDTH, 50)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 30) title:@"账户明细" font:16];
    [whiteView addSubview:tishi2];
    
    UIView *line = [MyControll createLineWithFrame:CGRectMake(20, 214, sWIDTH-20, 1) withColor:[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f]];
    [self addSubview:line];
}
-(void)chargeClick
{
    ChargeViewController *vc = [[ChargeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [_delegate.navigationController pushViewController:vc animated:YES];
}
-(void)getOutClick
{
    ApplyForCashViewController *vc = [[ApplyForCashViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.myCount =dataDic[@"money"];
    vc.frozenMoney = dataDic[@"money2"];
    vc.leftMoney = dataDic[@"usemoney"];
    [_delegate.navigationController pushViewController:vc animated:YES];
}
-(void)config:(NSDictionary *)dic
{
    dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    countNum.text = [NSString stringWithFormat:@"￥%@",dic[@"money"]];
}
@end

//
//  MyAnnotationView.m
//  MessageFly
//
//  Created by xll on 15/4/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MyAnnotationView.h"
#import "NearbyDetailNotViewController.h"
#import "SearchPeopleViewController.h"
@implementation MyAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 80)];
//    [leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToOther:)]];
    leftView.userInteractionEnabled = YES;
    leftView.layer.cornerRadius = 3;
    leftView.clipsToBounds = YES;
    leftView.backgroundColor = [UIColor whiteColor];
    moneyLabel = [MyControll createLabelWithFrame:CGRectMake(10, 10, 170, 20) title:nil font:14];
    [leftView addSubview:moneyLabel];
   timeLabel = [MyControll createLabelWithFrame:CGRectMake(10, 30, 170, 20) title:nil font:14];
    [leftView addSubview:timeLabel];
    addressLabel = [MyControll createLabelWithFrame:CGRectMake(10, 50, 170, 20) title:nil font:14];
    [leftView addSubview:addressLabel];
    
    UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(177.5, 0, 15, 80) imageName:@"right11@2x"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:imageView];
    
//    self.leftCalloutAccessoryView = leftView;
    
    
    UIButton *gotoBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 200, 80) bgImageName:nil imageName:nil title:nil selector:@selector(goToOther:) target:self];
    [leftView addSubview:gotoBtn];
    self.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:leftView];
}
-(void)config:(NSDictionary *)dic
{
    dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    moneyLabel.text = [NSString stringWithFormat:@"报酬:%@元",dic[@"money"]];
    timeLabel.text =[NSString stringWithFormat:@"剩余时间:%@",dic[@"ltime"]];
    addressLabel.text =[NSString stringWithFormat:@"地址:%@",dic[@"address"]];
}
-(void)goToOther:(UIButton *)sender
{
    if ([dict[@"type"] isEqualToString:@"1"]) {
//        if ([dict[@"state"] isEqualToString:@"0"]) {
            NearbyDetailNotViewController *vc = [[NearbyDetailNotViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.detaiID = dict[@"id"];
            [_delegate.navigationController pushViewController:vc animated:YES];
//        }
    }
    else if ([dict[@"type"] isEqualToString:@"2"])
    {
        UIStoryboard *mainstory =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchPeopleViewController *vc = [mainstory instantiateViewControllerWithIdentifier:@"SearchPeopleViewController"];
        vc.detaiID = dict[@"id"];
        vc.hidesBottomBarWhenPushed = YES;
        [_delegate.navigationController pushViewController:vc animated:YES];
    }
}
@end

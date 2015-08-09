//
//  LeftView.m
//  MessageFly
//
//  Created by xll on 15/2/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "LeftView.h"
#import "TextYingJHViewController.h"
#import "VoiceYingJHViewController.h"
@implementation LeftView

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
    self.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UIView *midView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT-70)];
    midView.backgroundColor = [UIColor whiteColor];
    [self addSubview:midView];
    UIImageView *midImageView = [MyControll createImageViewWithFrame:CGRectMake(20, 20, vWIDTH-40, midView.frame.size.height-40) imageName:@"tuijian@2x"];
    midImageView.contentMode = UIViewContentModeScaleAspectFit;
    midImageView.backgroundColor = [UIColor whiteColor];
    [midView addSubview:midImageView];
    
    UIButton *textBtn = [MyControll createButtonWithFrame:CGRectMake(10, vHEIGHT-60, 50, 50) bgImageName:nil imageName:@"p7@2x" title:nil selector:@selector(textClick) target:self];
    [self addSubview:textBtn];
    
    UIButton *voiceBtn = [MyControll createButtonWithFrame:CGRectMake(70, vHEIGHT-60, vWIDTH-80, 50) bgImageName:nil imageName:@"p8@2x" title:nil selector:nil target:self];
    [voiceBtn addTarget:self action:@selector(voiceClick) forControlEvents:UIControlEventTouchDown];
    [voiceBtn addTarget:self action:@selector(voiceStop) forControlEvents:UIControlEventTouchUpInside];
    [voiceBtn addTarget:self action:@selector(voiceStop) forControlEvents:UIControlEventTouchUpOutside];
//    [voiceBtn addTarget:self action:@selector(removeAndAgain) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:voiceBtn];
//    record = [MyRecordAndPlayer sharedInstance];
    
//    [record setAdiuo:@"b"];
}
-(void)textClick
{
    TextYingJHViewController *vc = [[TextYingJHViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [_delegate.navigationController pushViewController:vc animated:YES];
}
-(void)voiceClick
{
    _sc.scrollEnabled = NO;
    record = [MyRecord sharedInstance];
    [record startRecord];
    [self showVoiceLoadingView];
}
-(void)goToNext
{
    
    VoiceYingJHViewController *vc = [[VoiceYingJHViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.filePath = record.recordPath;
    vc.voiceLength = timeLength;
//    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [_delegate.navigationController pushViewController:vc animated:YES];
//    [_delegate presentViewController:nvc animated:YES completion:nil];


}
-(void)voiceStop
{
    _sc.scrollEnabled = YES;
    [record stopRecord];
    timeLength = record.voiceLength;
    if (timeLength<1.0) {
        [self showMsg:@"录音太短"];
        [self hideVoiceLoadingView];
        return;
    }
    [self hideVoiceLoadingView];
    
    [self performSelector:@selector(goToNext) withObject:nil afterDelay:0.2];
}
@end

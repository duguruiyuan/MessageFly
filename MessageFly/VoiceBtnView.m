//
//  VoiceBtnView.m
//  MessageFly
//
//  Created by xll on 15/4/2.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "VoiceBtnView.h"

@implementation VoiceBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    
    UIImage *image =[UIImage imageNamed:@"15"];
    self.image =[image resizableImageWithCapInsets:UIEdgeInsetsMake( 20, 50, 20, 50 )];
    self.userInteractionEnabled = YES;
    
    playStaus =[MyControll createImageViewWithFrame:CGRectMake(40, 0, 25, 50) imageName:@"16@2x_25"];
    playStaus.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:playStaus];
    
    timeLength = [MyControll createLabelWithFrame:CGRectMake(65, 0, 105, 50) title:nil font:14];
    timeLength.textAlignment = NSTextAlignmentCenter;
    timeLength.textColor = [UIColor whiteColor];
    [self addSubview:timeLength];
    
    UIButton *playVoiceBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 260-80, 50) bgImageName:nil imageName:nil title:nil selector:@selector(voiceClick:) target:self];
    playVoiceBtn.selected = NO;
    [self addSubview:playVoiceBtn];
    
    UIView *line1 = [MyControll createLineWithFrame:CGRectMake(260-80, 0, 1, 50) withColor:[UIColor colorWithRed:0.15f green:0.69f blue:0.89f alpha:1.00f]];
    [self addSubview:line1];
    
    UIButton *deleteBtn = [MyControll createButtonWithFrame:CGRectMake(260-60, 10, 30, 30) bgImageName:nil imageName:@"p5@2x" title:nil selector:@selector(deleteClick) target:self];
    deleteBtn.backgroundColor = [UIColor whiteColor];
    deleteBtn.clipsToBounds = YES;
    deleteBtn.layer.cornerRadius =15;
    [self addSubview:deleteBtn];
    
}
-(void)passData
{
    timeLength.text =[NSString stringWithFormat:@"%.1f秒",_voiceLength];
}
-(void)deleteClick
{
    [record stopPlay];
    playStaus.image = [UIImage imageNamed:@"16@2x_25"];
    
    timeNum = _voiceLength;
    timeLength.text =[NSString stringWithFormat:@"%.1f秒",timeNum];
    [timer invalidate];
    self.myBlock(self);
}
-(void)voiceClick:(UIButton *)sender
{
    if (sender.selected) {
        [record stopPlay];
        playStaus.image = [UIImage imageNamed:@"16@2x_25"];
        
        timeNum = _voiceLength;
        timeLength.text =[NSString stringWithFormat:@"%.1f秒",timeNum];
        [timer invalidate];
    }
    else
    {
        playStaus.image = [UIImage imageNamed:@"16@2x_29"];
        record = [MyRecord sharedInstance];
        [record startPlay];
         timeNum = _voiceLength;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        record.myBlock = ^(MyRecord *myPlayer)
        {
            playStaus.image =[UIImage imageNamed:@"16@2x_25"];
            sender.selected = NO;
            
        };
        [timer fire];
    }
    sender.selected = !sender.selected;
}
-(void)changeTime
{
    if (timeNum>=0.1) {
        timeNum -= 0.1;
        timeLength.text =[NSString stringWithFormat:@"%.1f秒",timeNum];
    }
    else
    {
        timeNum = _voiceLength;
        timeLength.text =[NSString stringWithFormat:@"%.1f秒",timeNum];
        [timer invalidate];
    }
}
-(void)stopPlay
{
    [record stopPlay];
}
@end

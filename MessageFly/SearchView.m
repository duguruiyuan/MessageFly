//
//  SearchView.m
//  MessageFly
//
//  Created by xll on 15/2/11.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

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
    self.backgroundColor = [UIColor clearColor];
    UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, vWIDTH, vHEIGHT)];
    shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)]];
    [self addSubview:shadowView];
    
    xialaView = [MyControll createImageViewWithFrame:CGRectMake(vWIDTH-170, -8, 160, 158) imageName:@"2@2x"];
    xialaView.backgroundColor = [UIColor clearColor];
    xialaView.alpha = 0.98;
    xialaView.userInteractionEnabled = YES;
    [self addSubview:xialaView];
    
    NSArray *array = @[@"按时间",@"按距离",@"按报酬"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, 8+50*i, 160, 50) bgImageName:nil imageName:nil title:array[i] selector:@selector(btnClick:) target:self];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [xialaView addSubview:btn];
    }
}
-(void)removeView
{
    [_delegate selectView:self Index:5];
    [self removeFromSuperview];
}
-(void)btnClick:(UIButton *)sender
{
    int index = (int)sender.tag-100;
    [_delegate selectView:self Index:index];
    [self removeFromSuperview];
}
@end

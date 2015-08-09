//
//  MoveView.m
//  dddd
//
//  Created by xll on 15/5/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MoveView.h"

@implementation MoveView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    self.clipsToBounds = YES;
    contentLabel = [[UILabel alloc]initWithFrame:self.bounds];
    [self addSubview:contentLabel];
}
-(void)config:(NSString *)contentword withFont:(int)fondSize withTime:(float)movetime
{
    timelength = movetime;
    contentLabel.text = contentword;
    contentLabel.font = [UIFont systemFontOfSize:fondSize];
    CGSize size = [self getSize:contentword Font:fondSize Width:1000 Height:CGRectGetHeight(self.frame)];
    CGRect rect = contentLabel.frame;
    rect.size.width = size.width+5;
    contentLabel.frame = rect;
    [self move];
    float movelength = CGRectGetWidth(contentLabel.frame)- self.bounds.size.width;
     float t = movelength/13;
    timer = [NSTimer scheduledTimerWithTimeInterval:t+0.01 target:self selector:@selector(move) userInfo:nil repeats:YES];
}
-(void)move
{
    float movelength = CGRectGetWidth(contentLabel.frame)- self.bounds.size.width;
    float t = movelength/13;
    if (movelength<0) {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        return;
    }
    [UIView animateWithDuration:t animations:^{
        CGRect rect = contentLabel.frame;
        rect.origin.x = -movelength;
        contentLabel.frame = rect;
    } completion:^(BOOL finished) {
        CGRect rect = contentLabel.frame;
        rect.origin.x = 0;
        contentLabel.frame = rect;
    }];

}
-(CGSize)getSize:(NSString *)str Font:(float)sizeofstr Width:(float)width Height:(float)height
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:sizeofstr]} context:nil].size;
    }else{
        size = [str sizeWithFont:[UIFont systemFontOfSize:sizeofstr]constrainedToSize:CGSizeMake(width, height)];
    }
    return size;
}
-(void)dealloc
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
@end

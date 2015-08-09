//
//  BaseADView.m
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-17.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BaseADView.h"

@implementation BaseADView

@synthesize mLoadMsg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
         voiceArray = @[@"record_animate_1",@"record_animate_2",@"record_animate_3",@"record_animate_4",@"record_animate_5",@"record_animate_6",@"record_animate_7",@"record_animate_8",@"record_animate_9",@"record_animate_10",@"record_animate_11",@"record_animate_12",@"record_animate_13",@"record_animate_14",@"record_animate_15"];
    }
    return self;
}

- (void)dealloc {
    self.mLoadMsg = nil;
}

- (void)ShowLogo:(int)iOffset {
    if (mLogoView) {
        return;
    }
    int iWidth = 150;
    int iHeight = 130;
    mLogoView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-iWidth)/2, (self.frame.size.height-iHeight)/2+iOffset, iWidth, iHeight)];
    mLogoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    mLogoView.image = [UIImage imageNamed:@"default_logo.png"];
    [self addSubview:mLogoView];
}

- (void)HideLogo {
    if (mLogoView) {
        [mLogoView removeFromSuperview];
        mLogoView = nil;
    }
}

- (void)StartLoading
{
    if (mLoadView) {
        return;
    }
    mLoadView = [[MBProgressHUD alloc] initWithView:self];
    if (mLoadMsg) {
        mLoadView.mode = MBProgressHUDModeCustomView;
        mLoadView.labelText = mLoadMsg;
    }
    [self addSubview:mLoadView];
    
    [mLoadView show:YES];
}

- (void)StopLoading
{
    [mLoadView hide:YES];
    mLoadView = nil;
}

- (void)showMsg:(NSString *)msg
{
    mLoadView = [[MBProgressHUD alloc] initWithView:self];
	[self addSubview:mLoadView];
    
	mLoadView.mode = MBProgressHUDModeCustomView;
	mLoadView.labelText = msg;
	[mLoadView show:YES];
	[mLoadView hide:YES afterDelay:1];
    mLoadView = nil;
}

-(void)showVoiceLoadingView
{
    if (voiceLoadView) {
        return;
    }
    voiceLoadView =[[MBProgressHUD alloc] initWithView:self];
    [voiceLoadView show:YES];
    [self addSubview:voiceLoadView];
    
    recordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_animate_1"]];
    voiceLoadView.customView = recordImageView;
    voiceLoadView.mode = MBProgressHUDModeCustomView;
    voiceLoadView.labelText = @"正在录音";
    imageNum = 2;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)changeImage
{
    if (imageNum ==15) {
        imageNum = 1;
    }
    recordImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"record_animate_%d",imageNum]];
    imageNum++;
}
-(void)hideVoiceLoadingView
{
    [voiceLoadView hide:YES];
    voiceLoadView.dimBackground = NO;
    voiceLoadView = nil;
    [timer invalidate];

}
@end

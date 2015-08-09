//
//  VoiceBtnView.h
//  MessageFly
//
//  Created by xll on 15/4/2.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecord.h"
@interface VoiceBtnView : UIImageView
{
    UIImageView *playStaus;
    UILabel *timeLength;
    
    MyRecord *record ;
    NSTimer *timer;
    double timeNum;
}
@property(nonatomic,copy)void(^myBlock)(VoiceBtnView *);
@property(nonatomic)double voiceLength;
@property(nonatomic)NSString *filePath;
-(void)passData;
-(void)stopPlay;
@end

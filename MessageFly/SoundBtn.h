//
//  SoundBtn.h
//  MessageFly
//
//  Created by xll on 15/4/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MyMD5.h"
#import "MyPlayer.h"
@interface SoundBtn : UIImageView<AVAudioPlayerDelegate>
{
    UIImageView *playStaus;
    UILabel *timeLength;
    UILabel *stateLabel;
    NSMutableDictionary *dataDic;
    MyPlayer *player;
    
    NSTimer *timer;
    float num;
}
@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
-(void)loadVoiceData:(NSDictionary *)dic;
-(void)stopPlay;
@end

//
//  MyPlayer.m
//  MessageFly
//
//  Created by xll on 15/4/16.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MyPlayer.h"

@implementation MyPlayer
+(MyPlayer*)sharedInstance
{
    static MyPlayer *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MyPlayer alloc] init];
        [_sharedInstance myplayerSet];
    });
    
    return _sharedInstance;
}
-(void)myplayerSet
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
//    player = [[AVAudioPlayer alloc]init];
}
-(void)startPLay:(NSData *)data
{
    NSError *playerError;
    //初始化播放器

    player = [[AVAudioPlayer alloc]initWithData:data error:&playerError];
    if (player == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    //设置播放器代理
    player.delegate = self;
    //设置从扬声器播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [player play];
}
-(void)stopPlay
{
    if (player.playing) {
        [player stop];
    }
}
//播放结束的时候把button的标题设置成播放.
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.myBlock(flag);
}
-(BOOL)ifPlaying
{
    if (player.playing) {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end

//
//  RecordPlay.m
//  TestHebei
//
//  Created by iHope on 14-6-25.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "RecordPlay.h"
//#import "NetAudioPlayer.h"
//#import "DongTingAudioPlayer.h"
//#import "KuaiXunAudioPlayer.h"
//#import "XiaZaiAudioPlayer.h"
//#import "FamouseAudioPlayer.h"
//#import "ShouCangAudioPlayer.h"
//#import "LAudioPlayerManager.h"

@implementation RecordPlay

//+(RecordPlay*)sharedInstance
//{
//    static RecordPlay *_sharedInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedInstance = [[RecordPlay alloc] init];
//        [_sharedInstance initPlayer];
//        
//    });
//    
//    return _sharedInstance;
//}
//
//-(void)initPlayer{
//    //初始化播放器的时候如下设置
//    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
//    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
//                            sizeof(sessionCategory),
//                            &sessionCategory);
//    
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
//                             sizeof (audioRouteOverride),
//                             &audioRouteOverride);
//    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    //默认情况下扬声器播放
//    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [audioSession setActive:YES error:nil];
//    audioSession = nil;
//}
//-(BOOL)isShort
//{
//    double cTime = self.recorder.currentTime;
//    double standardTime = cTime/cTime;
//    return !(cTime > standardTime) ;
//
//}
//-(void)playRecordWithFileName:(NSString*)fileName
//{
//    if(self.player.isPlaying){
//        
//        [self.player stop];
//    }
//    //停掉动听播放
//    if ([NetAudioPlayer Share].mbPlaying) {
//        [[NetAudioPlayer Share].mMoviePlayer stop];
//    }
//    //播放
//    NSURL *fileUrl=[NSURL URLWithString:fileName];
//    [self initPlayer];
//    NSError *error;
//    
//    NSData *mydata=[[NSData alloc]initWithContentsOfURL:fileUrl];
//   
//    self.player=[[AVAudioPlayer alloc]initWithData:mydata  error:&error];
//  // self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:&error];
//    [self.player setVolume:1];
//    [self.player prepareToPlay];
//    [self.player setDelegate:self];
//    [self.player play];
//    //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
//}
//
//-(void)playRecord
//{
//    if(self.player.isPlaying){
//        
//        [self.player stop];
//    }
//    //停掉动听播放
//    if ([NetAudioPlayer Share].mbPlaying) {
//        [[NetAudioPlayer Share].mMoviePlayer stop];
//    }
//
//    
//    //播放
//    NSString *filePath=[NSString documentPathWith:self.fileName];
//    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
//    [self initPlayer];
//    NSError *error;
//    self.player=[[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:&error];
//    [self.player setVolume:1];
//    [self.player prepareToPlay];
//    [self.player setDelegate:self];
//    [self.player play];
//    //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
//}
//-(void)beginRecord
//{
//    //录音之前先停掉其他音频
//    [[LAudioPlayerManager shareAudioManager] pausePlayer];
//    
//    if(self.recording)return;
//    
//    if ([NetAudioPlayer Share].mbPlaying) {
//         [[NetAudioPlayer Share] StopAudio];
//    }
//    [[FamouseAudioPlayer Share] Pause];
//    [[DongTingAudioPlayer Share] Pause];
//    [[KuaiXunAudioPlayer Share] Pause];
//    [[XiaZaiAudioPlayer Share] Pause];
//    [[ShouCangAudioPlayer Share]Pause];
//    self.recording=YES;
//
//    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
//                            [NSNumber numberWithFloat:8000],AVSampleRateKey,
//                            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
//                            [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
//                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
//                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
//                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
//                            nil];
//    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    NSDate *now = [NSDate date];
//    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
//    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
//    NSString *fileName = [NSString stringWithFormat:@"random_%@.wav",[dateFormater stringFromDate:now]];
//    self.fileName=fileName;
//    NSString *filePath=[NSString documentPathWith:fileName];
//    self.fileFullPath=filePath;
//    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
//    NSError *error;
//    self.recorder=[[AVAudioRecorder alloc]initWithURL:fileUrl settings:settings error:&error];
//    [self.recorder prepareToRecord];
//    [self.recorder setMeteringEnabled:YES];
//    [self.recorder peakPowerForChannel:0];
//    [self.recorder record];
//}
//-(void)finishRecord
//{
//    self.recording=NO;
//    [self.recorder stop];
//    self.recorder=nil;
//    
//    //还原以前的播放
//    [[LAudioPlayerManager shareAudioManager] restorePlayer];
//}
//-(void)deleteRecord
//{
// [self.recorder deleteRecording];
//}
//
//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//  //这里可以添加播放完录音文件之后，继续播放动听
//    
//}
//
//
//-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
//{
//}
//
@end

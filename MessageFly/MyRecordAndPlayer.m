//
//  MyRecordAndPlayer.m
//  MessageFly
//
//  Created by xll on 15/3/25.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MyRecordAndPlayer.h"

@implementation MyRecordAndPlayer
{
    //音频录制类
    AVAudioRecorder *_recorder;
    //音频存储路径
    NSString *_filePath;
   AVAudioPlayer *_player;
}
+(MyRecordAndPlayer*)sharedInstance
{
    static MyRecordAndPlayer *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MyRecordAndPlayer alloc] init];
         [_sharedInstance initPlayer];
    });
    
    return _sharedInstance;
}
-(void)initPlayer{
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    NSError * sessionError;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(audioSession == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [audioSession setActive:YES error:nil];
    
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                // Microphone enabled code
            }
            else {
                // Microphone disabled code
            }
        }];
    }
}
//开始录音
-(void)setAdiuo:(NSString *)fileName
{
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    NSError * sessionError;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(audioSession == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [audioSession setActive:YES error:nil];
    
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                // Microphone enabled code
            }
            else {
                // Microphone disabled code
            }
        }];
    }

    NSMutableDictionary *recordSeting = [[NSMutableDictionary alloc] init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSeting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSeting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSeting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSeting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSeting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    //设置音频保存路径
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _filePath = [NSString stringWithFormat:@"%@/%@",strUrl,fileName];
    
    NSError *error;
    //初始化音频录制了类
    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_filePath] settings:recordSeting error:&error];
    //开启音量检测
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    
}
-(void)startRecord
{
    
    //创建录音文件，准备录音
    if ([_recorder prepareToRecord]) {
        NSLog(@"录音文件配置成功");
        //开始录音
        [_recorder record];
        
        //设置定时器
        
    }else{
        NSLog(@"配置录音失败");
    }

}
//结束录音
-(void)stopRecord{
    _voiceLength = _recorder.currentTime;
    if (_recorder.isRecording) {
        [_recorder stop];
    }
}
- (void)playAudio:(NSString *)filepath
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    if (_player.playing) {
        [_player stop];
        return;
    }
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filepath] error:nil];
    _player.delegate = self;
    [_player play];
}
-(void)endPlayAudio
{
    if (_player.playing) {
        [_player stop];
    }
}

-(BOOL)isShort
{
    double cTime = _recorder.currentTime;
    NSLog(@"%f",cTime);
    if (cTime<0.3) {
        return YES;
    }
    else
    {
        return NO;
    }
}
//删除某一音频文件
- (void)removeAudioFileWithName:(NSString *)name{
    //删除文件
    [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
}

//返回音频文件所在路径
- (NSString *)getAudioFilePath{
    return _filePath;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.myBlock(self);
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}
@end

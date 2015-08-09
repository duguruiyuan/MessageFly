//
//  myRecord.m
//  SoundRecorderText
//
//  Created by xll on 15/3/27.
//  Copyright (c) 2015年 com.lanou. All rights reserved.
//

#import "MyRecord.h"

@implementation MyRecord
+(MyRecord*)sharedInstance
{
    static MyRecord *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MyRecord alloc] init];
        [_sharedInstance myRecordSet];
    });
    
    return _sharedInstance;
}
-(void)myRecordSet
{
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    filePath = [filePath stringByAppendingPathComponent:@"myCaches"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    _recordPath =[filePath stringByAppendingString:@"/RecordedFile.aac"];
    recordedFile = [NSURL fileURLWithPath:_recordPath];
    //在获得一个AVAudioSession类的实例后，你就能通过调用音频会话对象的setCategory:error:实例方法，来从IOS应用可用的不同类别中作出选择。
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    //设置可以播放和录音状态
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    
    
}
-(void)startRecord
{
    if (recorder.recording) {
        return;
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
    
    //先设置能播放和录音状态
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    //初始化录音
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:recordSeting error:nil];
    //准备录音
    [recorder prepareToRecord];
    //开始录音
    [recorder record];
}
-(void)stopRecord
{
    if (recorder.recording) {
        _voiceLength = recorder.currentTime;
        [recorder stop];
        recorder = nil;
    }
}
-(void)startPlay
{
    NSError *playerError;
    //初始化播放器
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
    
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
    self.myBlock(self);
}

@end

//
//  MyRecordAndPlayer.h
//  MessageFly
//
//  Created by xll on 15/3/25.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
@interface MyRecordAndPlayer : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    
}
@property(nonatomic)double voiceLength;
@property(nonatomic,copy)void(^myBlock)(MyRecordAndPlayer* player);
+(MyRecordAndPlayer*)sharedInstance;
-(void)setAdiuo:(NSString *)fileName;
//开始录音 ----
//-(void)startRecordWithFileName:(NSString *)fileName;
-(void)startRecord;
//结束录音
-(void)stopRecord;

//删除某一音频文件
- (void)removeAudioFileWithName:(NSString *)name;
//返回音频文件所在路径
- (NSString *)getAudioFilePath;
- (void)playAudio:(NSString *)filepath;
-(void)endPlayAudio;
-(BOOL)isShort;
@end

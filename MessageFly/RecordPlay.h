//
//  RecordPlay.h
//  TestHebei
//
//  Created by iHope on 14-6-25.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "NSString+DocumentPath.h"
@interface RecordPlay : NSObject<AVAudioPlayerDelegate>
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,assign) BOOL recording;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,copy) NSString *fileFullPath;
+ (RecordPlay *)sharedInstance;
-(void)playRecord;
-(void)beginRecord;
-(void)finishRecord;
-(BOOL)isShort;
-(void)deleteRecord;
-(void)playRecordWithFileName:(NSString*)fileName;
@end

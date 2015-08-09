//
//  myRecord.h
//  SoundRecorderText
//
//  Created by xll on 15/3/27.
//  Copyright (c) 2015年 com.lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MyRecord : NSObject<AVAudioPlayerDelegate>
{
    NSURL *recordedFile;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
}
@property(nonatomic,copy)void(^myBlock)(MyRecord* player);
@property(nonatomic,strong)NSString *recordPath;
@property(nonatomic)double voiceLength;
+(MyRecord*)sharedInstance;
-(void)startRecord;
-(void)stopRecord;
-(void)startPlay;
-(void)stopPlay;
@end

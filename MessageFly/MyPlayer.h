//
//  MyPlayer.h
//  MessageFly
//
//  Created by xll on 15/4/16.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPlayer : NSObject<AVAudioPlayerDelegate>
{
    NSURL *recordedFile;
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
}
@property(nonatomic,copy)void(^myBlock)(BOOL ifSucceed);
@property(nonatomic,strong)NSString *recordPath;

+(MyPlayer*)sharedInstance;
-(void)startPLay:(NSData *)data;
-(void)stopPlay;
-(BOOL)ifPlaying;

@end

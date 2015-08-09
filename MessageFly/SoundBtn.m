//
//  SoundBtn.m
//  MessageFly
//
//  Created by xll on 15/4/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//
#define kUseBlockAPIToTrackPlayerStatus     1
#import "SoundBtn.h"
#import "NSFileManager+Mothod.h"
@implementation SoundBtn
@synthesize filePath;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    self.userInteractionEnabled = YES;
    self.image = [UIImage imageNamed:@"15@2x"];
    
    
    playStaus =[MyControll createImageViewWithFrame:CGRectMake(40, 0, 25, 50) imageName:@"16@2x_25"];
    playStaus.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:playStaus];
    
    timeLength = [MyControll createLabelWithFrame:CGRectMake(65, 0, 200-65-10, 50) title:@"秒" font:14];
    timeLength.textAlignment = NSTextAlignmentCenter;
    timeLength.textColor = [UIColor whiteColor];
    [self addSubview:timeLength];
    
    stateLabel = [MyControll createLabelWithFrame:CGRectMake(10, 0, 65, 50) title:@"正在缓冲..." font:13];
    stateLabel.textColor = [UIColor whiteColor];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:stateLabel];
    stateLabel.hidden = YES;
    
    
    UIButton *voiceBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 200, 50) bgImageName:nil imageName:nil title:nil selector:@selector(voiceClick) target:self];
    [self addSubview:voiceBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backToNormal) name:BACKTONORMAL object:nil];
}
-(void)backToNormal
{
    if ([player ifPlaying]) {
        [player stopPlay];
        num = [dataDic[@"videosec"] floatValue];
        timeLength.text = [NSString stringWithFormat:@"%.1f秒",num];
        [timer invalidate];
        player = nil;
        stateLabel.hidden = YES;
        playStaus.hidden = NO;
        playStaus.image = [UIImage imageNamed:@"16@2x_25"];
    }
    else
    {
        num = [dataDic[@"videosec"] floatValue];
        timeLength.text = [NSString stringWithFormat:@"%.1f秒",num];
        [timer invalidate];
        player = nil;
        stateLabel.hidden = YES;
        playStaus.hidden = NO;
        playStaus.image = [UIImage imageNamed:@"16@2x_25"];
    }
}
-(void)voiceClick
{
    if ([player ifPlaying]) {
        [player stopPlay];
        num = [dataDic[@"videosec"] floatValue];
        timeLength.text = [NSString stringWithFormat:@"%.1f秒",num];
        [timer invalidate];
        player = nil;
        stateLabel.hidden = YES;
        playStaus.hidden = NO;
        playStaus.image = [UIImage imageNamed:@"16@2x_25"];
    }
    else
    {
        [self createPlayer];
    }
    
}
-(void)loadVoiceData:(NSDictionary *)dic
{
    dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    timeLength.text = [NSString stringWithFormat:@"%@秒",dic[@"videosec"]];
    num = [dataDic[@"videosec"] floatValue];
}
-(void)createPlayer
{
    filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    filePath = [filePath stringByAppendingPathComponent:@"myCaches"];
    [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *str = dataDic[@"radio"];
    if (!str) {
        str = @"";
    }
    filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@.wav",[MyMD5 md5:str]]];
    
    NSFileManager*manager=[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]&&[manager timeOutWithPath:filePath timeOut:60*60*24*30]) {
        //文件存在，缓存有效，使用缓存
        [self startPlay];

   
    }else{
        [self saveData];
    }
 
}
-(void)startPlay
{
    [[NSNotificationCenter defaultCenter]postNotificationName:BACKTONORMAL object:nil];
    player = [MyPlayer sharedInstance];
    [player startPLay:[NSData dataWithContentsOfFile:filePath]];
    player.myBlock = ^(BOOL isSucceed)
    {
        num = [dataDic[@"videosec"] floatValue];
        timeLength.text = [NSString stringWithFormat:@"%.1f秒",num];
        [timer invalidate];
        player = nil;
        stateLabel.hidden = YES;
        playStaus.hidden = NO;
        playStaus.image = [UIImage imageNamed:@"16@2x_25"];
    };
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeChange:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    stateLabel.hidden = YES;
    playStaus.hidden = NO;
    playStaus.image = [UIImage imageNamed:@"16@2x_29"];
}
-(void)timeChange:(NSTimer *)sender
{
    if (num<0.1) {
        num = [dataDic[@"videosec"] floatValue];
        timeLength.text = [NSString stringWithFormat:@"%.1f秒",num];
        [timer invalidate];
    }
    else
    {
        num -= 0.1;
        timeLength.text = [NSString stringWithFormat:@"%.1f秒",num];
    }
}
-(void)stopPlay
{
    if ([player ifPlaying]) {
        [player stopPlay];
    }
}
-(void)saveData
{
    stateLabel.hidden = NO;
    playStaus.hidden = YES;
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [_sfManager addHttpTaskWithGet:dataDic[@"radio"] andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            if (data && data.length>0) {
//                BOOL ifDownLoadSuccess = [data writeToFile:weakSelf.filePath atomically:YES];
                BOOL ifDownLoadSuccess = [data writeToFile:weakSelf.filePath options:NSDataWritingAtomic error:nil];
                if (ifDownLoadSuccess) {
                    [weakSelf performSelector:@selector(startPlay) withObject:nil afterDelay:0.3];
                }
                else
                {
                    
                }
            }
        }
        else
        {
            num = [dataDic[@"videosec"] floatValue];
            timeLength.text = [NSString stringWithFormat:@"%.1f秒",num];
            player = nil;
            stateLabel.hidden = YES;
            playStaus.hidden = NO;
            playStaus.image = [UIImage imageNamed:@"16@2x_25"];
        }
    }];

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [timer invalidate];
    timer = nil;
}
@end

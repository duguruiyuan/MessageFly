//
//  ReplyViewController.m
//  MessageFly
//
//  Created by xll on 15/2/11.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ReplyViewController.h"
#import "MyRecordAndPlayer.h"
#import "VoiceBtnView.h"
#import "PicSelectView.h"
@interface ReplyViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,PicSelectDelegate>
{
    UIScrollView *mainSC;
    UITextView *textView;
    UIButton*voiceBtn;
    MyRecord *record ;
    double timeLength;
    
    VoiceBtnView *voiceBtnView;
    
    BOOL ifHasVoice;
    UIView *picView;
    int deletePicNum;
}
@property(nonatomic,strong)NSMutableArray *uploadPicArray;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation ReplyViewController
-(void)viewDidDisappear:(BOOL)animated
{
    [record stopPlay];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.uploadPicArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"回复" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *commitBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"提交" selector:@selector(commitClick) target:self];
    commitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commitBtn];
    [self makeUI];
}
-(void)commitClick
{
    [self.view endEditing:YES];
    if (textView.text.length == 0) {
        [self showMsg:@"文字不能为空"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确认提交回复？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 400;
    [alert show];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.delegate = self;
    mainSC.backgroundColor =[UIColor whiteColor];
    mainSC.contentSize = CGSizeMake(WIDTH, 390);
    [self.view addSubview:mainSC];
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 15, 150, 20) title:@"语音" font:14];
    tishi1.textColor = [UIColor lightGrayColor];
    [mainSC addSubview:tishi1];
    
    voiceBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH-200)/2, 35, 200, 50) bgImageName:@"15@2x" imageName:nil title:nil selector:nil target:self];
    [mainSC addSubview:voiceBtn];
    
    [voiceBtn addTarget:self action:@selector(voiceClick) forControlEvents:UIControlEventTouchDown];
    [voiceBtn addTarget:self action:@selector(voiceStop) forControlEvents:UIControlEventTouchUpInside];
    [voiceBtn addTarget:self action:@selector(voiceStop) forControlEvents:UIControlEventTouchDragExit];
    
    voiceBtnView = [[VoiceBtnView alloc]initWithFrame:CGRectMake((WIDTH-260)/2, 35, 260, 50)];
    voiceBtnView.myBlock = ^(VoiceBtnView *myView)
    {
        ifHasVoice = NO;
        voiceBtn.hidden = NO;
        voiceBtnView.hidden = YES;
    };
    voiceBtnView.hidden = YES;
    [mainSC addSubview:voiceBtnView];
    
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake((voiceBtn.frame.size.width-140)/2, 0, 140, 50) title:@"按住说话" font:15];
    tishi2.textAlignment = NSTextAlignmentCenter;
    tishi2.textColor = [UIColor whiteColor];
    [voiceBtn addSubview:tishi2];
    
    UIView *line1 = [MyControll createLineWithFrame:CGRectMake(20, 95, WIDTH-40, 1) withColor:[UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f]];
    [mainSC addSubview:line1];
    
    
    UILabel *tishi3 = [MyControll createLabelWithFrame:CGRectMake(20, 110, 150, 20) title:@"文字" font:14];
    tishi3.textColor = [UIColor lightGrayColor];
    [mainSC addSubview:tishi3];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 140, WIDTH-40, 80)];
    textView.text = @"";
    textView.font = [UIFont systemFontOfSize:16];
    [mainSC addSubview:textView];
    
    UIView *line2 = [MyControll createLineWithFrame:CGRectMake(20, 230, WIDTH-40, 1) withColor:[UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f]];
    [mainSC addSubview:line2];
    
    
    UILabel *tishi4 = [MyControll createLabelWithFrame:CGRectMake(20, 245, 150, 20) title:@"图片" font:14];
    tishi4.textColor = [UIColor lightGrayColor];
    [mainSC addSubview:tishi4];
    
    picView = [[UIView alloc]initWithFrame:CGRectMake(0, 275, WIDTH, 90)];
    [mainSC addSubview:picView];
    
    UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20, 10, 70, 70) bgImageName:@"22@2x" imageName:nil title:nil selector:@selector(addPicClick) target:self];
    [picView addSubview:addPic];
    
}
-(void)voiceClick
{
    [self.view endEditing:YES];
    record = [MyRecord sharedInstance];
    [record startRecord];
    [self showVoiceLoadingView];
}
-(void)goToNext
{
    ifHasVoice = YES;
    voiceBtn.hidden = YES;
    voiceBtnView.voiceLength =timeLength;
    [voiceBtnView passData];
    voiceBtnView.filePath = record.recordPath;
    voiceBtnView.hidden = NO;
}
-(void)voiceStop
{
    [record stopRecord];
    timeLength = record.voiceLength;
    if (timeLength<1.0) {
        [self showMsg:@"录音太短"];
        [self hideVoiceLoadingView];
        return;
    }
    [self hideVoiceLoadingView];
    //    [record playAudio:voicePath];
    
    [self performSelector:@selector(goToNext) withObject:nil afterDelay:0.2];
}
-(void)addPicClick
{
    [self.view endEditing:YES];
    if (self.uploadPicArray.count>=8) {
        [self showMsg:@"图片最多选择8张"];
        return;
    }
    PicSelectView *picSelectView = [[PicSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    picSelectView.tag = 203;
    picSelectView.delegate = self;
    picSelectView.maxCount = 8-(int)self.uploadPicArray.count;
    [self.tabBarController.view addSubview:picSelectView];
    [picSelectView makeUI];
}
-(void)picSelect:(PicSelectView *)picSelectView1 Camera:(NSString *)filePath Album:(NSMutableArray *)array Flag:(int)flag
{
    if (flag == 1) {
        [self.uploadPicArray addObject:filePath];
        [self refreshUI];
    }
    else if (flag == 2)
    {
        [self.uploadPicArray addObjectsFromArray:array];
        [self refreshUI];
    }
}
-(void)refreshUI
{
    for (UIView *view in picView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat picWidth = (WIDTH-40-30)/4;
    for (int i=0; i<self.uploadPicArray.count+1; i++) {
        if (i<self.uploadPicArray.count) {
            UIImageView *tempImageView = [MyControll createImageViewWithFrame:CGRectMake(20+(picWidth+10)*(i%4),10+ i/4*(picWidth+10), picWidth, picWidth) imageName:nil];
            tempImageView.image = [UIImage imageWithContentsOfFile:self.uploadPicArray[i]];
            [tempImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            tempImageView.tag = 300+i;
            tempImageView.contentMode = UIViewContentModeScaleAspectFill;
            tempImageView.clipsToBounds = YES;
            [picView addSubview:tempImageView];
        }
        else if(i != 8)
        {
            UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20+(picWidth+10)*(i%4),10+ i/4*(picWidth+10), picWidth, picWidth) bgImageName:@"22@2x" imageName:nil title:nil selector:@selector(addPicClick) target:self];
            [picView addSubview:addPic];
        }
    }
    if (self.uploadPicArray.count < 8) {
        CGFloat picHeight = 0;
        if ((self.uploadPicArray.count+1)%4!=0) {
            picHeight = ((self.uploadPicArray.count+1)/4+1)*(picWidth + 10);
        }
        else
        {
            picHeight = ((self.uploadPicArray.count+1)/4)*(picWidth + 10);
        }
        picView.frame = CGRectMake(0, 275, WIDTH, picHeight+20);
        mainSC.contentSize  = CGSizeMake(WIDTH, picView.frame.origin.y+picView.frame.size.height+25);
    }
    else
    {
        CGFloat picHeight = 0;
        if (self.uploadPicArray.count%4!=0) {
            picHeight = (self.uploadPicArray.count/4+1)*(picWidth + 10);
        }
        else
        {
            picHeight = (self.uploadPicArray.count/4)*(picWidth + 10);
        }
        picView.frame = CGRectMake(0, 275, WIDTH, picHeight+20);
        mainSC.contentSize  = CGSizeMake(WIDTH, picView.frame.origin.y+picView.frame.size.height+25);
    }
}
-(void)longPress:(UIGestureRecognizer *)sender
{
    deletePicNum = (int)sender.view.tag-300;
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你打算删除改图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 401;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 401) {
        if (buttonIndex == 1) {
            [self.uploadPicArray removeObjectAtIndex:deletePicNum];
            [self refreshUI];
        }
    }
    else if (alertView.tag == 400)
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uid = [user objectForKey:@"uid"];
        NSString *token = [user objectForKey:@"token"];
        if (!uid||!token) {
            [self showMsg:@"你先登录"];
            return;
        }
        if (textView.text.length==0) {
            [self showMsg:@"输入文字不能为空"];
            return;
        }
        NSString *url = [NSString stringWithFormat:@"%@replayinfo",SERVER_URL];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setObject:uid forKey:@"uid"];
        [dict setObject:token forKey:@"token"];
        [dict setObject:textView.text forKey:@"text"];
        [dict setObject:_detailID forKey:@"id"];
        [dict setObject:_rid forKey:@"rid"];
        
        NSLog(@"%@~~~%@",url,dict);
        __weak typeof(self) weakSelf=self;
        _sfManager = [ServerFetcherManager sharedServerManager];
        [self StartLoading];
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        if (self.uploadPicArray.count>0) {
            for (int i = 0; i<self.uploadPicArray.count; i++) {
                [dic setObject:self.uploadPicArray[i] forKey:[NSString stringWithFormat:@"file[%d]",i]];
            }
        }
        
        NSLog(@"picDic%@ ~%@",dic,record.recordPath);
        if (ifHasVoice) {
            [dict setObject:[NSString stringWithFormat:@"%f",(float)timeLength] forKey:@"videosec"];
            [_sfManager addUploadTaskWithUrl:url normalParam:dict images:dic voices:@{@"video":record.recordPath} completion:^(BOOL isSuccess, NSData *data) {
                if (isSuccess) {
                    [weakSelf StopLoading];
                    if (data && data.length>0) {
                        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        if ([[info[@"code"] stringValue]isEqualToString:@"1"]) {
                            [weakSelf showMsg:@"回复成功"];
                             [[NSNotificationCenter defaultCenter]postNotificationName:REPLYREFFRESH object:nil];
                            [weakSelf performSelector:@selector(doSomething) withObject:nil afterDelay:1];
                        }
                        else
                        {
                            [weakSelf showMsg:[NSString stringWithFormat:@"%@",info[@"message"]]];
                        }
                        
                    }
                }
                else
                {
                    [weakSelf StopLoading];
                    [weakSelf showMsg:@"请检查你的网络"];
                }
            }];
            
        }
        else
        {
            [_sfManager addUploadTaskWithUrl:url normalParam:dict images:dic voices:nil completion:^(BOOL isSuccess, NSData *data) {
                if (isSuccess) {
                    [weakSelf StopLoading];
                    if (data && data.length>0) {
                        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        if ([[info[@"code"] stringValue]isEqualToString:@"1"]) {
                            [weakSelf showMsg:@"回复成功"];
                            [weakSelf performSelector:@selector(doSomething) withObject:nil afterDelay:1];
                        }
                        else
                        {
                            [weakSelf showMsg:[NSString stringWithFormat:@"%@",info[@"message"]]];
                        }
                        
                    }
                }
                else
                {
                    [weakSelf StopLoading];
                    [weakSelf showMsg:@"请检查你的网络"];
                }
            }];
            
        }
        
    }
    
}
-(void)doSomething
{
    [self GoBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

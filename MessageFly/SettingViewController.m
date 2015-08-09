//
//  SettingViewController.m
//  MessageFly
//
//  Created by xll on 15/2/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SettingViewController.h"
#import "PhoneNumChangeViewController.h"
#import "ChangePWDViewController.h"
#import "AboutUSViewController.h"
#import "FeedBackViewController.h"
#import "AppDelegate.h"
@interface SettingViewController ()
{
    UIScrollView *mainSC;
    
    UISwitch *messageSwitch;
    UISwitch *voiceSwitch;
    UISwitch *shakeSwitch;
    
    UILabel *cacheLabel;
    UIView *secView;
    UIView *thirdView;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"设置" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 470);
    [self.view addSubview:mainSC];
    UIView *firstView = [MyControll createToolViewWithFrame:CGRectMake(0, 15, WIDTH, 100) withColor:[UIColor whiteColor] withNameArray:@[@"修改手机号",@"修改密码"]];
    [mainSC addSubview:firstView];
    
    secView = [MyControll createToolView4WithFrame:CGRectMake(0, 130, WIDTH, 150) withColor:[UIColor whiteColor] withNameArray:@[@"接收推送消息",@"声音提醒",@"震动提醒"]];
    [mainSC addSubview:secView];
  
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *ifMessageOn = [user objectForKey:@"messagestate"];
//    NSString *ifVoiceOn = [user objectForKey:@"voicestate"];
//    NSString *ifShakeOn = [user objectForKey:@"shakestate"];
    messageSwitch  = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH-70, 10, 60, 40)];
    [messageSwitch addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventValueChanged];
    [secView addSubview:messageSwitch];
    voiceSwitch  = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH-70, 60, 60, 40)];
    [voiceSwitch addTarget:self action:@selector(voiceClick:) forControlEvents:UIControlEventValueChanged];
    [secView addSubview:voiceSwitch];
    shakeSwitch  = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH-70, 110, 60, 40)];
    [shakeSwitch addTarget:self action:@selector(shakeClick:) forControlEvents:UIControlEventValueChanged];
    [secView addSubview:shakeSwitch];
    
    
    
    thirdView = [MyControll createToolViewWithFrame:CGRectMake(0, 295, WIDTH, 150) withColor:[UIColor whiteColor] withNameArray:@[@"清除缓存",@"关于我们",@"意见反馈"]];
    [mainSC addSubview:thirdView];
    
    [self refreshOther:1];
    
    float size  =[self folderSizeAtPath:[self getCacheFilePath]];
    
    cacheLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2, 10, WIDTH/2-40, 30) title:[NSString stringWithFormat:@"%.1fMB",size] font:15];
    cacheLabel.textAlignment = NSTextAlignmentRight;
    cacheLabel.textColor = [UIColor colorWithRed:0.64f green:0.64f blue:0.64f alpha:1.00f];
    [thirdView addSubview:cacheLabel];
    
    
    for (int i = 0; i<2; i++) {
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, 50*i, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(firstViewClick:) target:self];
        btn.tag = 100+i;
        [firstView addSubview:btn];
    }
    
    for (int i = 0; i<3; i++) {
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0,50*i, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(thirdViewClick:) target:self];
        btn.tag = 200+i;
        [thirdView addSubview:btn];
    }
}
-(void)refreshOther:(int)type
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *ifMessageOn = [user objectForKey:@"messagestate"];
    NSString *ifVoiceOn = [user objectForKey:@"voicestate"];
    NSString *ifShakeOn = [user objectForKey:@"shakestate"];
    
    if (!ifMessageOn||[ifMessageOn isEqualToString:@"1"]) {
        if (type == 1) {
            secView.frame = CGRectMake(0, 130, WIDTH, 150);
            thirdView.frame = CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+15, WIDTH, 150);
            mainSC.contentSize = CGSizeMake(WIDTH, 470);
            voiceSwitch.hidden = NO;
            shakeSwitch.hidden = NO;
        }
       else
       {
           [UIView animateWithDuration:0.3 animations:^{
               secView.frame = CGRectMake(0, 130, WIDTH, 150);
               thirdView.frame = CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+15, WIDTH, 150);
               mainSC.contentSize = CGSizeMake(WIDTH, 470);
               voiceSwitch.hidden = NO;
               shakeSwitch.hidden = NO;
           }];
       }
        messageSwitch.on = YES;
        voiceSwitch.enabled = YES;
        shakeSwitch.enabled = YES;
        if (!ifVoiceOn||[ifVoiceOn isEqualToString:@"1"]) {
            voiceSwitch.on = YES;
        }
        else if([ifVoiceOn isEqualToString:@"0"])
        {
            voiceSwitch.on = NO;
        }
        
        if (!ifShakeOn||[ifShakeOn isEqualToString:@"1"]) {
            shakeSwitch.on = YES;
        }
        else if([ifShakeOn isEqualToString:@"0"])
        {
            shakeSwitch.on = NO;
        }
    }
    else if([ifMessageOn isEqualToString:@"0"])
    {
        messageSwitch.on = NO;
        voiceSwitch.on = NO;
        shakeSwitch.on = NO;
        voiceSwitch.enabled = NO;
        shakeSwitch.enabled = NO;
        if (type == 1) {
                secView.frame = CGRectMake(0, 130, WIDTH, 49);
                thirdView.frame = CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+15, WIDTH, 150);
                mainSC.contentSize = CGSizeMake(WIDTH, 470-100);
                voiceSwitch.hidden = YES;
                shakeSwitch.hidden = YES;
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                secView.frame = CGRectMake(0, 130, WIDTH, 49);
                thirdView.frame = CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+15, WIDTH, 150);
                mainSC.contentSize = CGSizeMake(WIDTH, 470-100);
                voiceSwitch.hidden = YES;
                shakeSwitch.hidden = YES;
            }];
        }
        
    }
}
-(void)messageClick:(UISwitch *)sender
{
    NSUserDefaults  *user = [NSUserDefaults standardUserDefaults];
    if (sender.on) {
        [user setObject:@"1" forKey:@"messagestate"];
        UIApplication *app =   [UIApplication sharedApplication];
        AppDelegate *appdele = (AppDelegate *)app.delegate;
        [appdele registPush:appdele.launchDic];
    }
    else
    {
        [user setObject:@"0" forKey:@"messagestate"];
         UIApplication *app =   [UIApplication sharedApplication];
        [app unregisterForRemoteNotifications];
    }
    [user synchronize];
    [self refreshOther:0];
    
}
-(void)voiceClick:(UISwitch *)sender
{
    NSUserDefaults  *user = [NSUserDefaults standardUserDefaults];
    if (sender.on) {
        [user setObject:@"1" forKey:@"voicestate"];
    }
    else
    {
        [user setObject:@"0" forKey:@"voicestate"];
    }
    [user synchronize];
    [self refreshOther:0];
}
-(void)shakeClick:(UISwitch *)sender
{
    NSUserDefaults  *user = [NSUserDefaults standardUserDefaults];
    if (sender.on) {
        [user setObject:@"1" forKey:@"shakestate"];
    }
    else
    {
        [user setObject:@"0" forKey:@"shakestate"];
    }
    [user synchronize];
    [self refreshOther:0];
}
-(void)firstViewClick:(UIButton *)sender
{
    int index =(int)sender.tag-100;
    if (index == 0) {
        PhoneNumChangeViewController *vc = [[PhoneNumChangeViewController alloc]init];
        vc.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 1)
    {
        ChangePWDViewController *vc = [[ChangePWDViewController alloc]init];
        vc.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)thirdViewClick:(UIButton *)sender
{
    int index =(int)sender.tag-200;
    if (index == 0)
    {
        [self StartLoading];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        filePath = [filePath stringByAppendingPathComponent:@"myCaches"];
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:filePath error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[filePath stringByAppendingPathComponent:filename] error:NULL];
        }
        [self StopLoading];
        cacheLabel.text = @"0.0MB";
    }
    else  if (index == 1) {
        AboutUSViewController *vc = [[AboutUSViewController alloc]init];
        vc.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 2)
    {
        FeedBackViewController *vc = [[FeedBackViewController alloc]init];
        vc.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (float)folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (long long)fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (NSString *)getCacheFilePath
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
    return filePath;
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

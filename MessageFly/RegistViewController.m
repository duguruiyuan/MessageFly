//
//  RegistViewController.m
//  MessageFly
//
//  Created by xll on 15/2/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "RegistViewController.h"
#import "GetCheckMaView.h"
#import "RegistNextViewController.h"
#import "RegexKitLite.h"
@interface RegistViewController ()<GetCheckDelegate>
{
    UIScrollView *mainSC;
    UITextField *phoneTX;
    UITextField *checkMaTX;
    UITextField *passWDTX;
    UITextField *confirmTX;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)GetCheckMaView *getCheckView;
@end

@implementation RegistViewController
@synthesize getCheckView;
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"注册" font:20];
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
    mainSC.contentSize = CGSizeMake(WIDTH, 290);
    [self.view addSubview:mainSC];
    UIView *firstView = [MyControll createToolView4WithFrame:CGRectMake(0, 15, WIDTH, 200) withColor:[UIColor whiteColor] withNameArray:@[@"手机号",@"验证码",@"密码",@"确认密码"]];
    [mainSC addSubview:firstView];
    
    phoneTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+30, 10, WIDTH/5*4-50, 30) text:nil placehold:@"输入手机号" font:15];
    phoneTX.keyboardType =UIKeyboardTypeNumberPad;
    [firstView addSubview:phoneTX];
    
    checkMaTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+30, 60, WIDTH/5*4-30 -110, 30) text:nil placehold:@"输入验证码" font:15];
    checkMaTX.keyboardType =UIKeyboardTypeNumberPad;
    [firstView addSubview:checkMaTX];
    
    
    getCheckView = [[GetCheckMaView alloc] initWithFrame:CGRectMake(WIDTH-100, 50, 90, 50)];
    getCheckView.delegate = self;
    [firstView addSubview:getCheckView];
    
    passWDTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+30, 110, WIDTH/5*4-50, 30) text:nil placehold:@"输入密码" font:15];
    passWDTX.secureTextEntry = YES;
    [firstView addSubview:passWDTX];
    
    confirmTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+30, 160, WIDTH/5*4-50, 30) text:nil placehold:@"输入确认密码" font:15];
    confirmTX.secureTextEntry = YES;
    [firstView addSubview:confirmTX];
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 235, 260, 40) bgImageName:nil imageName:@"l1@2x" title:nil selector:@selector(commit) target:self];
    [mainSC addSubview:commit];
}
-(void)getCheckMa
{
    
    if (![self checkPassWD:phoneTX.text]) {
        [self showMsg:@"手机号码格式不正确"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@sendcode?mobile=%@&type=1",SERVER_URL,phoneTX.text];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            if (data && data.length>0) {
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [weakSelf showMsg:info[@"message"]];
                if ([[info[@"code"] stringValue] isEqualToString:@"1"]) {
                    
                }
                else
                {
                    [weakSelf.getCheckView stopClock];
                }
            }
            
        }
        else
        {
            [weakSelf showMsg:@"请检查你的网络"];
        }
    }];
}
-(void)commit
{
    [self goTonextPage];
    return;
    if (![self checkphone:phoneTX.text]) {
        [self showMsg:@"手机号码格式不正确"];
        return;
    }
    else if (checkMaTX.text.length ==0)
    {
        [self showMsg:@"验证码不能为空"];
        return;
    }
    else if(![self checkPassWD:passWDTX.text])
    {
        [self showMsg:@"密码格式不正确"];
        return;
    }
    else if (![passWDTX.text isEqualToString:confirmTX.text])
    {
        [self showMsg:@"密码不一致"];
        return;
    }
    [self checkCheckMa];
}
#pragma mark  获取验证码
-(void)buttonClick
{
    if (![self checkphone:phoneTX.text]) {
        [self showMsg:@"手机号码格式不正确"];
        return;
    }
    [getCheckView startCheck];
}
-(void)checkCheckMa
{
    NSString *url = [NSString stringWithFormat:@"%@rightcode?mobile=%@&code=%@",SERVER_URL,phoneTX.text,checkMaTX.text];
    
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [self StartLoading];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf StopLoading];
            if (data && data.length>0) {
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([[info[@"code"] stringValue]isEqualToString:@"1"]) {
                    [weakSelf goTonextPage];
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
-(void)goTonextPage
{
    RegistNextViewController *vc = [[RegistNextViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.phoneNum = phoneTX.text;
    vc.password = passWDTX.text;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  验证格式是否正确
-(BOOL)checkphone:(NSString *)passwd
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278]|7[7])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    if ([passwd isMatchedByRegex:MOBILE]) {
        return YES;
    }
    else if([passwd isMatchedByRegex:CM])
    {
        return YES;
    }
    else if ([passwd isMatchedByRegex:CU])
    {
        return YES;
    }
    return NO;
}
-(BOOL)checkPassWD:(NSString *)passwd
{
    NSString * regexString = @"^[a-zA-Z0-9]{6,20}+$";
    BOOL isYes = [passwd isMatchedByRegex:regexString];
    return isYes;
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

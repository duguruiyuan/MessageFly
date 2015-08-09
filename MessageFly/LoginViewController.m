//
//  LoginViewController.m
//  MessageFly
//
//  Created by xll on 15/2/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "RegexKitLite.h"
#import "ForgetPWDViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UIScrollView *mainSC;
    UITextField *phoneTX;
    UITextField *passWDTX;
}
@property(nonatomic,strong)NSString * phoneNum;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"uid"];
    [user removeObjectForKey:@"token"];
    [user removeObjectForKey:@"flag"];
    [user synchronize];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"登录" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
}
//-(void)GoBack
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 320);
    [self.view addSubview:mainSC];
    UIView *firstView = [MyControll createToolView4WithFrame:CGRectMake(0, 15, WIDTH, 100) withColor:[UIColor whiteColor] withNameArray:@[@"手机号",@"密码"]];
    [mainSC addSubview:firstView];
    
    phoneTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+30, 10, WIDTH/5*4-50, 30) text:nil placehold:@"输入新手机号" font:15];
//    phoneTX.textAlignment = NSTextAlignmentRight;
    phoneTX.keyboardType =UIKeyboardTypeNumberPad;
    [firstView addSubview:phoneTX];
    
    passWDTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+30, 60, WIDTH/5*4-50, 30) text:nil placehold:@"输入密码" font:15];
//    passWDTX.textAlignment = NSTextAlignmentRight;
    passWDTX.secureTextEntry = YES;
    passWDTX.delegate = self;
    passWDTX.returnKeyType = UIReturnKeyGo;
    [firstView addSubview:passWDTX];
    
    
    UIButton *forgetPWD = [MyControll createButtonWithFrame:CGRectMake(WIDTH-100, 125, 80, 40) bgImageName:nil imageName:nil title:@"忘记密码?" selector:@selector(forgetClick) target:self];
    forgetPWD.titleLabel.font = [UIFont systemFontOfSize:14];
    [mainSC addSubview:forgetPWD];
    
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 185, 260, 40) bgImageName:nil imageName:@"l3@2x" title:nil selector:@selector(commit) target:self];
    [mainSC addSubview:commit];
    
    UIButton *registBtn =[MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 245, 260, 40) bgImageName:nil imageName:@"l4@2x" title:nil selector:@selector(registClick) target:self];
    [mainSC addSubview:registBtn];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self commit];
    [self.view endEditing:YES];
    return YES;
}
-(void)forgetClick
{
    ForgetPWDViewController *vc = [[ForgetPWDViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)commit
{
     [self.view endEditing:YES];
    if (phoneTX.text.length==0) {
        [self showMsg:@"电话号码不能为空"];
        return;
    }
    else if (![self checkphone:phoneTX.text])
    {
        [self showMsg:@"电话号码格式不正确"];
        return;
    }
    [self login];
}
-(void)registClick
{
    RegistViewController *vc = [[RegistViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)login
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken  =  [user objectForKey:@"deviceToken"];
    NSString *url = [NSString stringWithFormat:@"%@login?mobile=%@&pwd=%@&devicetoken=%@",SERVER_URL,phoneTX.text,passWDTX.text,deviceToken];
    _phoneNum = phoneTX.text ;
    
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [self StartLoading];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf StopLoading];
            if (data && data.length>0) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    
                    [user setObject:dict[@"token"] forKey:@"token"];
                    [user setObject:weakSelf.phoneNum forKey:@"mobile"];
                    [user setObject:dict[@"uid"] forKey:@"uid"];
                    [user setObject:dict[@"list"][@"rname"] forKey:@"name"];
                    [user setObject:dict[@"flag"] forKey:@"flag"];
                    [user setObject:dict[@"list"][@"icnum"] forKey:@"icnum"];
                    [user setObject:dict[@"list"][@"image"] forKey:@"image"];
                    [user setObject:dict[@"list"][@"rface"] forKey:@"face"];
                    [user synchronize];
                    [[NSNotificationCenter defaultCenter]postNotificationName:ORDERDEAL object:nil];
                     [[NSNotificationCenter defaultCenter]postNotificationName:MyQRELOADVC object:nil];
                     [[NSNotificationCenter defaultCenter]postNotificationName:PressRELOADVC object:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:CHANGEUSER object:nil];
                    [weakSelf.navigationController popViewControllerAnimated:NO];
                    
                }
                else
                {
                    [weakSelf showMsg:[NSString stringWithFormat:@"%@",dict[@"message"]]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

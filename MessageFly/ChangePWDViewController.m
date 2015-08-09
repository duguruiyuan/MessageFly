//
//  ChangePWDViewController.m
//  MessageFly
//
//  Created by xll on 15/2/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ChangePWDViewController.h"
#import "RegexKitLite.h"
@interface ChangePWDViewController ()
{
    UIScrollView *mainSC;
    UITextField *oldPWDTX;;
    UITextField *newOldPWD;
    UITextField *checkPWD;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation ChangePWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"修改密码" font:20];
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
    mainSC.contentSize = CGSizeMake(WIDTH, 270);
    [self.view addSubview:mainSC];
    UIView *firstView = [MyControll createToolView4WithFrame:CGRectMake(0, 15, WIDTH, 150) withColor:[UIColor whiteColor] withNameArray:@[@"原  密  码：",@"新  密  码：",@"确认新密码："]];
    [mainSC addSubview:firstView];
    
    oldPWDTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 10, WIDTH/5*4-60, 30) text:nil placehold:@"请输入原密码" font:15];
    [firstView addSubview:oldPWDTX];
    
    newOldPWD = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 60, WIDTH/5*4-60, 30) text:nil placehold:@"请输入新密码" font:15];
    [firstView addSubview:newOldPWD];
    
    checkPWD = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 110, WIDTH/5*4-60, 30) text:nil placehold:@"请再次输入新密码" font:15];
    [firstView addSubview:checkPWD];
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 205, 260, 40) bgImageName:nil imageName:@"m23@2x" title:nil selector:@selector(commit) target:self];
    [mainSC addSubview:commit];
}
-(void)commit
{
    
    if (oldPWDTX.text.length==0) {
        [self showMsg:@"旧密码不能为空"];
        return;
    }
    if (![self checkPassWD:newOldPWD.text]) {
        [self showMsg:@"新密码格式不正确"];
        return;
    }
    if (![newOldPWD.text isEqualToString:checkPWD.text]) {
        [self showMsg:@"密码不一致"];
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"%@pwdiftrue?uid=%@&token=%@&pwd=%@",SERVER_URL,uid,token,oldPWDTX.text];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf doSomething];
            if (data && data.length>0) {
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([[info[@"code"] stringValue] isEqualToString:@"1"]) {
                    [weakSelf startChangePwd];
                }
                else
                {
                  [weakSelf showMsg:info[@"message"]];
                }
            }
            
        }
        else
        {
             [weakSelf doSomething];
            [weakSelf showMsg:@"请检查你的网络"];
        }
    }];

}
-(void)startChangePwd
{
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"%@updatepwd?uid=%@&token=%@&pwd=%@",SERVER_URL,uid,token,newOldPWD.text];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
             [weakSelf doSomething];
            if (data && data.length>0) {
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([[info[@"code"] stringValue] isEqualToString:@"1"]) {
                    [weakSelf showMsg:@"修改密码成功"];
                    [weakSelf performSelector:@selector(GoBack) withObject:nil afterDelay:1];
                }
                else
                {
                    [weakSelf showMsg:info[@"message"]];
                }
            }
            
        }
        else
        {
            
             [weakSelf doSomething];
            [weakSelf showMsg:@"请检查你的网络"];
        }
    }];
}
-(void)doSomething
{
    [self StopLoading];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

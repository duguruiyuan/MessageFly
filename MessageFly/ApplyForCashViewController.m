//
//  ApplyForCashViewController.m
//  MessageFly
//
//  Created by xll on 15/2/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ApplyForCashViewController.h"
#import "RealNameViewController.h"
@interface ApplyForCashViewController ()<UIAlertViewDelegate>
{
    UIScrollView *mainSC;
    UITextField *moneyTX;
    UIView *secView;
    int chargeType;
    
    UIView *aipayView;
    UIView *yinlianView;
    
    UITextField *aiTextField;
    
    UITextField *cardTX;
    UITextField *bankTX;
    UITextField *nameTX;
    
    UIButton *commit;
    
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation ApplyForCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    chargeType = 1;
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"申请提现" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    [self makeUI];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    [self.view addSubview:mainSC];
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 50)];
    firstView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:firstView];
    
    moneyTX = [MyControll createTextFieldWithFrame:CGRectMake(20, 10, WIDTH-40, 30) text:nil placehold:@"请输入提现金额" font:16];
    moneyTX.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [firstView addSubview:moneyTX];
    
    UIImageView *infoImageView = [MyControll createImageViewWithFrame:CGRectMake(20, 85, 16, 20) imageName:@"m21@2x"];
    infoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [mainSC addSubview:infoImageView];
    
    
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(40, 85, WIDTH-60, 20) title:nil font:15];
    [mainSC addSubview:tishi1];
    tishi1.text = [NSString stringWithFormat:@"当前余额:%.2f元，冻结金额:%.2f元",[_myCount floatValue],[_frozenMoney floatValue]];
    CGSize size = [MyControll getSize:tishi1.text Font:15 Width:WIDTH-60 Height:100];
    tishi1.frame = CGRectMake(40, 85, WIDTH-60, size.height+10);
    
 
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle};
    tishi1.attributedText = [[NSAttributedString alloc]initWithString:tishi1.text attributes:attributes];
    
    
    UILabel *tis = [MyControll createLabelWithFrame:CGRectMake(40, CGRectGetMaxY(tishi1.frame), WIDTH-60, 20) title:nil font:15];
    [mainSC addSubview:tis];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"可用余额:"]];
    NSAttributedString *moneyStr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",[_leftMoney floatValue]] attributes: @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.93f green:0.29f blue:0.14f alpha:1.00f]}];
    NSAttributedString *yuan = [[NSAttributedString alloc]initWithString:@"元"];
    [str  appendAttributedString:moneyStr];
    [str appendAttributedString:yuan];
    tis.attributedText = str;
    
    secView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tis.frame)+15, WIDTH, 250)];
    secView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:secView];
    
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 30) title:@"通过以下方式提现" font:16];
    [secView addSubview:tishi2];
    
    UIView *line = [MyControll createLineWithFrame:CGRectMake(0, 50, WIDTH, 1) withColor:[UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f]];
    [secView addSubview:line];
    
    
    float distance = ((WIDTH-160)-80);
    
    NSArray *iconArray = @[@"m10@2x",@"m12@2x"];
    NSArray *nameArray  =@[@"支付宝",@"银行卡"];
    for (int i = 0; i<2; i++) {
        UIImageView *iconView = [MyControll createImageViewWithFrame:CGRectMake(40+(80+distance)*i, 80, 80, 80) imageName:iconArray[i]];
        [secView addSubview:iconView];
        
        UILabel *nameLabel = [MyControll createLabelWithFrame:CGRectMake(40+(80+distance)*i, 180, 80, 20) title:nameArray[i] font:16];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor lightGrayColor];
        [secView addSubview:nameLabel];
        
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(40+(80+distance)*i, 200, 80, 40) bgImageName:nil imageName:@"m14" title:nil selector:@selector(selectClick:) target:self];
        [btn setImage:[UIImage imageNamed:@"m13"] forState:UIControlStateSelected];
        if (i==0) {
            btn.selected = YES;
        }
        btn.tag = 100+i;
        [secView addSubview:btn];
    }

    aipayView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(secView.frame)+20, WIDTH, 60)];
    aipayView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:aipayView];
    
    UILabel *t = [MyControll createLabelWithFrame:CGRectMake(20, 10, 60, 40) title:@"支付宝" font:16];
    [aipayView addSubview:t];
    
    aiTextField = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, WIDTH-100, 40)];
    aiTextField.placeholder = @"支付宝账户";
    aiTextField.font = [UIFont systemFontOfSize:16];
    [aipayView addSubview:aiTextField];
    
    
    yinlianView = [MyControll createToolView5WithFrame:CGRectMake(0, CGRectGetMaxY(secView.frame)+20, WIDTH, 150) withColor:[UIColor whiteColor] withNameArray:@[@"卡号",@"开户行",@"持卡人姓名"] withFont:16];
    yinlianView.hidden = YES;
    [mainSC addSubview:yinlianView];
    
    cardTX = [MyControll createTextFieldWithFrame:CGRectMake(110, 10, WIDTH-120, 30) text:nil placehold:@"请输入卡号" font:16];
    cardTX.keyboardType = UIKeyboardTypeNumberPad;
    [yinlianView addSubview:cardTX];
    
    bankTX = [MyControll createTextFieldWithFrame:CGRectMake(110, 60, WIDTH-120, 30) text:nil placehold:@"请输入开户行" font:16];
    [yinlianView addSubview:bankTX];
    
    nameTX = [MyControll createTextFieldWithFrame:CGRectMake(110, 110, WIDTH-120, 30) text:nil placehold:@"请输入持卡人姓名" font:16];
    [yinlianView addSubview:nameTX];
     
    commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, CGRectGetMaxY(aipayView.frame)+20, 260, 40) bgImageName:nil imageName:@"m20@2x" title:nil selector:@selector(commit) target:self];
    [mainSC addSubview:commit];
    mainSC.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(commit.frame)+30);
        
}
-(void)commit
{
    if (![MyControll checkGeShi:moneyTX.text Regex:@"^[0-9]+(\\.[0-9]+)?$"]) {
        [self showMsg:@"输入金额格式不对"];
        return;
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *flag = [user objectForKey:@"flag"];
    if (!uid||!token) {
        return;
    }
    if (!flag||[flag isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您还没有认证，是否前去认证？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        return;
    }
    else if([flag isEqualToString:@"1"])
    {
        [self showMsg:@"你的认证正在进行中，请等待。。"];
        return;
    }
    else if([flag isEqualToString:@"3"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您的认证有问题，是否前去认证？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
        return;
    }
    NSString *url;
    if (chargeType == 1) {
        if (aiTextField.text.length == 0) {
            [self showMsg:@"支付宝账户不能为空"];
            return;
        }
        NSString *s = [aiTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSString stringWithFormat:@"%@getmoney?uid=%@&token=%@&money=%@&carid=%@&type=%d&name=%@&hang=%@",SERVER_URL,uid,token,moneyTX.text,s,chargeType,@"",@""];
    }
    else
    {
        if (cardTX.text.length == 0) {
            [self showMsg:@"银行卡号不能为空"];
            return;
        }
        else if (nameTX.text.length == 0)
        {
            [self showMsg:@"开户姓名不能为空"];
            return;
        }
        else if (bankTX.text.length == 0)
        {
            [self showMsg:@"开户行不能为空"];
            return;
        }
        NSString *str = [cardTX.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str1 = [nameTX.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str2 = [bankTX.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url = [NSString stringWithFormat:@"%@getmoney?uid=%@&token=%@&money=%@&carid=%@&type=%d&name=%@&hang=%@",SERVER_URL,uid,token,moneyTX.text,str,chargeType,str1,str2];
    }
//    NSString *url = [NSString stringWithFormat:@"%@getmoney?uid=%@&token=%@&money=%@&carid=%@&type=%@&name=%@&hang=%@",SERVER_URL,uid,token,moneyTX.text,@"1"];
    [self StartLoading];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf endSomething];
            
            if (data && data.length>0) {
                id jsonStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([jsonStr isKindOfClass:[NSArray class]]) {
                    
                }
                else
                {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if ([[dict[@"code"] stringValue]isEqualToString:@"1"]) {
                        [weakSelf showMsg:@"提现成功"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:CHARGE object:nil];
                        [weakSelf performSelector:@selector(GoBack) withObject:nil afterDelay:1];
                    }
                    else
                    {
                        [weakSelf showMsg:dict[@"message"]];
                    }
                }
            }
        }
        else
        {
            [weakSelf endSomething];
            [weakSelf showMsg:@"请检查你的网络"];
        }
    }];
    
}
-(void)endSomething
{
    [self StopLoading];
}
-(void)selectClick:(UIButton *)sender
{
    chargeType = (int)sender.tag-100+1;
    for (int i = 0; i<2; i++) {
        UIButton *btn = (UIButton *)[secView viewWithTag:100+i];
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
    if (sender.tag-100 == 0) {
            aipayView.hidden = NO;
            yinlianView.hidden = YES;
            commit.frame =CGRectMake((WIDTH-260)/2, CGRectGetMaxY(aipayView.frame)+20, 260, 40);
             mainSC.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(commit.frame)+30);
    }
    else
    {
            aipayView.hidden = YES;
            yinlianView.hidden = NO;
            commit.frame =CGRectMake((WIDTH-260)/2, CGRectGetMaxY(yinlianView.frame)+20, 260, 40);
            mainSC.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(commit.frame)+30);
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        RealNameViewController *vc = [[RealNameViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
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

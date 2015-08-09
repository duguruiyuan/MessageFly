//
//  ChargeViewController.m
//  MessageFly
//
//  Created by xll on 15/2/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ChargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
@interface ChargeViewController ()
{
    UIScrollView *mainSC;
    UITextField *moneyTX;
    UIView *secView;
    int chargeType;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation ChargeViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"我的账户" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    [self makeUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payFinish) name:wx_PayFinish object:nil];
}
-(void)makeUI
{
    chargeType =1;
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-60)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 425);
    [self.view addSubview:mainSC];
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 50)];
    firstView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:firstView];
    
    moneyTX = [MyControll createTextFieldWithFrame:CGRectMake(20, 10, WIDTH-40, 30) text:nil placehold:@"请输入充值金额" font:16];
    moneyTX.keyboardType = UIKeyboardTypeNumberPad;
    [firstView addSubview:moneyTX];
    
    
    secView = [[UIView alloc]initWithFrame:CGRectMake(0, 90, WIDTH, 250)];
    secView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:secView];
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 30) title:@"通过以下方式支付" font:16];
    [secView addSubview:tishi1];
    
    UIView *line = [MyControll createLineWithFrame:CGRectMake(0, 50, WIDTH, 1) withColor:[UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f]];
    [secView addSubview:line];
    
    
    float distance = ((WIDTH-160)-80);
    
    NSArray *iconArray = @[@"m10@2x",@"m11@2x"];
    NSArray *nameArray  =@[@"支付宝",@"微信支付"];
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
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 360, 260, 40) bgImageName:nil imageName:@"m15@2x" title:nil selector:@selector(commit) target:self];
    [mainSC addSubview:commit];
    
}
-(void)commit
{
    if (moneyTX.text.length==0) {
        [self showMsg:@"充值金额不能为空"];
        return;
    }
    else if ([moneyTX.text integerValue]==0)
    {
        [self showMsg:@"充值金额不能为0"];
        return;
    }
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        return;
    }
    [self StartLoading];
    if (chargeType == 1) {
        NSString *url = [NSString stringWithFormat:@"%@alipay?uid=%@&token=%@",SERVER_URL,uid,token];
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
                        if ([dict[@"out_trade_no"] length]>0) {
                            [weakSelf gotoAliPay:dict[@"out_trade_no"]];
                        }
                        else
                        {
                            [weakSelf showMsg:@"获取订单失败"];
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
    else
    {
        NSString *url = [NSString stringWithFormat:@"%@umpmpay?uid=%@&token=%@&money=%@",SERVER_URL,uid,token,moneyTX.text];
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
                            [[NSNotificationCenter defaultCenter]postNotificationName:wx_sendPay object:dict];
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
}
-(void)endSomething
{
    [self StopLoading];
}
-(void)selectClick:(UIButton *)sender
{
    chargeType = (int)sender.tag-100+1;
    for (int i = 0; i<3; i++) {
        UIButton *btn = (UIButton *)[secView viewWithTag:100+i];
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
}
-(void)payFinish
{
    [[NSNotificationCenter defaultCenter]postNotificationName:CHARGE object:nil];
     [self showMsg:@"充值成功"];
    [self performSelector:@selector(GoBack) withObject:nil afterDelay:1];
}


-(void)gotoAliPay:(NSString *)ordernum
{
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088911486693058";
    NSString *seller = @"18911869230@163.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOA+f55q2gW/NQ25RCNsNOCr+j25riJV6DULD6iIgiiUnX7ZfYCOOal0gXZohisgQGD5+Sr5Nxyc3HvQojMQFcnfVjRntWKbHHbP05qQqRD3kPUh5C9b2+xM6rQBSfAVw08txMGMi+4HCqDHihXBND2ZXzGpwxWvCbuir6lqZOy3AgMBAAECgYAxHv+toBJqN9xTSUYXzFg47vM+GjJ+6vqWw/mGHYEFiqiFZPcM9hrDd/X0Dil1wPbZR2jBdR4RcnsJ1EXzkY5z5SelkdVbymuapmem4S5TV2PgeeB/0SduZXI3O1Ns+4LtkeqmcXAXw1Gyv7AbAE8UqLdXDW7cbB5evJ0efpP/QQJBAPcFdjyxAluuqGGOk8PkadRFbp3dV7RYXLSpnEkDaQZn10E2WRzbBwRWd28T4ALurxe4K8MmMBRGikE8rX+YHq8CQQDoZRgorq5JI/YyT+rAsSu1P4tn+h2ZQvHe2++a+7KpNzbJGhBX5Kp2cdwkjfxjJboFU230xfMIWG8G72XYo1R5AkAPXASVE4CNCNgpcL8ZYBuAemy9XiT07sWc6irwk0i1gEFvKZzy4V+XUnUMsBSuuf6jH+2AreAxco1oLwiutVu7AkEAyFT1iYRjq5s7jU2FEYzpH7pig0SCJW8nL7UqjNCyx9pX+O3l7s6o/6fRXRWk3xdTj2nHHL1TbvtE4paWljTeCQJAG6oNr2Uvg0w+fqVvE3+8OiILfpY7o8e9coqSzcqn7zP8j64b78IRm4Jzk7DUhKz8v5AoLy/h6XIA12WXw3zeYw==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = ordernum; //订单ID（由商家自行制定）
    order.productName = @"信儿快飞充值"; //商品标题
    order.productDescription = @"这是信儿快飞的充值页面,这是信儿快飞的充值页面"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[moneyTX.text floatValue]]; //商品价格
    order.notifyURL =  @"http://202.85.214.88/xiner/web/home/index/notify_url"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
   
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkmessagefly";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"]isEqualToString:@"9000"]) {
                [self payFinish];
            }
            else
            {
                [self showMsg:@"支付失败"];
            }
        }];
        
    }

}
//- (NSString *)generateTradeNO
//{
//    static int kNumber = 15;
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand(time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}
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

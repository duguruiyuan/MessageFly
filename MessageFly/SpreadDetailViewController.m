//
//  SpreadDetailViewController.m
//  MessageFly
//
//  Created by xll on 15/2/10.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SpreadDetailViewController.h"
#import "ShareView.h"
@interface SpreadDetailViewController ()
{
    UIWebView *webView;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@end

@implementation SpreadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"公司动态详情" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(10, 0, 40, 30) bgImageName:nil imageName:@"p21" title:nil selector:@selector(share) target:self];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)share
{
    ShareView *shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, sHEIGHT)];
    shareView.delegate = self;
    [self.tabBarController.view addSubview:shareView];
}
-(void)loadData
{
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"%@topicinfo?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,_tid];
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
                    weakSelf.dataDic = [NSMutableDictionary dictionaryWithDictionary:dict];
                    [weakSelf makeUI];
                }
            }
        }
        else
        {
            [weakSelf endSomething];
        }
    }];

}
-(void)endSomething
{
    [self StopLoading];
}
-(void)makeUI
{
    int time = [self.dataDic[@"time"] intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSString *str = [df stringFromDate:date];
    NSString *content = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">img {width: 100%%}</style></head><body><div style=\"font-size:21px;margin-top:10px\"><span style=\"font-weight:bold\">%@</span></div><div style=\"font-size:16px;color:#888888\"><div>&nbsp&nbsp%@</div>%@/body></html>", self.dataDic[@"title"],str,self.dataDic[@"content"]];
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    webView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [webView loadHTMLString:content baseURL:nil];
    [self.view addSubview:webView];
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

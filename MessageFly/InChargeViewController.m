//
//  InChargeViewController.m
//  MessageFly
//
//  Created by xll on 15/4/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "InChargeViewController.h"

@interface InChargeViewController ()<UIAlertViewDelegate>
{
    UIScrollView *mainSC;
    int chargeType;
    UIView *firstView;
    UITextView *textView;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation InChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    chargeType =1;
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"投诉" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *setBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"提交" selector:@selector(commit) target:self];
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    setBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setBtn];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)commit
{
    if (textView.text.length==0) {
        [self showMsg:@"评论内容不能为空"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要提交投诉吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uid = [user objectForKey:@"uid"];
        NSString *token = [user objectForKey:@"token"];
        if (!uid||!token) {
            return;
        }
        [self StartLoading];
        NSString *str = [textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url = [NSString stringWithFormat:@"%@reportsb?uid=%@&token=%@&text=%@&tid=%@&flag=%d&orderid=%@",SERVER_URL,uid,token,str,_tid,chargeType,_detailID];
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
                            [weakSelf showMsg:@"你的投诉提交成功"];
                            [weakSelf performSelector:@selector(GoBack) withObject:nil afterDelay:1];
                            
                        }
                        else
                        {
                            [weakSelf showMsg:@"你的投诉提交失败"];
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
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 270);
    [self.view addSubview:mainSC];
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(20, 20, WIDTH-40, 20) title:@"请选择投诉原因" font:18];
    tishi.textColor = [UIColor lightGrayColor];
    [mainSC addSubview:tishi];
    
    firstView = [MyControll createToolView2WithFrame:CGRectMake(0, 50, WIDTH, 150) withColor:[UIColor whiteColor] withNameArray:@[@"欺诈骗钱",@"侮辱诋毁",@"广告骚扰"]];
    [mainSC addSubview:firstView];
    
    
    for (int i = 0; i<3; i++) {
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-50, i*50, 50, 50) bgImageName:nil imageName:@"m14" title:nil selector:@selector(btnClick:) target:self];
        btn.tag = 100+i;
        if (i==0) {
            btn.selected = YES;
        }
        [btn setImage:[UIImage imageNamed:@"m13"] forState:UIControlStateSelected];
        [firstView addSubview:btn];
    }
    
    UILabel *tishi1 =[MyControll createLabelWithFrame:CGRectMake(20, 220, WIDTH-40, 20) title:@"补充说明" font:18];
    tishi1.textColor = [UIColor lightGrayColor];
    [mainSC addSubview:tishi1];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 250, WIDTH, 120)];
    bgView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:bgView];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, WIDTH-40, 100)];
    textView.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:textView];
    
}
-(void)btnClick:(UIButton *)sender
{
    chargeType = (int)sender.tag-100+1;
    for (int i = 0; i<3; i++) {
        UIButton *btn = (UIButton *)[firstView viewWithTag:100+i];
        if (btn.tag == sender.tag) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
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

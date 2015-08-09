//
//  FeedBackViewController.m
//  MessageFly
//
//  Created by xll on 15/2/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()<UITextViewDelegate>
{
    UIScrollView *mainSC;
    UITextView *textView;
    UILabel *showWord;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"意见反馈" font:20];
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
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, WIDTH, 150)];
    bgView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:bgView];
    
    
    showWord = [MyControll createLabelWithFrame:CGRectMake(25, 11, 150, 20) title:@"请输入您的建议和反馈" font:15];
    showWord.textColor= [UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f];
    [bgView addSubview:showWord];
    
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 5, WIDTH-40, bgView.frame.size.height-10)];
    textView.delegate = self;
    [textView becomeFirstResponder];
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:textView];
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 190, 260, 40) bgImageName:nil imageName:@"m23@2x" title:nil selector:@selector(commit) target:self];
    [mainSC addSubview:commit];
}
-(void)textViewDidChange:(UITextView *)textView1
{
    if (textView.text.length==0) {
        showWord.hidden = NO;
    }
    else
    {
        showWord.hidden = YES;
    }
}
-(void)commit
{
    if (textView.text.length==0) {
        [self showMsg:@"反馈内容不能为空"];
        return;
    }
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *str = [textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@fankui?uid=%@&token=%@&text=%@",SERVER_URL,uid,token,str];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf doSomething];
            if (data && data.length>0) {
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([[info[@"code"] stringValue] isEqualToString:@"1"]) {
                    [weakSelf showMsg:@"反馈成功"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

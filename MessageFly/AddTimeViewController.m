//
//  AddTimeViewController.m
//  MessageFly
//
//  Created by xll on 15/2/11.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "AddTimeViewController.h"

@interface AddTimeViewController ()
{
    UITextField *timeTX;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation AddTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"延长时间" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
}
-(void)makeUI
{
    UIView *firstView = [MyControll createToolView2WithFrame:CGRectMake(0, 20, WIDTH, 50) withColor:[UIColor whiteColor] withNameArray:@[@"延长时间"]];
    [self.view addSubview:firstView];
    
    UIButton *reduceBtn2 = [MyControll createButtonWithFrame:CGRectMake(WIDTH- 210, 5, 40, 40) bgImageName:nil imageName:@"o9" title:nil selector:@selector(timeClick:) target:self];
    reduceBtn2.tag = 100;
    reduceBtn2.clipsToBounds = YES;
    reduceBtn2.layer.cornerRadius= 3;
    [firstView addSubview:reduceBtn2];
    timeTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH-165, 10, 70, 30) text:@"10" placehold:nil font:15];
    timeTX.textAlignment = NSTextAlignmentCenter;
    timeTX.clipsToBounds = YES;
    timeTX.keyboardType = UIKeyboardTypeNumberPad;
    timeTX.layer.cornerRadius = 5;
    timeTX.layer.borderWidth = 0.5;
    timeTX.layer.borderColor = [[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]CGColor];
    [firstView addSubview:timeTX];
    
    UIButton *addBtn2 =[MyControll createButtonWithFrame:CGRectMake(WIDTH-90, 5, 40, 40) bgImageName:nil imageName:@"o11" title:nil selector:@selector(timeClick:) target:self];
    addBtn2.tag = 101;
    addBtn2.clipsToBounds = YES;
    addBtn2.layer.cornerRadius= 3;
    [firstView addSubview:addBtn2];
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake(WIDTH-45, 5, 40, 40) title:@"小时" font:15];
    [firstView addSubview:tishi2];
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 90, 260, 40) bgImageName:nil imageName:@"m15" title:nil selector:@selector(commit) target:self];
    [self.view addSubview:commit];
}
-(void)timeClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        int moneyNum = [timeTX.text intValue];
        if (moneyNum>1) {
            moneyNum--;
            timeTX.text = [NSString stringWithFormat:@"%d",moneyNum];
        }
        else
        {
            [self showMsg:@"最少延长时间必须为1小时"];
        }
    }
    else if (sender.tag == 101)
    {
        int moneyNum = [timeTX.text intValue];
        moneyNum++;
        timeTX.text = [NSString stringWithFormat:@"%d",moneyNum];
    }

}
-(void)commit
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *url = [NSString stringWithFormat:@"%@pushtime?uid=%@&token=%@&id=%@&time=%@",SERVER_URL,uid,token,_tid,timeTX.text];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf StopLoading];
            if (data && data.length>0) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (dic&&dic.count>0) {
                    if ([[dic[@"code"]stringValue]isEqualToString:@"1"]) {
                        [weakSelf showMsg:@"延长发布时间成功"];
                         [[NSNotificationCenter defaultCenter]postNotificationName:ADDTIME object:nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:PressRELOADVC object:nil];
                        [weakSelf performSelector:@selector(GoBack) withObject:nil afterDelay:1];
                    }
                    else
                    {
                        [weakSelf showMsg:dic[@"message"]];
                    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MyAccountViewController.m
//  MessageFly
//
//  Created by xll on 15/2/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MyAccountViewController.h"
#import "PayListTableViewCell.h"
#import "AcountVIew.h"
@interface MyAccountViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    AcountVIew *accountView;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"我的账户" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:CHARGE object:nil];
}
-(void)makeUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    accountView = [[AcountVIew alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 215)];
    accountView.delegate = self;
    _tableView.tableHeaderView = accountView;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDS"];
    if (!cell) {
        cell = [[PayListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDS"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(void)loadData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        return;
    }
    [self StartLoading];
    NSString *url = [NSString stringWithFormat:@"%@mymoney?uid=%@&token=%@",SERVER_URL,uid,token];
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
                    [weakSelf refreshUI];
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
-(void)refreshUI
{
    [accountView config:self.dataDic];
    NSArray *array = self.dataDic[@"list"];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [_tableView reloadData];
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

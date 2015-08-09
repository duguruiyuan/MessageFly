//
//  MyMessageViewController.m
//  MessageFly
//
//  Created by xll on 15/2/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MessageTableViewCell.h"
#import "LoginViewController.h"
@interface MyMessageViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIAlertViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *_tableView;
@property(nonatomic)int mpage;
@end

@implementation MyMessageViewController
@synthesize _tableView,mpage;
-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"0" forKey:@"ifHaveMessage"];
    [user synchronize];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    mpage =0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"我的消息" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIButton *clearBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"清空" selector:@selector(clearClick) target:self];
    clearBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:clearBtn];
    [self makeUI];
    [self loadData];
}
-(void)clearClick
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定清空全部消息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uid = [user objectForKey:@"uid"];
        NSString *token = [user objectForKey:@"token"];
        [self StartLoading];
        NSString *url = [NSString stringWithFormat:@"%@delmymessage?uid=%@&token=%@",SERVER_URL,uid,token];
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
                        if ([[dict[@"code"]stringValue]isEqualToString:@"1"]) {
                            [weakSelf.dataArray removeAllObjects];
                            [weakSelf._tableView reloadData];
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
            }
        }];

    }
}
-(void)makeUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _tableView;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _tableView;
    _footer.delegate = self;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDS"];
    if (!cell) {
        cell = [[MessageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDS"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic =self.dataArray[indexPath.row];
    CGSize size = [MyControll getSize:dic[@"title"] Font:15 Width:sWIDTH-40 Height:1000];
    return 10+size.height+5+20+10;
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
    NSString *url = [NSString stringWithFormat:@"%@mymessage?uid=%@&token=%@&limit=10&page=%d",SERVER_URL,uid,token,mpage+1];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf endSomething];
            if (data && data.length>0) {
                id jsonStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([jsonStr isKindOfClass:[NSArray class]]) {
                    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if (array&&array.count>0) {
                        if (weakSelf.mpage == 0) {
                            [weakSelf.dataArray removeAllObjects];
                        }
                        [weakSelf.dataArray addObjectsFromArray:array];
                        [weakSelf._tableView reloadData];
                        weakSelf.mpage++;
                    }

                }
                else
                {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [weakSelf showMsg:dict[@"message"]];
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
    [_header endRefreshing];
    [_footer endRefreshing];
}
-(void)dealloc
{
    [_header free];
    [_footer free];
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //如果是下拉刷新
    if(refreshView == _header)
    {
        mpage = 0;
        [self loadData];
    }
    else
    {
        [self loadData];
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

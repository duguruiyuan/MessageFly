//
//  ProfitLeftViewController.m
//  MessageFly
//
//  Created by xll on 15/4/10.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ProfitLeftViewController.h"
#import "ProfitTableViewCell.h"
@interface ProfitLeftViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *_tableView;
@property(nonatomic)int mpage;
@end

@implementation ProfitLeftViewController
@synthesize _tableView,mpage;
- (void)viewDidLoad {
    mpage =0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [super viewDidLoad];
    [self makeUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    _tableView.opaque = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
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
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section][@"list"];
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[ProfitTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *array = self.dataArray[indexPath.section][@"list"];
    [cell config:array[indexPath.row] withType:_type];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = self.dataArray[section];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    bgView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UILabel *label = [MyControll createLabelWithFrame:CGRectMake(20, 0, WIDTH-20, 40) title:dic[@"date"] font:16];
    [bgView addSubview:label];
    return bgView;
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    NSString *url = [NSString stringWithFormat:@"%@mypaylist?uid=%@&token=%@&limit=10&page=%d&type=%d",SERVER_URL,uid,token,mpage+1,_type];
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

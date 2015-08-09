//
//  CompanyTrendViewController.m
//  MessageFly
//
//  Created by xll on 15/4/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "CompanyTrendViewController.h"
#import "SpreadTableViewCell.h"
#import "SpreadDetailViewController.h"
@interface CompanyTrendViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)UITableView *_tableView;
@property(nonatomic)int mpage;
@end

@implementation CompanyTrendViewController
@synthesize mpage,_tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    mpage =0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self makeUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 00, WIDTH, HEIGHT)];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[SpreadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic =self.dataArray[indexPath.row];
    CGSize size = [MyControll getSize:dic[@"text"] Font:15 Width:sWIDTH-40 Height:1000];
    return 10+size.height+5+20+10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpreadDetailViewController *vc = [[SpreadDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tid = self.dataArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loadData
{
    [self StartLoading];
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *uid = [user objectForKey:@"uid"];
//    NSString *token = [user objectForKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"%@topiclist?uid=&token=&limit=10&page=%d",SERVER_URL,mpage+1];
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

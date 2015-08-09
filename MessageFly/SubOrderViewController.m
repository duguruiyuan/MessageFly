//
//  SubOrderViewController.m
//  MessageFly
//
//  Created by xll on 15/4/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SubOrderViewController.h"
#import "NearbyTableViewCell.h"
#import "NearbyDetailNotViewController.h"
#import "SearchPeopleViewController.h"
#import "OrderDetailOnViewController.h"
#import "OrderDetailOnForSearchViewController.h"
#import "LoseEffectViewController.h"
#import "LoseEffectForSearchViewController.h"
#import "StrikeDealViewController.h"
#import "StrikeDealForSearchViewController.h"
#import "OrderDetailDidViewController.h"
#import "LoseEffectMyOrderViewController.h"
#import "StrikeDealMyOrderViewController.h"
#import "OrderDetailDidForSearchViewController.h"
//#import "MyLocaltion.h"
@interface SubOrderViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)UITableView *_tableView;
@property(nonatomic)int mpage;
@end

@implementation SubOrderViewController
@synthesize mpage,_tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    mpage =0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self makeUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)controllerRefresh
{
    mpage = 0;
    [self loadData];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[NearbyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.type = _state;
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_state == 0) {
        if ([self.dataArray[indexPath.row][@"type"] isEqualToString:@"1"]) {
            OrderDetailOnViewController *vc = [[OrderDetailOnViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            OrderDetailOnForSearchViewController *vc = [[OrderDetailOnForSearchViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (_state == 1)
    {
        if ([self.dataArray[indexPath.row][@"type"] isEqualToString:@"1"]) {
            LoseEffectViewController *vc = [[LoseEffectViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            LoseEffectForSearchViewController *vc = [[LoseEffectForSearchViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:vc animated:YES];

        }
    }
    else if (_state == 2)
    {
        if ([self.dataArray[indexPath.row][@"type"] isEqualToString:@"1"]) {
            StrikeDealViewController *vc = [[StrikeDealViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            StrikeDealForSearchViewController *vc = [[StrikeDealForSearchViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    else if (_state == 3)
    {
        if ([self.dataArray[indexPath.row][@"type"] isEqualToString:@"1"]) {
            OrderDetailDidViewController *vc = [[OrderDetailDidViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            OrderDetailDidForSearchViewController *vc = [[OrderDetailDidForSearchViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
             vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    else if (_state == 4)
    {
        if ([self.dataArray[indexPath.row][@"type"] isEqualToString:@"1"]) {
            OrderDetailDidViewController *vc = [[OrderDetailDidViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            OrderDetailDidForSearchViewController *vc = [[OrderDetailDidForSearchViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    else if (_state == 5)
    {
        if ([self.dataArray[indexPath.row][@"type"] isEqualToString:@"1"]) {
            OrderDetailDidViewController *vc = [[OrderDetailDidViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            OrderDetailDidForSearchViewController *vc = [[OrderDetailDidForSearchViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tid = self.dataArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }

}
-(void)loadData
{
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *lat  =[user objectForKey:@"lat"];
    NSString *lng = [user objectForKey:@"lng"];
    if (!lat||!lng) {
        lat = @"";
        lng = @"";
    }
    NSString *url = [NSString stringWithFormat:@"%@myorderlist?uid=%@&token=%@&state=%d&type=%d&limit=10&page=%d&lat=%@&lng=%@",SERVER_URL,uid,token,_state%3,_type,mpage+1,lat,lng];
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
                    else if(array.count == 0)
                    {
                        if (weakSelf.mpage == 0) {
                            [weakSelf.dataArray removeAllObjects];
                             [weakSelf._tableView reloadData];
                        }
                        else
                        {
                            [weakSelf showMsg:@"没有更多订单了"];
                        }
                    }
                }
                else if([jsonStr isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    [weakSelf showMsg:dict[@"message"]];
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user removeObjectForKey:@"uid"];
                    [user removeObjectForKey:@"token"];
                    [user removeObjectForKey:@"flag"];
                    [user synchronize];
                     [weakSelf.dataArray removeAllObjects];
                    [weakSelf._tableView reloadData];

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

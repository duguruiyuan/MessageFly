//
//  NearbyViewController.m
//  MessageFly
//
//  Created by xll on 15/2/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "NearbyViewController.h"
#import "NearbyTableViewCell.h"
#import "NearbyDetailNotViewController.h"
#import "SearchView.h"
#import "MyLocaltion.h"
#import "SelectCityViewController.h"
#import "SearchPeopleViewController.h"
#import "MapNearbyViewController.h"
#import "BMapKit.h"
#import "BMKSearchComponent.h"
@interface NearbyViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,SearchDelegate,LocationHandlerDelegate,MJRefreshBaseViewDelegate,UITextFieldDelegate,CitySelectDelegate,BMKGeoCodeSearchDelegate>
{
    
    SearchView *searchView;
    UIButton *searchBtn;
    BOOL hasPosition;
    
    UILabel *placeLabel;
    UITextField *textField;
    
    NSString *lat;
    NSString *lng;
    NSString *city;
    
    NSString *order;
    NSString *keyword;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    NSString *searchLat;
    NSString *searchLng;
    
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)UITableView *_tableView;
@property(nonatomic)int mpage;
@end

@implementation NearbyViewController
@synthesize mpage,_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    mpage = 0;
    lat =@"";
    lng = @"";
    order = @"2";
    city = @"0";
    keyword = @"";
    searchLng = @"";
    searchLat = @"";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"附近" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;

    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"5" title:nil selector:@selector(map) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    searchBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:@"6" title:nil selector:@selector(search:) target:self];
    [searchBtn setImage:[UIImage imageNamed:@"56"] forState:UIControlStateSelected];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self createSearhView];
    [self updateLocal];
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSubViewcontroll) name:ORDERDEAL object:nil];
}
-(void)dealloc
{
    [_header free];
    [_footer free];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark   刷新数据
-(void)reloadSubViewcontroll
{
    mpage = 0;
    self.mLoadMsg = nil;
    [self loadData];

}
#pragma mark  点击地图模式
-(void)map
{
    [searchView removeFromSuperview];
    searchBtn.selected = NO;
    searchView = nil;
    MapNearbyViewController *vc = [[MapNearbyViewController alloc]init];
    vc.dataArray = [NSMutableArray arrayWithArray:self.dataArray];
    if (textField.text.length>0) {
        vc.selectPlace =textField.text;
    }
    vc.selectCity = placeLabel.text;
    vc.cityId = city;
    if (lat) {
        vc.uLat = lat;
        vc.uLng = lng;
    }
    else
    {
        vc.uLat = @"";
        vc.uLng = @"";
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark   地位获取当前经纬度  刷新数据
-(void)updateLocal
{
    self.mLoadMsg = @"正在定位...";
    [self StartLoading];
    hasPosition = NO;
    MyLocaltion *local = [MyLocaltion getSharedInstance];
    local.delegate = self;
    [[MyLocaltion getSharedInstance]startUpdating];
}
-(void)didUpdateToLocation:(CLLocation *)newLocation
              fromLocation:(CLLocation *)oldLocation{
   lat =[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
   lng =[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    NSLog(@"lat%@~~~lng%@",lat,lng);
    if ([lat intValue]==0&&[lng intValue]==0) {
        [self performSelector:@selector(timeStart) withObject:nil afterDelay:5];
    }
    else{
        hasPosition = YES;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:lat forKey:@"lat"];
        [user setObject:lng forKey:@"lng"];
        [user synchronize];
        [[MyLocaltion getSharedInstance]stopUpdating];
        
        BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc]init];
        search.delegate=self;
        BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
        rever.reverseGeoPoint = newLocation.coordinate;
        [search reverseGeoCode:rever];
    }
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
         NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        textField.placeholder = [NSString stringWithFormat:@"%@",result.address];
        [user setObject:result.address forKey:@"myplace"];
        [user setObject:result.addressDetail.city forKey:@"mycity"];
        placeLabel.text =result.addressDetail.city;
        
        NSString *name = [NSString stringWithFormat:@"city.plist"];
        NSString *path = [[NSBundle mainBundle] resourcePath];
        path = [path stringByAppendingPathComponent:name];
        NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:path];
        for (NSDictionary *dic in tempArray) {
            NSString *cityname = dic[@"value"];
            if ([cityname isEqualToString:result.addressDetail.city]) {
                city = dic[@"id"];
            }
        }
        [self StopLoading];
        self.mLoadMsg = @"定位成功,加载数据...";
        [self loadData];
    }
    else
    {
        [self StopLoading];
        self.mLoadMsg = @"定位失败,加载数据...";
        [self loadData];
    }
}
-(void)timeStart
{
    if (!hasPosition) {
        [[MyLocaltion getSharedInstance]stopUpdating];
        [self noLocalLoadData];
    }
    hasPosition = NO;
}
-(void)noLocalLoadData
{
    [self StopLoading];
    self.mLoadMsg = @"定位失败,加载数据...";
    [self loadData];
}
-(void)didFailWithError:(NSError *)error
{
    [[MyLocaltion getSharedInstance]stopUpdating];
    [self noLocalLoadData];

}
#pragma mark   点击搜索  搜索处理
-(void)search:(UIButton *)sender
{
    if (sender.selected) {
        [searchView removeFromSuperview];
        searchBtn.selected = NO;
        searchView = nil;
    }
    else
    {
        searchBtn.selected = YES;
        searchView = [[SearchView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT+50)];
        searchView.delegate = self;
        [self.tabBarController.view addSubview:searchView];
    } 
}
-(void)selectView:(SearchView *)searchView1 Index:(int)buttonIndex
{
    if (buttonIndex != 5) {
        
        order = [NSString stringWithFormat:@"%d",buttonIndex+1];
        mpage= 0;
        [self loadData];
       
    }
    searchBtn.selected = NO;
     searchView = nil;
}
#pragma mark   createSearhView
-(void)createSearhView
{
    UIImageView *searhView = [MyControll createImageViewWithFrame:CGRectMake(10, 10, WIDTH-20, 40) imageName:@"8"];
    searhView.userInteractionEnabled = YES;
    [self.view addSubview:searhView];
    
    placeLabel = [MyControll createLabelWithFrame:CGRectMake(5, 5, 60, 30) title:@"全国" font:14];
    placeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    placeLabel.textAlignment = NSTextAlignmentCenter;
    placeLabel.userInteractionEnabled = YES;
    [searhView addSubview:placeLabel];
    
    UIButton *placeBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:nil title:nil selector:@selector(choseCity) target:self];
    [placeLabel addSubview:placeBtn];
    
    UIImageView *arrow_xia = [MyControll createImageViewWithFrame:CGRectMake(65, 0, 12, 40) imageName:@"9"];
    arrow_xia.contentMode = UIViewContentModeScaleAspectFit;
    [searhView addSubview:arrow_xia];
    
    
    UIView *line1 = [MyControll createViewWithFrame:CGRectMake(85, 10, 1, 20)];
    line1.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    [searhView addSubview:line1];
    
    textField = [MyControll createTextFieldWithFrame:CGRectMake(90, 5, searhView.frame.size.width-90-40, 30) text:nil placehold:@"" font:13];
    textField.returnKeyType = UIReturnKeySearch;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    [searhView addSubview:textField];
    
    UIView *line2 = [MyControll createViewWithFrame:CGRectMake(searhView.frame.size.width-40, 10, 1, 20)];
    line2.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    [searhView addSubview:line2];
    
    UIButton *mapBtn = [MyControll createButtonWithFrame:CGRectMake(searhView.frame.size.width-39, 0, 38, 40) bgImageName:nil imageName:@"10" title:nil selector:@selector(showUser) target:self];
    [searhView addSubview:mapBtn];
}
#pragma mark   回到当年位置
-(void)showUser
{
    textField.text = @"";
    searchLat = @"";
    searchLng = @"";
    keyword = @"";
    mpage= 0;
    [self updateLocal];
}
#pragma mark   选取城市 刷新数据
-(void)choseCity
{
    [self.view endEditing:YES];
    SelectCityViewController *vc = [[SelectCityViewController alloc]init];
    vc.cDelegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)selectCity:(NSString *)cityName ID:(NSString *)id
{
    city = id;
    textField.text = @"";
    if([cityName isEqualToString:@"#全部省份"])
    {
        placeLabel.text = @"全国";
        searchLat = @"";
        searchLng = @"";
        keyword = @"";
        [self loadData];
    }
    else
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *myplace = [user objectForKey:@"myplace"];
        NSString *mycity = [user objectForKey:@"mycity"];
        placeLabel.text = cityName;
        if([mycity isEqualToString:cityName])
        {
            MyLocaltion *local = [MyLocaltion getSharedInstance];
            local.delegate = self;
            textField.placeholder = myplace;
            [[MyLocaltion getSharedInstance] getLatLng:myplace inCity:placeLabel.text];
        }
       else
       {
           MyLocaltion *local = [MyLocaltion getSharedInstance];
           local.delegate = self;
           textField.placeholder = @"";
           [[MyLocaltion getSharedInstance] getLatLng:placeLabel.text inCity:placeLabel.text];
       }
    }
    
}
-(void)didGetLatAndLng:(NSString *)slat Lng:(NSString *)slng
{
    searchLat  = slat;
    searchLng = slng;
    keyword = @"";
    mpage= 0;
    [self loadData];
    
}
-(void)didFailGet
{
    keyword = textField.text;
    searchLat = @"";
    searchLng = @"";
    mpage= 0;
    [self loadData];
}
#pragma mark   点击处理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self mapClick];
    [self.view endEditing:YES];
    return YES;
}
-(void)mapClick
{
    if ([placeLabel.text isEqualToString:@"全国"]) {
        if (textField.text.length == 0) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *myplace = [user objectForKey:@"myplace"];
            NSString *mycity = [user objectForKey:@"mycity"];
            MyLocaltion *local = [MyLocaltion getSharedInstance];
            local.delegate = self;
            [[MyLocaltion getSharedInstance] getLatLng:myplace inCity:mycity];
        }
        else
        {
            MyLocaltion *local = [MyLocaltion getSharedInstance];
            local.delegate = self;
            [[MyLocaltion getSharedInstance] getLatLng:textField.text inCity:@""];
        }
    }
    else
    {
        if (textField.text.length == 0) {
            MyLocaltion *local = [MyLocaltion getSharedInstance];
            local.delegate = self;
            [[MyLocaltion getSharedInstance] getLatLng:placeLabel.text inCity:placeLabel.text];
        }
        else
        {
            MyLocaltion *local = [MyLocaltion getSharedInstance];
            local.delegate = self;
            [[MyLocaltion getSharedInstance] getLatLng:textField.text inCity:placeLabel.text];
        }
    }
}
#pragma mark   tableView
-(void)makeUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, WIDTH, HEIGHT-60)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
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
    NearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[NearbyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.type = -1;
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic =self.dataArray[indexPath.row];
    if ([dic[@"type"] isEqualToString:@"1"]) {
            NearbyDetailNotViewController *vc = [[NearbyDetailNotViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.detaiID = self.dataArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([dic[@"type"] isEqualToString:@"2"])
    {
        UIStoryboard *mainstory =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchPeopleViewController *vc = [mainstory instantiateViewControllerWithIdentifier:@"SearchPeopleViewController"];
        vc.detaiID = self.dataArray[indexPath.row][@"id"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
-(void)loadData
{
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
//    NSString *token = [user objectForKey:@"token"];
    NSString *str = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@indexlist?uid=%@&token=%@&pro=%@&city=%@&order=%@&where=%@&lat=%@&lng=%@&limit=20&page=%d&dlat=%@&dlng=%@",SERVER_URL,uid,@"",@"",city,order,str,lat,lng,mpage+1,searchLat,searchLng];
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
                    else
                    {
                        if (weakSelf.mpage == 0) {
                            [weakSelf showMsg:@"没有搜索到哦"];
                            [weakSelf.dataArray removeAllObjects];
                            [weakSelf._tableView reloadData];
                        }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //如果是下拉刷新
    if(refreshView == _header)
    {
        mpage = 0;
//        textField.text = @"";
        
          [self loadData];
    }
    else
    {
        [self loadData];
//         [self updateLocal];
    }
    
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

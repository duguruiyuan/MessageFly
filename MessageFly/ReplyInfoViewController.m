//
//  ReplyInfoViewController.m
//  MessageFly
//
//  Created by xll on 15/2/11.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ReplyInfoViewController.h"
#import "PicSCView.h"
#import "ReplyViewController.h"
#import "SoundBtn.h"
#import "SelfHonestViewController.h"
#import "ReplyDetailTableViewCell.h"
#import "ReplyHeadView.h"
#import "InChargeViewController.h"
@interface ReplyInfoViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *bgView;
    UIButton *headView;
    UILabel *nameLabel;
    UILabel *phoneLabel;

    
    UIView *contentView;
    UILabel *contentLabel;
    UIView *picView;
    
    UIView *firstView;
    UIView *secView;
    PicSCView *picSCView;
    
    SoundBtn *soundBtn;
    UIView *soundView;
    int mpage;
}
@property(nonatomic,strong)UITableView *_tableView;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *headArray;
@end

@implementation ReplyInfoViewController
@synthesize _tableView;
-(void)viewDidDisappear:(BOOL)animated
{
    [soundBtn stopPlay];
    [[MyPlayer sharedInstance] stopPlay];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    mpage = 0;
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"回复信息" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
    [self loadData];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadSubViewcontroll) name:REPLYREFFRESH object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)reloadSubViewcontroll
{
    mpage = 0;
    [self loadData];
}
-(void)reply
{
    [self.view endEditing:YES];
    NSDictionary *dic = [self.dataArray lastObject];
    ReplyViewController *vc = [[ReplyViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.detailID = _detailId;
    vc.rid = dic[@"othereply"][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tousu
{
    InChargeViewController *vc = [[InChargeViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tid = _tid;
    vc.detailID = _detailId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)makeUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor =[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 130)];
    bgView.backgroundColor =[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    
    firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    firstView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:firstView];
    firstView.userInteractionEnabled = YES;
    [firstView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkInfoCLick)]];
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"抢单人信息" font:15];
    [firstView addSubview:tishi1];
    
    UIButton *tousuBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-60, 0, 50, 40) bgImageName:nil imageName:@"tousu" title:nil selector:@selector(tousu) target:self];
    [firstView addSubview:tousuBtn];
    
    
    UIView*line = [[UIView alloc]initWithFrame:CGRectMake(20, 40, WIDTH-20, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [firstView addSubview:line];
       
    headView = [MyControll createButtonWithFrame:CGRectMake(20, 50, 60, 60) bgImageName:@"touxiang" imageName:nil title:nil selector:@selector(checkInfoCLick) target:self];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 30;
    [firstView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(90, 50, WIDTH-90-50, 20) title:@"" font:16];
    [firstView addSubview:nameLabel];
    
    UILabel * tishi2 = [MyControll createLabelWithFrame:CGRectMake(90, 70, 70, 20) title:@"联系电话:" font:13];
    tishi2.textColor = [UIColor lightGrayColor];
    [firstView addSubview:tishi2];
    
    UILabel *tishi3 = [MyControll createLabelWithFrame:CGRectMake(90, 90, 70, 20) title:@"发单诚信" font:13];
    tishi3.textColor = [UIColor lightGrayColor];
    [firstView addSubview:tishi3];
    
    phoneLabel = [MyControll createLabelWithFrame:CGRectMake(160, 70, WIDTH-160-50, 20) title:@"" font:13];
    phoneLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:phoneLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH-50, 50, 1, 60)];
    line2.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [firstView addSubview:line2];
    
    UIButton *contactBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-45, 40, 40, 80) bgImageName:nil imageName:@"o14" title:nil selector:@selector(contactClick) target:self];
    [firstView addSubview:contactBtn];
    _tableView.tableHeaderView = bgView;
    
}
-(void)checkInfoCLick
{
    SelfHonestViewController *vc = [[SelfHonestViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.uid = _tid;
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)contactClick
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",self.dataDic[@"mobile"]];
    NSURL *telURL =[NSURL URLWithString:telUrl];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
-(void)createBottomView
{
    UIImageView *bottomView = [MyControll createImageViewWithFrame:CGRectMake(0, HEIGHT-60, WIDTH, 60) imageName:@"17@2x_20"];
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    
    UIButton *rejectBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2-140)/2, 8, 140, 44) bgImageName:@"o13@2x" imageName:nil title:nil selector:@selector(endClick:) target:self];
    rejectBtn.tag = 200;
    [bottomView addSubview:rejectBtn];
    
    UIButton *acceptBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2-140)/2+WIDTH/2, 8, 140, 44) bgImageName:@"o12@2x" imageName:nil title:nil selector:@selector(endClick:) target:self];
    acceptBtn.tag = 201;
    [bottomView addSubview:acceptBtn];
}
-(void)endClick:(UIButton *)sender
{
    int index = (int)sender.tag-200;
    if (index == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"接受之后您将支付%@元给该抢单者",_moneyNum] delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 400;
        [alert show];
    }
    else if (index == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定拒绝该抢单者?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 401;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 400) {
        if (buttonIndex == 1) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *uid = [user objectForKey:@"uid"];
            NSString *token = [user objectForKey:@"token"];
            [self StartLoading];
            NSString *url = [NSString stringWithFormat:@"%@handlereply?uid=%@&token=%@&id=%@&type=1&tid=%@&tuid=%@",SERVER_URL,uid,token,self.dataDic[@"id"],_detailId,_tid];
            __weak typeof(self) weakSelf=self;
            _sfManager = [ServerFetcherManager sharedServerManager];
            [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
                if (isSuccess) {
                    [weakSelf StopLoading];
                    if (data && data.length>0) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        if (dic&&dic.count>0) {
                            if ([[dic[@"code"] stringValue]isEqualToString:@"1"]) {
                                [weakSelf showMsg:@"订单成交"];
                                [[NSNotificationCenter defaultCenter]postNotificationName:PressRELOADVC object:nil];
                                 [[NSNotificationCenter defaultCenter]postNotificationName:ORDERDEAL object:nil];
                                [weakSelf performSelector:@selector(GoBackToRoot) withObject:nil afterDelay:1];
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
    }
    else if (alertView.tag == 401)
    {
        if (buttonIndex == 1) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *uid = [user objectForKey:@"uid"];
            NSString *token = [user objectForKey:@"token"];
            [self StartLoading];
            NSString *url = [NSString stringWithFormat:@"%@handlereply?uid=%@&token=%@&id=%@&type=2&tid=%@&tuid=%@",SERVER_URL,uid,token,self.dataDic[@"id"],_detailId,_tid];
            __weak typeof(self) weakSelf=self;
            _sfManager = [ServerFetcherManager sharedServerManager];
            [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
                if (isSuccess) {
                    [weakSelf StopLoading];
                    if (data && data.length>0) {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        if (dic&&dic.count>0) {
                            if ([[dic[@"code"] stringValue]isEqualToString:@"1"]) {
                                [weakSelf showMsg:@"拒绝成功"];
                                [[NSNotificationCenter defaultCenter]postNotificationName:PressRELOADVC object:nil];
                                [weakSelf performSelector:@selector(GoBackToRoot) withObject:nil afterDelay:1];
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

    }
}
-(void)GoBackToRoot
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    [self StartLoading];
    NSString *url = [NSString stringWithFormat:@"%@replayinfo2?uid=%@&token=%@&id=%@&tid=%@&limit=10&page=%d",SERVER_URL,uid,token,_detailId,_tid,mpage+1];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf StopLoading];
            if (data && data.length>0) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (dic&&dic.count>0) {
                    NSString *code = [dic[@"code"] stringValue];
                    if (!code) {
                        weakSelf.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                        [weakSelf refreshUI];
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
-(void)refreshUI
{
    _moneyNum = self.dataDic[@"money"];
    if ([[self.dataDic[@"flag"]stringValue]isEqualToString:@"0"]) {
        if (_ifBottom == 1) {
            [self createBottomView];
            _tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-60);
        }
        else
        {
            
        }
    }
    else
    {
        _tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    }
    [headView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"picdefault@2x"]];
    nameLabel.text = self.dataDic[@"name"];
    phoneLabel.text = self.dataDic[@"mobile"];
    for (int i= 0; i<5; i++) {
        if (i<[self.dataDic[@"sendcerity"] intValue]) {
            UIImageView *star = [MyControll createImageViewWithFrame:CGRectMake(160+18*i, 90, 16, 20) imageName:@"m16@2x_14"];
            star.contentMode = UIViewContentModeScaleAspectFit;
            [firstView addSubview:star];
        }
        else
        {
            UIImageView *star = [MyControll createImageViewWithFrame:CGRectMake(160+18*i, 90, 16, 20) imageName:@"m16@2x_16"];
            star.contentMode = UIViewContentModeScaleAspectFit;
            [firstView addSubview:star];
        }
    }
    self.headArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *array = self.dataDic[@"replyinfo"];
    
    if (array.count==0) {
        
    }
    else
    {
        if ([[self.dataDic[@"flag"]stringValue]isEqualToString:@"0"]) {
            if (_ifBottom == 1) {
                UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(10, 0, 40, 30) bgImageName:nil imageName:nil title:@"回复" selector:@selector(reply) target:self];
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
            }
        }
    }
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic = array[i][@"othereply"];
        [self.headArray addObject:dic];
    }
    
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [_tableView reloadData];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *myReplyArray = self.dataArray[section][@"myreply"];
    return  myReplyArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[ReplyDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSArray *myReplyArray = dict[@"myreply"];
    NSDictionary *dic = myReplyArray[indexPath.row];
    cell.delegate = self;
    [cell config:dic];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSArray *myReplyArray = dict[@"myreply"];
    NSDictionary *dic = myReplyArray[indexPath.row];
    CGFloat height = 40;
    if (![dic[@"radio"] isEqualToString:@""]) {
        //        [playSoundView loadVoiceData:self.dataDic];
        height =  height+95;
    }
    else
    {
        
    }
    if (![dic[@"text"] isEqualToString:@""]) {
        CGSize sizeOfcontent = [MyControll getSize:dic[@"text"] Font:15 Width:sWIDTH-40 Height:1000];
        height =height+(35+sizeOfcontent.height+5)+10;
    }
    else
    {
        
    }
    NSArray *picArray =dic[@"image"];
    CGFloat picWidth = (sWIDTH-40-30)/4;
    CGFloat picHeight = 0;
    if (picArray.count != 0 ) {
        if (picArray.count%4!=0) {
            picHeight = (picArray.count/4+1)*(picWidth + 10);
        }
        else
        {
            picHeight = (picArray.count/4)*(picWidth + 10);
        }
        height = height+picHeight+40;
    }
    else
    {
        picView.hidden = YES;
    }
    height =height+5;
    
    return height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    ReplyHeadView *rpView = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:@"myHeadView"];
    if (!rpView) {
        rpView = [[ReplyHeadView alloc]initWithReuseIdentifier:@"myHeadView"];
    }
    rpView.delegate =self;
    [rpView config:self.headArray[section]];
    return rpView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = self.headArray[section];
    CGFloat height = 40;
    if (![dic[@"radio"] isEqualToString:@""]) {
        //        [playSoundView loadVoiceData:self.dataDic];
        height = height+95;
    }
    else
    {
        
    }
    if (![dic[@"text"] isEqualToString:@""]) {
        CGSize sizeOfcontent = [MyControll getSize:dic[@"text"] Font:15 Width:sWIDTH-40 Height:1000];
        height =height+(35+sizeOfcontent.height+5)+10;
    }
    else
    {
        
    }
    NSArray *picArray =dic[@"image"];
    CGFloat picWidth = (sWIDTH-40-30)/4;
    CGFloat picHeight = 0;
    if (picArray.count != 0 ) {
        if (picArray.count%4!=0) {
            picHeight = (picArray.count/4+1)*(picWidth + 10);
        }
        else
        {
            picHeight = (picArray.count/4)*(picWidth + 10);
        }
        height = height+picHeight+40;
    }
    else
    {
        picView.hidden = YES;
    }
    height =height+5;
    if (height<50) {
        return 0.01;
    }
    else
    {
        return height;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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

//
//  SelfHonestViewController.m
//  MessageFly
//
//  Created by xll on 15/2/25.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SelfHonestViewController.h"
#import "CommentTableViewCell.h"
#import "IQKeyboardManager.h"
#import "InChargeViewController.h"
@interface SelfHonestViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *firstView;
    UIView *secView;
    UILabel *nameLabel;
    
    UIButton *headView;
    
    UIView *contentView;
    int startCount;
    UITextView *txView;
    
}
@property(nonatomic,strong)UITableView *_tableView;
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation SelfHonestViewController
@synthesize _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:NO];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    
    
    startCount = 0;
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"个人诚信" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 250)];
    bottomView.backgroundColor =[UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    
    firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    firstView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:firstView];
    
    headView = [MyControll createButtonWithFrame:CGRectMake(30, 10, 70, 70) bgImageName:@"touxiang" imageName:nil title:nil selector:@selector(checkInfoCLick) target:self];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 35;
    [firstView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(130, 10, WIDTH-130, 25) title:@"" font:20];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    [firstView addSubview:nameLabel];
    
    UILabel *fdStarLabel = [MyControll createLabelWithFrame:CGRectMake(130, 35, 70, 20) title:@"发单诚信" font:14];
    fdStarLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:fdStarLabel];
    UILabel *jdStarLabel = [MyControll createLabelWithFrame:CGRectMake(130, 55, 70, 20) title:@"接单诚信" font:14];
    jdStarLabel.textColor = [UIColor lightGrayColor];
    [firstView addSubview:jdStarLabel];
    
    
    for (int i= 0; i<5; i++) {
        UIImageView *star = [MyControll createImageViewWithFrame:CGRectMake(200+18*i, 35, 16, 20) imageName:@"m16@2x_16"];
        star.tag = 80000+i;
        star.contentMode = UIViewContentModeScaleAspectFit;
        [firstView addSubview:star];
        UIImageView *star1 = [MyControll createImageViewWithFrame:CGRectMake(200+18*i, 55, 16, 20) imageName:@"m16@2x_16"];
        star1.tag = 90000+i;
        star1.contentMode = UIViewContentModeScaleAspectFit;
        [firstView addSubview:star1];
    }
    
    secView = [[UIView alloc]initWithFrame:CGRectMake(0, 90, WIDTH, 140)];
    secView.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [bottomView addSubview:secView];
    
    float width = (WIDTH-35.7-20)/4;
    NSArray *labelNameArray = @[@"总量",@"成交量",@"成功率",@"被成功投诉"];
    for (int i = 0; i<4; i++) {
        UILabel *label = [MyControll createLabelWithFrame:CGRectMake(35.7+width*i, 0, width, 40) title:labelNameArray[i] font:13];
        label.textAlignment= NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.00f];
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 1;
        [secView addSubview:label];
    }
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [secView addSubview:bgView];
    
    for (int i=0; i<4; i++) {
        UILabel *label = [MyControll createLabelWithFrame:CGRectMake(35.7+width*i, 40, width, 50) title:@"" font:14];
        label.tag = 100+i;
        label.textAlignment = NSTextAlignmentCenter;
        [secView addSubview:label];
        
    }
    for (int i=0; i<4; i++) {
        UILabel *label = [MyControll createLabelWithFrame:CGRectMake(35.7+width*i, 90, width, 50) title:@"" font:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 200+i;
        [secView addSubview:label];
        
    }
    
    NSArray *titleArray = @[@"o23@2x",@"o24@2x"];
    for (int i =0; i<2; i++) {
        UIImageView *imageview = [MyControll createImageViewWithFrame:CGRectMake(0, 40+i*50, 35.7, 50) imageName:titleArray[i]];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        [secView addSubview:imageview];
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = bottomView;
    
    [bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTap:)]];
    
    
    if (_type == 1) {
        _tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-110-64);
        [self createBottomView];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        [txView resignFirstResponder];
    }
}
-(void)removeTap:(UIGestureRecognizer *)sender
{
    [txView resignFirstResponder];
}
-(void)createBottomView
{
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-110-64, WIDTH, 110)];
    contentView.backgroundColor = [UIColor colorWithRed:0.92f green:0.93f blue:0.93f alpha:1.00f];
    [self.view addSubview:contentView];
    

    UILabel *label = [MyControll createLabelWithFrame:CGRectMake(20, 10, 45, 30) title:@"星级" font:18];
    [contentView addSubview:label];
    
    for (int i = 0; i< 5; i++) {
        UIButton *heartBtn = [MyControll createButtonWithFrame:CGRectMake(80 + i * 30, 10, 24, 30) bgImageName:nil imageName:@"o20@2x" title:nil selector:@selector(heartBtnClick:) target:self];
        heartBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [heartBtn setImage:[UIImage imageNamed:@"o19@2x"] forState:UIControlStateSelected];
        heartBtn.tag = 10 + i;
        [contentView addSubview:heartBtn];
    }
    
    UIView *line =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview:line];
    
    UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(0, 50, WIDTH, 0.5)];
    [contentView addSubview:line1];
    line1.backgroundColor = [UIColor lightGrayColor];
    
    UIView *bview = [[UIView alloc]initWithFrame:CGRectMake(10, 60, WIDTH-90, 40)];
    bview.backgroundColor = [UIColor whiteColor];
    bview.clipsToBounds = YES;
    bview.layer.cornerRadius = 3;
    [contentView addSubview:bview];
    
    txView = [[UITextView alloc]initWithFrame:CGRectMake(5, 2.5, bview.frame.size.width-10, 45)];
    txView.font = [UIFont systemFontOfSize:16];
    [bview addSubview:txView];
    
    UIButton *sendBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-65, 55, 60, 50) bgImageName:nil imageName:@"fas@2x" title:nil selector:@selector(sendClick) target:self];
    sendBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:sendBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)sendClick
{
    if (txView.text.length==0) {
        [self showMsg:@"评论内容不能为空"];
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        return;
    }
    [self StartLoading];
    NSString *str = [txView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@commentother?uid=%@&token=%@&tid=%@&star=%d&text=%@",SERVER_URL,uid,token,_uid,startCount,str];
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
                        NSString *name = [user objectForKey:@"name"];
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:5];
                        [dic setObject:name forKey:@"name"];
                        [dic setObject:[NSString stringWithFormat:@"%d",startCount] forKey:@"star"];
                        [dic setObject:txView.text forKey:@"text"];
                        [dic setObject:uid forKey:@"uid"];
                        NSDate *date = [NSDate date];
                        [dic setObject:[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]] forKey:@"time"];
                        [self.dataArray insertObject:dic atIndex:0];
                        [txView resignFirstResponder];
                        txView.text = @"";
                        [_tableView reloadData];
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
-(void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的参数
    NSDictionary *dict = [notification userInfo];
    CGRect keyboardFrame = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (duration == 0) {
        duration = 0.1;
    }
    [UIView animateWithDuration:duration animations:^{
        contentView.frame = CGRectMake(0, HEIGHT-120-CGRectGetHeight(keyboardFrame), WIDTH, 120);
    }];
    
}
-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSTimeInterval duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        contentView.frame = CGRectMake(0, HEIGHT-120, WIDTH, 120);
    }];
}
-(void)heartBtnClick:(UIButton *)sender
{
    for (int i = 0; i<=sender.tag - 10; i++) {
        UIButton *btn = (UIButton *)[contentView viewWithTag:10 + i];
        btn.selected = YES;
    }
    for (int i = 14; i > sender.tag - 10; i--) {
        UIButton *btn = (UIButton *)[contentView viewWithTag:10 + i];
        btn.selected = NO;
    }
    startCount = (int)sender.tag-10+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDS"];
    if (!cell) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IDS"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic =self.dataArray[indexPath.row];
    CGSize size = [MyControll getSize:dic[@"text"] Font:15 Width:sWIDTH-40 Height:1000];
    return 40+size.height+5+10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"评论" font:16];
    tishi.font = [UIFont boldSystemFontOfSize:16];
    [view addSubview:tishi];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 39.5, WIDTH-20, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    [view addSubview:line];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(void)loadData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
//    if (!uid||!token) {
//        return;
//    }
    [self StartLoading];
    NSString *url = [NSString stringWithFormat:@"%@cerityinfo?uid=%@&token=%@&id=%@",SERVER_URL,uid,token,_uid];
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
        }
    }];
    
}
-(void)endSomething
{
    [self StopLoading];
}
-(void)refreshUI
{
    
    nameLabel.text = self.dataDic[@"name"];
    [headView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang"]];
    for (int i = 0; i<5; i++) {
        if (i<[self.dataDic[@"sendcerity"]intValue]) {
            UIImageView *star =(UIImageView *)[firstView viewWithTag:80000+i];
            star.image = [UIImage imageNamed:@"m16@2x_14"];
        }
        else
        {
            UIImageView *star =(UIImageView *)[firstView viewWithTag:80000+i];
            star.image = [UIImage imageNamed:@"m16@2x_16"];
        }
        if (i<[self.dataDic[@"getcerity"]intValue]) {
            UIImageView *star =(UIImageView *)[firstView viewWithTag:90000+i];
            star.image = [UIImage imageNamed:@"m16@2x_14"];
        }
        else
        {
            UIImageView *star =(UIImageView *)[firstView viewWithTag:90000+i];
            star.image = [UIImage imageNamed:@"m16@2x_16"];
        }
    }

    UILabel *label0 = (UILabel *)[secView viewWithTag:100];
    UILabel *label1 = (UILabel *)[secView viewWithTag:101];
    UILabel *label2 = (UILabel *)[secView viewWithTag:102];
    UILabel *label3 = (UILabel *)[secView viewWithTag:103];
    UILabel *label4 = (UILabel *)[secView viewWithTag:200];
    UILabel *label5 = (UILabel *)[secView viewWithTag:201];
    UILabel *label6 = (UILabel *)[secView viewWithTag:202];
    UILabel *label7 = (UILabel *)[secView viewWithTag:203];
    
    NSDictionary *dic1 = self.dataDic[@"send"];
    label0.text =[dic1[@"all"] stringValue];
    label1.text = [dic1[@"sucess"] stringValue];
    label2.text = dic1[@"sourc"];
    label3.text = [dic1[@"tou"] stringValue];
    
    NSDictionary *dic2 = self.dataDic[@"get"];
    label4.text =[dic2[@"all"] stringValue];
    label5.text = [dic2[@"sucess"] stringValue];
    label6.text = dic2[@"sourc"];
    label7.text = [dic2[@"tou"] stringValue];
    
    NSArray *array = self.dataDic[@"comments"];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [_tableView reloadData];
}
-(void)checkInfoCLick
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
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

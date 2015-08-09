//
//  NearbyDetailNotViewController.m
//  MessageFly
//
//  Created by xll on 15/2/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "NearbyDetailNotViewController.h"
#import "PicSCView.h"
#import "ReplyViewController.h"
#import "LoginViewController.h"
#import "SoundBtn.h"
#import "SelfHonestViewController.h"
#import "LunBoTuViewController.h"
#import "RealNameViewController.h"
@interface NearbyDetailNotViewController ()<UIAlertViewDelegate>
{
    UIScrollView *mainSC;
    UIButton *headView;
    UILabel *nameLabel;
    UILabel *phoneLabel;
    UIButton *numOfSeeBtn;
     UIImageView *eye;
    UIView *contentView;
    UILabel *contentLabel;
    UIView *picView;
    
    UIView *thirdView;
    
    UILabel *moneyLabel;
    UILabel *endTimeLabel;
    UILabel *distanceLabel;
    UILabel *stausLabel;
    UIView *firstView;
   
    UIView *secView;
    UIView *picSCView;
    
    UIView *soundView;
    
    SoundBtn *soundBtn;
    
    UIButton *contactBtn;
}
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@property(nonatomic,strong)UIButton *commitBtn;
@end

@implementation NearbyDetailNotViewController
@synthesize commitBtn;

-(void)viewDidDisappear:(BOOL)animated
{
    [soundBtn stopPlay];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"信息详情" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
    
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-60)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 680);
    [self.view addSubview:mainSC];
    
    firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    firstView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:firstView];
    firstView.userInteractionEnabled = YES;
    [firstView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"发布人信息" font:15];
    [firstView addSubview:tishi1];
    
    UIView*line = [[UIView alloc]initWithFrame:CGRectMake(20, 40, WIDTH-20, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [firstView addSubview:line];
    
//    headView = [MyControll createImageViewWithFrame:CGRectMake(20, 50, 60, 60) imageName:@"picdefault@2x"];
    headView = [MyControll createButtonWithFrame:CGRectMake(20, 50, 60, 60) bgImageName:nil imageName:@"picdefault@2x" title:nil selector:@selector(headClick) target:self];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius=30;
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
    
    contactBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-45, 40, 40, 80) bgImageName:nil imageName:@"11116" title:nil selector:@selector(contactClick) target:self];
    [firstView addSubview:contactBtn];
    
    secView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, WIDTH, 345)];
    secView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:secView];
    
    UILabel *tishi4 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"详情" font:15];
    [secView addSubview:tishi4];
    
    eye = [MyControll createImageViewWithFrame:CGRectMake(WIDTH-90, 0, 15, 40) imageName:@"16@2x_22"];
    eye.contentMode = UIViewContentModeScaleAspectFit;
    [secView addSubview:eye];
    
    numOfSeeBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-70, 0, 65, 40) bgImageName:nil imageName:nil title:@"浏览次" selector:@selector(seeClick) target:self];
    numOfSeeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [numOfSeeBtn setTitleColor:[UIColor colorWithRed:0.54f green:0.59f blue:0.67f alpha:1.00f] forState:UIControlStateNormal];
    [secView addSubview:numOfSeeBtn];
    
    soundView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, 95)];
    [secView addSubview:soundView];
        
    UIView*line3 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIDTH-20, 1)];
    line3.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [soundView addSubview:line3];
    
    UILabel *tishi5 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"语音" font:14];
    tishi5.textColor = [UIColor lightGrayColor];
    [soundView addSubview:tishi5];

    soundBtn = [[SoundBtn alloc]initWithFrame:CGRectMake((WIDTH-200)/2, 35, 200, 50)];
    [soundView addSubview:soundBtn];
    
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 135, WIDTH, 90)];
    [secView addSubview:contentView];
    
    UIView*line4 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIDTH-20, 1)];
    line4.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [contentView addSubview:line4];
    
    UILabel *tishi6 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"文字" font:14];
    tishi6.textColor = [UIColor lightGrayColor];
    [contentView addSubview:tishi6];
    
    contentLabel = [MyControll createLabelWithFrame:CGRectMake(20, 35, WIDTH-40, 45) title:@"" font:15];
    [contentView addSubview:contentLabel];
    
    picView =[[UIView alloc]initWithFrame:CGRectMake(0, 235, WIDTH, 110)];
    [secView addSubview:picView];
    
    UIView*line5 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, WIDTH-20, 1)];
    line5.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [picView addSubview:line5];
    
    UILabel *tishi7 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"图片" font:14];
    tishi7.textColor = [UIColor lightGrayColor];
    [picView addSubview:tishi7];
    
    CGFloat picWidth = (WIDTH-40-30)/4;
    picSCView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, WIDTH, picWidth)];
    [picView addSubview:picSCView];
    
    
    thirdView = [MyControll createToolView4WithFrame:CGRectMake(0, 490, WIDTH, 160) withColor:[UIColor whiteColor] withNameArray:@[@"酬      金:",@"剩余时长:",@"距投放地:",@"抢单状态:"]];
    [mainSC addSubview:thirdView];
    
    moneyLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2-20, 40) title:@"元/人" font:15];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:moneyLabel];
    endTimeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2, 40, WIDTH/2-20, 40) title:@"00:00" font:15];
    endTimeLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:endTimeLabel];
    distanceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2, 80, WIDTH/2-20, 40) title:@"km" font:15];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:distanceLabel];
    stausLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2, 120, WIDTH/2-20, 40) title:@"抢单" font:15];
    stausLabel.textAlignment = NSTextAlignmentRight;
    [thirdView addSubview:stausLabel];
}
-(void)headClick
{
    SelfHonestViewController *vc = [[SelfHonestViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.uid = self.dataDic[@"uid"];
    vc.type = 0;
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
-(void)seeClick
{
    
}
-(void)createBottomView
{
    UIImageView  * bottomView = [MyControll createImageViewWithFrame:CGRectMake(0, HEIGHT-64, WIDTH, 60) imageName:@"17@2x_20"];
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    commitBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 8, 260, 44) bgImageName:nil imageName:@"18@2x_20" title:nil selector:@selector(qiangClick) target:self];
    [bottomView addSubview:commitBtn];
    if ([[self.dataDic[@"style"] stringValue]isEqualToString:@"1"]) {
        [commitBtn setImage:[UIImage imageNamed:@"17@2x_17"] forState:UIControlStateNormal];
        [contactBtn setImage:[UIImage imageNamed:@"o14"] forState:UIControlStateNormal];
         contactBtn.enabled = YES;
         phoneLabel.text = self.dataDic[@"mobile"];
    }
    else
    {
        [commitBtn setImage:[UIImage imageNamed:@"18@2x_20"] forState:UIControlStateNormal];
        [contactBtn setImage:[UIImage imageNamed:@"11116"] forState:UIControlStateNormal];
        contactBtn.enabled = NO;
        NSMutableString *str =[NSMutableString stringWithString:self.dataDic[@"mobile"]];
        if (str) {
            [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            phoneLabel.text = str;
        }
        
    }
}
-(void)qiangClick
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (uid&&token) {
        if (![uid isEqualToString:self.dataDic[@"uid"]]) {
            if ([[self.dataDic[@"style"] stringValue]isEqualToString:@"0"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否立即抢单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 900;
                [alert show];
            }
        }
        else
        {
            [self showMsg:@"你不能抢你自己的订单"];
            return;
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您没有登录，请先登录后操作，是否去登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 902;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==901) {
        if (buttonIndex == 1) {
            ReplyViewController *vc = [[ReplyViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.detailID = self.dataDic[@"id"];
            vc.rid = @"";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if(alertView.tag == 902)
    {
        if (buttonIndex == 1) {
            LoginViewController  *vc = [[LoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if(alertView.tag == 900)
    {
        if (buttonIndex == 1) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *uid = [user objectForKey:@"uid"];
                NSString *token = [user objectForKey:@"token"];
                [self StartLoading];
                NSString *url = [NSString stringWithFormat:@"%@createmark?uid=%@&token=%@&tid=%@",SERVER_URL,uid,token,self.dataDic[@"id"]];
                __weak typeof(self) weakSelf=self;
                _sfManager = [ServerFetcherManager sharedServerManager];
                [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
                    if (isSuccess) {
                        [weakSelf StopLoading];
                        if (data && data.length>0) {
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            if (dic&&dic.count>0) {
                                if ([[dic[@"code"] stringValue]isEqualToString:@"1"]) {
                                    [weakSelf.dataDic setObject:[NSNumber numberWithInt:1] forKey:@"style"];
                                    [[NSNotificationCenter defaultCenter]postNotificationName:MyQRELOADVC object:nil];
                                    [[NSNotificationCenter defaultCenter]postNotificationName:ORDERDEAL object:nil];
                                    [weakSelf.commitBtn setImage:[UIImage imageNamed:@"17@2x_17"] forState:UIControlStateNormal];
                                    [contactBtn setImage:[UIImage imageNamed:@"o14"] forState:UIControlStateNormal];
                                    contactBtn.enabled = YES;
                                    phoneLabel.text = self.dataDic[@"mobile"];
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"抢单成功，立即回复" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                    alert.tag = 901;
                                    [alert show];
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
-(void)loadData
{
       [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *lat = [user objectForKey:@"lat"];
    NSString *lng = [user objectForKey:@"lng"];
    NSString *url = [NSString stringWithFormat:@"%@indexinfo?uid=%@&token=%@&id=%@&lat=%@&lng=%@",SERVER_URL,uid,token,_detaiID,lat,lng];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [_sfManager addHttpTaskWithGet:url andParameter:nil completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf StopLoading];
            if (data && data.length>0) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (dic&&dic.count>0) {
                    weakSelf.dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [weakSelf refreshUI];
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
    [headView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"picdefault@2x"]];
    nameLabel.text = self.dataDic[@"name"];
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
    [numOfSeeBtn setTitle:[NSString stringWithFormat:@"浏览%@次",self.dataDic[@"view"]] forState:UIControlStateNormal];
    CGSize size = [MyControll getSize:numOfSeeBtn.titleLabel.text Font:13 Width:WIDTH/2 Height:20];
    numOfSeeBtn.frame = CGRectMake(WIDTH-size.width-10, 0, size.width+5, 40);
    eye.frame = CGRectMake(WIDTH-size.width-30, 0, 15, 40);
    
    float height = 40;
    if (![self.dataDic[@"radio"] isEqualToString:@""]) {
        [soundBtn loadVoiceData:self.dataDic];
        height = soundView.frame.origin.y+soundView.frame.size.height+10;
    }
    else
    {
        soundView.hidden = YES;
    }
    if (![self.dataDic[@"text"] isEqualToString:@""]) {
        CGSize sizeOfcontent = [MyControll getSize:self.dataDic[@"text"] Font:15 Width:WIDTH-40 Height:1000];
        contentLabel.frame = CGRectMake(20, 35, WIDTH-40, sizeOfcontent.height+5);
        contentLabel.text = self.dataDic[@"text"];
        contentView.frame = CGRectMake(0, height, WIDTH, contentLabel.frame.origin.y+contentLabel.frame.size.height);
        height =contentView.frame.origin.y+contentView.frame.size.height+10;
    }
    else
    {
        contentView.hidden = YES;
    }

    NSArray *picArray = self.dataDic[@"image"];
    CGFloat picWidth = (WIDTH-40-30)/4;
    CGFloat picHeight = 0;
    if (picArray.count>0) {
        for (int i = 0; i<picArray.count; i++) {
            UIImageView *imageView = [MyControll createImageViewWithFrame:CGRectMake(20+(picWidth+10)*(i%4), i/4*(picWidth+10), picWidth, picWidth) imageName:nil];
            [imageView sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:@"picdefault@2x"]];
            imageView.tag = 200+i;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPhoto:)]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [picSCView addSubview:imageView];
        }
        if (picArray.count%4!=0) {
            picHeight = (picArray.count/4+1)*(picWidth + 10);
        }
        else
        {
            picHeight = (picArray.count/4)*(picWidth + 10);
        }
        picSCView.frame = CGRectMake(0, 35, WIDTH, picHeight);
        picView.frame = CGRectMake(0, height, WIDTH, picHeight+40);
        height = height + CGRectGetHeight(picView.frame);
    }
    else
    {
        picView.hidden = YES;
    }
    
    
    secView.frame = CGRectMake(0, 130, WIDTH, height);
    thirdView.frame = CGRectMake(0, secView.frame.origin.y+secView.frame.size.height+10, WIDTH, 160);
    mainSC.contentSize = CGSizeMake(WIDTH, thirdView.frame.origin.y+thirdView.frame.size.height + 25);
    
    moneyLabel.text = [NSString stringWithFormat:@"%@元/人",self.dataDic[@"money"]];
    endTimeLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"ltime"]];
    distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",[self.dataDic[@"distance"] floatValue]/1000];
    if ([self.dataDic[@"state"]isEqualToString:@"0"]) {
        stausLabel.text =@"待抢单";
        [self createBottomView];
    }
    else if ([self.dataDic[@"state"]isEqualToString:@"1"])
    {
        stausLabel.text =@"已抢单";
        [self createBottomView];
    }
    else if ([self.dataDic[@"state"]isEqualToString:@"2"])
    {
        stausLabel.text =@"已成交";
        mainSC.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        [self dealSomething];
    }
    else if ([self.dataDic[@"state"]isEqualToString:@"3"])
    {
        stausLabel.text =@"已失效";
        mainSC.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        [self dealSomething];
    }

    
}
-(void)checkPhoto:(UIGestureRecognizer *)sender
{
    NSArray *picArray = self.dataDic[@"bigimage"];
    LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc picShow:picArray atIndex:(int)(sender.view.tag-200)];
    [self presentViewController:vc animated:NO completion:nil];
}
-(void)dealSomething
{
    [contactBtn setImage:[UIImage imageNamed:@"11116"] forState:UIControlStateNormal];
    contactBtn.enabled = NO;
    NSMutableString *str =[NSMutableString stringWithString:self.dataDic[@"mobile"]];
    if (str) {
        [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        phoneLabel.text = str;
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

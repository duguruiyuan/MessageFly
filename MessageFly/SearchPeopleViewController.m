//
//  SearchPeopleViewController.m
//  MessageFly
//
//  Created by xll on 15/4/3.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SearchPeopleViewController.h"
#import "LunBoTuViewController.h"
#import "LoginViewController.h"
#import "ReplyViewController.h"
#import "SoundBtn.h"
#import "SelfHonestViewController.h"
#import "RealNameViewController.h"
#import "MoveView.h"
@interface SearchPeopleViewController ()
{
     SoundBtn *soundBtn;
    MoveView *moveView;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *jiguan;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UIView *wordView;
@property (weak, nonatomic) IBOutlet UILabel *wordDesc;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UILabel *lostTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView *secView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wordViewToTopCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wordHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wordViewHeightcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewHeightcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdViewCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secViewCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picTopHeightcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherTopHeightCon;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceViewHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceToTopCon;
@property (weak, nonatomic) IBOutlet UIView *voiceView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ScorllViewBOttomCons;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;

@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation SearchPeopleViewController
-(void)viewDidDisappear:(BOOL)animated
{
    [soundBtn stopPlay];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomView.hidden = YES;
    self.bottomBtn.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"急寻人详情" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)loadData
{
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSString *lat = [user objectForKey:@"lat"];
    NSString *lng = [user objectForKey:@"lng"];
    NSString *url = [NSString stringWithFormat:@"%@indexinfo2?uid=%@&token=%@&id=%@&lat=%@&lng=%@",SERVER_URL,uid,token,_detaiID,lat,lng];
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
-(void)headClick
{
    SelfHonestViewController *vc = [[SelfHonestViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.uid = self.dataDic[@"uid"];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)refreshUI
{
    self.firstView.userInteractionEnabled = YES;
    [self.firstView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    [self.headView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] placeholderImage:[UIImage imageNamed:@"picdefault@2x"]];
    self.headView.userInteractionEnabled = YES;
    [self.headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    self.nameLabel.text = self.dataDic[@"uname"];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"mobile"]];
    for (int i = 0; i<[self.dataDic[@"sendcerity"] intValue]; i++) {
        
    }
    for (UIImageView *imageView in self.firstView.subviews) {
        if (imageView.tag-100<[self.dataDic[@"sendcerity"] intValue]&&imageView.tag>=100&&imageView.tag<=104) {
            imageView.image = [UIImage imageNamed:@"m16@2x_14"];
        }
        else if(imageView.tag-100>=[self.dataDic[@"sendcerity"] intValue]&&imageView.tag<=104)
        {
            imageView.image = [UIImage imageNamed:@"m16@2x_16"];
        }
    }
    self.name.text = [NSString stringWithFormat:@"姓名：%@",self.dataDic[@"name"]];
    if ([self.dataDic[@"sex"] isEqualToString:@"0"]) {
        self.sex.text = @"性别：女";
    }
    else
    {
        self.sex.text = @"性别：男";
    }
    self.age.text = [NSString stringWithFormat:@"年龄：%@岁",self.dataDic[@"age"]];
//    self.jiguan.text = [NSString stringWithFormat:@"籍贯：%@",self.dataDic[@"oaddress"]];
    CGSize ssss = [MyControll getSize:@"籍贯：" Font:13 Width:1000 Height:20];
    float www =self.jiguan.frame.origin.x+ssss.width;
    moveView = [[MoveView alloc]initWithFrame:CGRectMake(www, self.jiguan.frame.origin.y, WIDTH-www-5, 20)];
    [self.secView addSubview:moveView];
    [moveView config:self.dataDic[@"oaddress"] withFont:13 withTime:5];
    self.heightLabel.text = [NSString stringWithFormat:@"身高：%@cm",self.dataDic[@"height"]];
    self.weightLabel.text = [NSString stringWithFormat:@"体重：%@kg",self.dataDic[@"weight"]];
    CGFloat height=120;
    
    if (![self.dataDic[@"radio"] isEqualToString:@""]) {
        soundBtn = [[SoundBtn alloc]initWithFrame:CGRectMake((WIDTH-200)/2, 35, 200, 50)];
        [self.voiceView addSubview:soundBtn];
        [soundBtn loadVoiceData:self.dataDic];
        height = height+self.voiceViewHeightCon.constant;
    }
    else
    {
        self.voiceView.hidden = YES;
    }
    if (![self.dataDic[@"text"] isEqualToString:@""]) {
        self.wordViewToTopCon.constant = height;
        CGSize sizeOfText = [MyControll getSize:self.dataDic[@"text"] Font:14 Width:WIDTH-40 Height:1000];
        self.wordHeightCon.constant = sizeOfText.height+5;
        self.wordDesc.text = self.dataDic[@"text"];
        self.wordViewHeightcon.constant = sizeOfText.height+40+10;
        height = height+self.wordViewHeightcon.constant;
    }
    else
    {
        self.wordView.hidden = YES;
    }
    self.picTopHeightcon.constant = height;
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
            [self.photoView addSubview:imageView];
        }
        if (picArray.count%4!=0) {
            picHeight = (picArray.count/4+1)*(picWidth + 10);
        }
        else
        {
            picHeight = (picArray.count/4)*(picWidth + 10);
        }
        self.photoViewHeightCon.constant = picHeight;
        self.picViewHeightcon.constant = picHeight+40;
        height = height + self.picViewHeightcon.constant;
    }
    else
    {
        self.picView.hidden = YES;
    }
    self.otherTopHeightCon.constant = height;
    self.secViewCon.constant = height+140;
    self.bgViewHeightCon.constant = 120+10+self.secViewCon.constant+10+160+10;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元/人",self.dataDic[@"money"]];
    self.leftTimeLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"lestime"]];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",[self.dataDic[@"distance"] floatValue]/1000];
    self.finalPlaceLabel.text = self.dataDic[@"lastw"];
    
    int time = [self.dataDic[@"ltime"] intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *str = [MyControll dayLabelForMessage:date];
    self.lostTimeLabel.text = str;
    
    if ([self.dataDic[@"state"]isEqualToString:@"0"]) {
      self.stateLabel.text =@"待抢单";
        [self bottomDeal];
    }
    else if ([self.dataDic[@"state"]isEqualToString:@"1"])
    {
        self.stateLabel.text =@"已抢单";
         [self bottomDeal];
    }
    else if ([self.dataDic[@"state"]isEqualToString:@"3"])
    {
        self.stateLabel.text =@"已失效";
        self.bottomView.hidden = YES;
        self.bottomBtn.hidden = YES;
        self.ScorllViewBOttomCons.constant = 0;
        [self dealSomething];
    }
    else if ([self.dataDic[@"state"]isEqualToString:@"2"])
    {
        self.stateLabel.text =@"已成交";
        self.bottomView.hidden = YES;
        self.bottomBtn.hidden = YES;
        self.ScorllViewBOttomCons.constant = 0;
        [self dealSomething];
    }
    
   
}
-(void)dealSomething
{
    [self.contactBtn setImage:[UIImage imageNamed:@"11116"] forState:UIControlStateNormal];
    self.contactBtn.enabled = NO;
    NSMutableString *str =[NSMutableString stringWithString:self.dataDic[@"mobile"]];
    if (str) {
        [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.phoneLabel.text = str;
    }
}
-(void)bottomDeal
{
    self.bottomView.hidden = NO;
    self.bottomBtn.hidden = NO;
    if ([[self.dataDic[@"style"] stringValue]isEqualToString:@"1"]) {
        [self.bottomBtn setImage:[UIImage imageNamed:@"17@2x_17"] forState:UIControlStateNormal];
        [self.contactBtn setImage:[UIImage imageNamed:@"o14"] forState:UIControlStateNormal];
            self.contactBtn.enabled = YES;
    }
    else
    {
         [self.bottomBtn setImage:[UIImage imageNamed:@"20@2x_23.png"] forState:UIControlStateNormal];
        [self.contactBtn setImage:[UIImage imageNamed:@"11116"] forState:UIControlStateNormal];
        self.contactBtn.enabled = NO;
        NSMutableString *str =[NSMutableString stringWithString:self.dataDic[@"mobile"]];
        if (str) {
            [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            self.phoneLabel.text = str;
        }

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
- (IBAction)phoneClick:(id)sender {
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",self.dataDic[@"mobile"]];
    NSURL *telURL =[NSURL URLWithString:telUrl];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
- (IBAction)commit:(id)sender {
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
                                [weakSelf.commitBtn setImage:[UIImage imageNamed:@"17@2x_17"] forState:UIControlStateNormal];
                                [weakSelf.contactBtn setImage:[UIImage imageNamed:@"o14"] forState:UIControlStateNormal];
                                weakSelf.contactBtn.enabled = YES;

                                [[NSNotificationCenter defaultCenter]postNotificationName:MyQRELOADVC object:nil];
                                [[NSNotificationCenter defaultCenter]postNotificationName:ORDERDEAL object:nil];
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
    else if(alertView.tag == 903)
    {
        if (buttonIndex == 1) {
            
        }
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

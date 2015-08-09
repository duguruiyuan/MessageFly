//
//  TextYingJHViewController.m
//  MessageFly
//
//  Created by xll on 15/2/10.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "TextYingJHViewController.h"
#import "RadiusView.h"
#import "MapViewController.h"
#import "PicSelectView.h"
#import "LoginViewController.h"
#import "RealNameViewController.h"
#import "ChargeViewController.h"
@interface TextYingJHViewController ()<UIScrollViewDelegate,PicSelectDelegate,UIAlertViewDelegate>
{
    UIScrollView *mainSC;
    UILabel *placeTX;
    UILabel *radiusLabel;
    UITextField *numTX;
    
    UITextField *moneyTX;
    UITextField *timeTX;
    UITextView *contentView;
    UIButton *commit;
    
    RadiusView *radiusView;
    UIView *fourView;
    int deletePicNum;
}
@property(nonatomic,strong)NSMutableArray *uploadPicArray;
@property(nonatomic,strong)ServerFetcherManager *sfManager;

@property(nonatomic,strong)NSDictionary *mapSelectDic;
@end

@implementation TextYingJHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.uploadPicArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"应急呼" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 700);
    [self.view addSubview:mainSC];
    
    UIView *firstView = [MyControll createToolView4WithFrame:CGRectMake(0, 15, WIDTH, 150) withColor:[UIColor whiteColor] withNameArray:@[@"投放地址:",@"投放半径:",@"投放人数:"]];
    [mainSC addSubview:firstView];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *myplace = [user objectForKey:@"myplace"];
    placeTX = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 10, WIDTH/5*4-90, 30) title:nil font:15];
    placeTX.text = myplace;
    placeTX.lineBreakMode = NSLineBreakByTruncatingTail;
    placeTX.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.82f alpha:1.00f];
    [firstView addSubview:placeTX];
    UIButton *choseplace = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(mapClick) target:self];
    [firstView addSubview:choseplace];
    
    radiusLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 60, WIDTH/5*4-90, 30) title:@"2km" font:15];
    radiusLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.82f alpha:1.00f];
    [firstView addSubview:radiusLabel];
    
    numTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 110, WIDTH/5*4-50, 30) text:nil placehold:@"请输入投放人数" font:15];
    numTX.keyboardType = UIKeyboardTypeNumberPad;
    numTX.placeholder = @"1";
    [firstView addSubview:numTX];
    
    UIView *line = [MyControll createLineWithFrame:CGRectMake(WIDTH-40, 0, 1, 50) withColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
    [firstView addSubview:line];
    
    UIButton *mapBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-39, 0, 39, 50) bgImageName:nil imageName:@"p3" title:nil selector:@selector(mapClick) target:self];
    [firstView addSubview:mapBtn];
    
    UIImageView *arrow = [MyControll createImageViewWithFrame:CGRectMake(WIDTH-40, 50, 40, 50) imageName:@"p4"];
    arrow.contentMode = UIViewContentModeCenter;
    [firstView addSubview:arrow];
    
    UIButton *choseRadiusBtn  =[MyControll createButtonWithFrame:CGRectMake(WIDTH/5, 50, WIDTH/5*4, 50) bgImageName:nil imageName:nil title:nil selector:@selector(choseRadiusClick) target:self];
    [firstView addSubview:choseRadiusBtn];
    
    
    UIView *secView = [MyControll createToolView4WithFrame:CGRectMake(0, 180, WIDTH, 100) withColor:[UIColor whiteColor] withNameArray:@[@"酬       金:",@"有效时长:"]];
    [mainSC addSubview:secView];
    
    UIButton *reduceBtn1 = [MyControll createButtonWithFrame:CGRectMake(WIDTH- 210, 5, 40, 40) bgImageName:nil imageName:@"o9@2x" title:nil selector:@selector(moneyClick:) target:self];
    reduceBtn1.tag = 100;
    reduceBtn1.clipsToBounds = YES;
    reduceBtn1.layer.cornerRadius= 3;
    [secView addSubview:reduceBtn1];
    moneyTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH-165, 10, 70, 30) text:@"10" placehold:nil font:15];
    moneyTX.textAlignment = NSTextAlignmentCenter;
    moneyTX.clipsToBounds = YES;
    moneyTX.keyboardType = UIKeyboardTypeNumberPad;
    moneyTX.layer.cornerRadius = 5;
    moneyTX.layer.borderWidth = 0.5;
    moneyTX.layer.borderColor = [[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]CGColor];
    [secView addSubview:moneyTX];
    
    UIButton *addBtn1 =[MyControll createButtonWithFrame:CGRectMake(WIDTH-90, 5, 40, 40) bgImageName:nil imageName:@"o11@2x" title:nil selector:@selector(moneyClick:) target:self];
    addBtn1.tag = 101;
    addBtn1.clipsToBounds = YES;
    addBtn1.layer.cornerRadius= 3;
    [secView addSubview:addBtn1];
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(WIDTH-45, 5, 40, 40) title:@"元/人" font:15];
    [secView addSubview:tishi];
    
    UIButton *reduceBtn2 = [MyControll createButtonWithFrame:CGRectMake(WIDTH- 210, 55, 40, 40) bgImageName:nil imageName:@"o9@2x" title:nil selector:@selector(moneyClick:) target:self];
    reduceBtn2.tag = 102;
    reduceBtn2.clipsToBounds = YES;
    reduceBtn2.layer.cornerRadius= 3;
    [secView addSubview:reduceBtn2];
    timeTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH-165, 60, 70, 30) text:@"10" placehold:nil font:15];
    timeTX.textAlignment = NSTextAlignmentCenter;
    timeTX.clipsToBounds = YES;
    timeTX.keyboardType = UIKeyboardTypeNumberPad;
    timeTX.layer.cornerRadius = 5;
    timeTX.layer.borderWidth = 0.5;
    timeTX.layer.borderColor = [[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]CGColor];
    [secView addSubview:timeTX];
    
    UIButton *addBtn2 =[MyControll createButtonWithFrame:CGRectMake(WIDTH-90, 55, 40, 40) bgImageName:nil imageName:@"o11@2x" title:nil selector:@selector(moneyClick:) target:self];
    addBtn2.tag = 103;
    addBtn2.clipsToBounds = YES;
    addBtn2.layer.cornerRadius= 3;
    [secView addSubview:addBtn2];
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake(WIDTH-45, 55, 40, 40) title:@"小时" font:15];
    [secView addSubview:tishi2];
    
    
    UILabel *tishi3 = [MyControll createLabelWithFrame:CGRectMake(20, 295, 150, 20) title:@"文字辅助说明" font:15];
    [mainSC addSubview:tishi3];
    
    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, 325, WIDTH, 150)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:thirdView];
    
    contentView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, WIDTH-40, 150-20)];
    contentView.text = @"";
    contentView.font = [UIFont systemFontOfSize:15];
    [thirdView addSubview:contentView];
    
    UILabel *tishi4 = [MyControll createLabelWithFrame:CGRectMake(20, 490, 150, 20) title:@"上传图片" font:15];
    [mainSC addSubview:tishi4];
    
    fourView = [[UIView alloc]initWithFrame:CGRectMake(0, 520, WIDTH, 90)];
    fourView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:fourView];
    
    UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20, 10, 70, 70) bgImageName:@"22@2x" imageName:nil title:nil selector:@selector(addPicClick) target:self];
    [fourView addSubview:addPic];
    
    commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 625, 260, 45) bgImageName:nil imageName:@"p1@2x" title:nil selector:@selector(commit) target:self];
    [mainSC addSubview:commit];
}
-(void)commit
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    if (!uid||!token) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您没有登录，请先登录后操作，是否去登录？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 900;
        [alert show];
        return;
    }
    if (placeTX.text.length==0) {
        [self showMsg:@"你没有选择投放地址"];
        return;
    }
    else if (radiusLabel.text.length == 0)
    {
        [self showMsg:@"你没有选择投放半径"];
        return;
    }
    else if (moneyTX.text.length==0)
    {
        [self showMsg:@"酬金填写不能为空"];
        return;
    }
    else if (timeTX.text.length==0)
    {
        [self showMsg:@"有效时长填写不能为空"];
        return;
    }
    else if ([contentView.text isEqualToString:@""])
    {
        [self showMsg:@"文字描述不能为空"];
        return;
    }
    else if (numTX.text.length==0)
    {
        numTX.text = @"1";
    }

    NSString *url = [NSString stringWithFormat:@"%@careateorder",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:token forKey:@"token"];
    [dict setObject:@"" forKey:@"paddress"];
    if (_mapSelectDic) {
        [dict setObject:_mapSelectDic[@"cityname"] forKey:@"city"];
        [dict setObject:_mapSelectDic[@"placename"] forKey:@"address"];
        [dict setObject:_mapSelectDic[@"lat"] forKey:@"lat"];
        [dict setObject:_mapSelectDic[@"lng"] forKey:@"lng"];
    }
    else
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *myplace = [user objectForKey:@"myplace"];
        NSString *mycity = [user objectForKey:@"mycity"];
        NSString *lat  =[user objectForKey:@"lat"];
        NSString *lng = [user objectForKey:@"lng"];
        [dict setObject:mycity forKey:@"city"];
        [dict setObject:myplace forKey:@"address"];
        [dict setObject:lat forKey:@"lat"];
        [dict setObject:lng forKey:@"lng"];
    }
    [dict setObject:moneyTX.text forKey:@"money"];
    [dict setObject:[radiusLabel.text substringToIndex:radiusLabel.text.length-2] forKey:@"radis"];
    [dict setObject:numTX.text forKey:@"num"];
    [dict setObject:timeTX.text forKey:@"hour"];
    [dict setObject:contentView.text forKey:@"text"];
    NSLog(@"%@",dict);
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [self StartLoading];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.uploadPicArray.count>0) {
        for (int i = 0; i<self.uploadPicArray.count; i++) {
            [dic setObject:self.uploadPicArray[i] forKey:[NSString stringWithFormat:@"file[%d]",i]];
        }
    }
        [_sfManager addUploadTaskWithUrl:url normalParam:dict images:dic voices:nil completion:^(BOOL isSuccess, NSData *data) {
            if (isSuccess) {
                [weakSelf StopLoading];
                if (data && data.length>0) {
                    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if ([[info[@"code"] stringValue]isEqualToString:@"1"]) {
                        [weakSelf showMsg:@"发布成功"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:ORDERDEAL object:nil];
                        [weakSelf performSelector:@selector(GoBack) withObject:nil afterDelay:1];
                    }
                    else if ([[info[@"code"] stringValue]isEqualToString:@"2"])
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"账户金额不足，是否立即充值?" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alert.tag = 903;
                        [alert show];
                    }
                    else
                    {
                        [weakSelf showMsg:[NSString stringWithFormat:@"%@",info[@"message"]]];
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
-(void)addPicClick
{
    if (self.uploadPicArray.count>=8) {
        [self showMsg:@"图片最多选择8张"];
        return;
    }
    PicSelectView *picSelectView = [[PicSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    picSelectView.tag = 203;
    picSelectView.delegate = self;
    picSelectView.maxCount = 8-(int)self.uploadPicArray.count;
    [self.tabBarController.view addSubview:picSelectView];
    [picSelectView makeUI];
}
-(void)picSelect:(PicSelectView *)picSelectView1 Camera:(NSString *)filePath Album:(NSMutableArray *)array Flag:(int)flag
{
    if (flag == 1) {
        [self.uploadPicArray addObject:filePath];
        [self refreshUI];
    }
    else if (flag == 2)
    {
        [self.uploadPicArray addObjectsFromArray:array];
        [self refreshUI];
    }
}
-(void)refreshUI
{
    for (UIView *view in fourView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat picWidth = (WIDTH-40-30)/4;
    for (int i=0; i<self.uploadPicArray.count+1; i++) {
        if (i<self.uploadPicArray.count) {
            UIImageView *tempImageView = [MyControll createImageViewWithFrame:CGRectMake(20+(picWidth+10)*(i%4),10+ i/4*(picWidth+10), picWidth, picWidth) imageName:nil];
            tempImageView.image = [UIImage imageWithContentsOfFile:self.uploadPicArray[i]];
            [tempImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            tempImageView.tag = 300+i;
            tempImageView.contentMode = UIViewContentModeScaleAspectFill;
            tempImageView.clipsToBounds = YES;
            [fourView addSubview:tempImageView];
        }
        else if(i != 8)
        {
            UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20+(picWidth+10)*(i%4),10+ i/4*(picWidth+10), picWidth, picWidth) bgImageName:@"22@2x" imageName:nil title:nil selector:@selector(addPicClick) target:self];
            [fourView addSubview:addPic];
        }
    }
    if (self.uploadPicArray.count < 8) {
        CGFloat picHeight = 0;
        if ((self.uploadPicArray.count+1)%4!=0) {
            picHeight = ((self.uploadPicArray.count+1)/4+1)*(picWidth + 10);
        }
        else
        {
            picHeight = ((self.uploadPicArray.count+1)/4)*(picWidth + 10);
        }
        fourView.frame = CGRectMake(0, 520, WIDTH, picHeight+20);
        commit.frame = CGRectMake((WIDTH-260)/2, fourView.frame.origin.y+fourView.frame.size.height+10, 260, 45);
        mainSC.contentSize  = CGSizeMake(WIDTH, commit.frame.origin.y+commit.frame.size.height+25);
    }
    else
    {
        CGFloat picHeight = 0;
        if (self.uploadPicArray.count%4!=0) {
            picHeight = (self.uploadPicArray.count/4+1)*(picWidth + 10);
        }
        else
        {
            picHeight = (self.uploadPicArray.count/4)*(picWidth + 10);
        }
        fourView.frame = CGRectMake(0, 520, WIDTH, picHeight+20);
        commit.frame = CGRectMake((WIDTH-260)/2, fourView.frame.origin.y+fourView.frame.size.height+10, 260, 45);
        mainSC.contentSize  = CGSizeMake(WIDTH, commit.frame.origin.y+commit.frame.size.height+25);
    }
    
   
    
}
-(void)longPress:(UIGestureRecognizer *)sender
{
    deletePicNum = (int)sender.view.tag-300;
//    if (sender.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你打算删除改图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 901;
        [alert show];
//    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 901) {
        if (buttonIndex == 1) {
            [self.uploadPicArray removeObjectAtIndex:deletePicNum];
            [self refreshUI];
        }
    }
    else if (alertView.tag == 903)
    {
        if (buttonIndex == 1) {
            ChargeViewController *vc = [[ChargeViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if(alertView.tag == 900)
    {
        if (buttonIndex == 1) {
            LoginViewController  *vc = [[LoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)moneyClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        int moneyNum = [moneyTX.text intValue];
        if (moneyNum>1) {
            moneyNum--;
            moneyTX.text = [NSString stringWithFormat:@"%d",moneyNum];
        }
        else
        {
            [self showMsg:@"最少酬金必须为1元/人"];
        }
    }
    else if (sender.tag == 101)
    {
        int moneyNum = [moneyTX.text intValue];
        moneyNum++;
        moneyTX.text = [NSString stringWithFormat:@"%d",moneyNum];
    }
    else if (sender.tag == 102)
    {
        int tNum = [timeTX.text intValue];
        if (tNum>1) {
            tNum--;
            timeTX.text = [NSString stringWithFormat:@"%d",tNum];
        }
        else
        {
            [self showMsg:@"最少时长必须为1小时"];
        }
    }
    else if (sender.tag == 103)
    {
        int tNum = [timeTX.text intValue];
        tNum++;
        timeTX.text = [NSString stringWithFormat:@"%d",tNum];
    }

}
-(void)mapClick
{
    MapViewController *vc = [[MapViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.myLocaltionBlock = ^(NSDictionary *dic)
    {
        placeTX.text = dic[@"placename"];
        placeTX.textColor = [UIColor blackColor];
        _mapSelectDic = [NSDictionary dictionaryWithDictionary:dic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)choseRadiusClick
{
    if (radiusView) {
        return;
    }
    radiusView = [[RadiusView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
    radiusView.myBlock = ^(NSString *str)
    {
        if ([str isEqualToString:@""]) {
            radiusView = nil;
        }
        else
        {
            radiusLabel.text = str;
            radiusLabel.textColor = [UIColor blackColor];
            radiusView = nil;
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:radiusView];
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

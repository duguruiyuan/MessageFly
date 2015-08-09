//
//  RegistNextViewController.m
//  MessageFly
//
//  Created by xll on 15/2/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "RegistNextViewController.h"
#import "PickDateView.h"
#import "PhotoSelectManager.h"
#import "AgeSelectView.h"
#import "MapViewController.h"
#import "HomeViewController.h"
@interface RegistNextViewController ()<PickDateDelegate,UIActionSheetDelegate,photoSelectManagerDelegate>
{
    UIScrollView *mainSC;
    NSString *pickDate;
    UIView *secView;
    BOOL headViewIsPick;
    PhotoSelectManager  *mPhotoManager;
    NSString *fileway;
    UIButton *headView;
    AgeSelectView *ageSelectView;
    
    NSDictionary *lifeDic;
    NSDictionary *workDic;
    NSDictionary *activeDic;
    UILabel *lifePlaceLabel;
    UILabel *workPlaceLabel;
    UILabel *activePlaceLabel;

}
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation RegistNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"注册" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *jumpBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"跳过" selector:@selector(commit) target:self];
    [jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:jumpBtn];
    [self makeUI];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    mainSC.backgroundColor =[UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 510);
    [self.view addSubview:mainSC];
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, WIDTH, 90)];
    firstView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:firstView];
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 30, 60, 30) title:@"头像" font:17]          ;
    [firstView addSubview:tishi1];
    
    headView = [MyControll createButtonWithFrame:CGRectMake(WIDTH-90, 10, 70, 70) bgImageName:@"touxiang" imageName:nil title:nil selector:@selector(headClick) target:self];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 35;
    [firstView addSubview:headView];
    
    UIButton *headBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH, 90) bgImageName:nil imageName:nil title:nil selector:@selector(headClick) target:self];
    [firstView addSubview:headBtn];
    
    
    
    secView =[MyControll createToolView5WithFrame:CGRectMake(0, 120, WIDTH, 200) withColor:[UIColor whiteColor] withNameArray:@[@"昵称",@"年龄(岁)",@"性别",@"生日"] withFont:17];
    [mainSC addSubview:secView];
 
    for (int i=0; i<4; i++) {
        if (i<2) {
            UITextField *textfield = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH-150, i*50, 140, 50) text:nil placehold:@"请输入昵称" font:14];
            textfield.textAlignment = NSTextAlignmentRight;
            textfield.tag = 60000+i;
            if (i==1) {
                textfield.enabled = NO;
                textfield.placeholder = @"请输入年龄";
            }
            [secView addSubview:textfield];
            if (i==1) {
                textfield.keyboardType = UIKeyboardTypeNumberPad;
            }
        }
        else
        {
            UILabel *label = [MyControll createLabelWithFrame:CGRectMake(WIDTH-150, i*50, 140, 50) title:@"请输入性别" font:14];
            if (i==3) {
                label.text = @"请输入生日";
            }
            label.textAlignment = NSTextAlignmentRight;
            label.userInteractionEnabled = YES;
            label.tag = 60000+i;
            label.textColor = [UIColor lightGrayColor];
            [secView addSubview:label];
            UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, i*50, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(btnClick:) target:self];
            btn.tag = 70000+i;
            [secView addSubview:btn];
        }
    }
    for (int i = 0; i<2; i++) {
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, i*50, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(getNotice:) target:self];
        btn.tag = 500+i;
        [secView addSubview:btn];
    }
    
    
    UIImageView *infoImageView = [MyControll createImageViewWithFrame:CGRectMake(20, 330, 16, 40) imageName:@"m21@2x"];
    infoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [mainSC addSubview:infoImageView];
    
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake(40, 330, WIDTH-60, 40) title:@"请尽量输入您的详细地址，有利于得到别人的帮助或者其他人提供帮助" font:13];
    tishi2.textColor= [UIColor colorWithRed:0.51f green:0.51f blue:0.51f alpha:1.00f];
    [mainSC addSubview:tishi2];
    
    UIView *thirdView = [MyControll createToolView4WithFrame:CGRectMake(0, 385, WIDTH, 150) withColor:[UIColor whiteColor] withNameArray:@[@"生活区域",@"工作区域",@"活动区域"]];
    [mainSC addSubview:thirdView];
    
    lifePlaceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+30, 0, WIDTH/5*4-85, 50) title:nil font:15];
    [thirdView addSubview:lifePlaceLabel];
    
    workPlaceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+30, 50, WIDTH/5*4-85, 50) title:nil font:15];
    [thirdView addSubview:workPlaceLabel];
    
    activePlaceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+30, 100, WIDTH/5*4-85, 50) title:nil font:15];
    [thirdView addSubview:activePlaceLabel];
    
    for (int i = 0; i<3; i++) {
        UIView *line = [MyControll createLineWithFrame:CGRectMake(WIDTH-45, i*50, 1, 50) withColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
        [thirdView addSubview:line];
        
        UIButton *mapBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-44, i*50, 44, 50) bgImageName:nil imageName:@"p3" title:nil selector:@selector(mapClick:) target:self];
        mapBtn.tag = 200+i;
        [thirdView addSubview:mapBtn];
    }
    
    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, CGRectGetMaxY(thirdView.frame)+20, 260, 40) bgImageName:nil imageName:@"l2@2x" title:nil selector:@selector(commit) target:self];
    [mainSC addSubview:commit];
    mainSC.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(commit.frame)+20);
}
-(void)mapClick:(UIButton *)sender
{
    if (sender.tag == 200) {
        MapViewController *vc = [[MapViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.myLocaltionBlock =^(NSDictionary *dic)
        {
            lifeDic = [NSDictionary dictionaryWithDictionary:dic];
            lifePlaceLabel.text = lifeDic[@"placename"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender.tag == 201)
    {
        MapViewController *vc = [[MapViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.myLocaltionBlock =^(NSDictionary *dic)
        {
            workDic = [NSDictionary dictionaryWithDictionary:dic];
            workPlaceLabel.text = workDic[@"placename"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender.tag == 202)
    {
        MapViewController *vc = [[MapViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.myLocaltionBlock =^(NSDictionary *dic)
        {
            activeDic = [NSDictionary dictionaryWithDictionary:dic];
            activePlaceLabel.text = activeDic[@"placename"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)getNotice:(UIButton *)sender
{
    [self.view endEditing:YES];
    UITextField *tx0 = (UITextField *)[secView viewWithTag:60000];
    UITextField *tx1 = (UITextField *)[secView viewWithTag:60001];
    int index = (int)sender.tag-500;
    if (index == 0) {
        [tx0 becomeFirstResponder];
    }
    else
    {
        ageSelectView = [[AgeSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [[UIScreen mainScreen]bounds].size.height)];
        ageSelectView.myBlock = ^(NSString *str)
        {
            if ([str isEqualToString:@""]) {
                ageSelectView = nil;
            }
            else
            {
                tx1.text = str;
                tx1.textColor = [UIColor blackColor];
                ageSelectView = nil;
            }
        };
        [[UIApplication sharedApplication].keyWindow addSubview:ageSelectView];
    }
}
-(void)headClick
{
    [self.view endEditing:YES];
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册" ,nil];
    sheet.tag = 1235;
    [sheet showInView:self.view];
}
-(void)btnClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    int index = (int)sender.tag-70000;
    if (index == 2) {
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        sheet.tag = 1234;
        [sheet showInView:self.view];
    }
    else if(index == 3)
    {
        PickDateView *pickDateView = [[PickDateView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT+64)];
        pickDateView.tag = 1000;
        pickDateView.isShowTitle = NO;
        pickDateView.delegate = self;
        pickDateView.startDate = @"1900-01-01 12:00";
       
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        pickDateView.showDate = [formatter stringFromDate:[NSDate date]];
        pickDateView.stopDate = [formatter stringFromDate:[NSDate date]];
        [pickDateView makeUI];
        [self.tabBarController.view addSubview:pickDateView];
    }
}
-(void)didSelectDate:(NSString *)selectDate PickDateView:(PickDateView *)pickDateView
{
    if (pickDateView.tag == 1000) {
        NSLog(@"%@",selectDate);
        pickDate = selectDate;
        UILabel *label = (UILabel *)[secView viewWithTag:60000+3];
        label.text = [pickDate componentsSeparatedByString:@" "][0];
        label.textColor = [UIColor blackColor];
        [self removeView];
    }
}
-(void)removeView
{
    PickDateView *pickDateView = (PickDateView *)[self.tabBarController.view viewWithTag:1000];
    [pickDateView removeFromSuperview];
    pickDateView = nil;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1234) {
        if (buttonIndex == 0) {
            UILabel *label = (UILabel *)[secView viewWithTag:60000+2];
            label.text = @"男";
            label.textColor = [UIColor blackColor];
        }
        else if (buttonIndex == 1)
        {
            UILabel *label = (UILabel *)[secView viewWithTag:60000+2];
            label.text = @"女";
             label.textColor = [UIColor blackColor];
        }
    }
    else
    {
        if (buttonIndex == 0 || buttonIndex == 1) {
            mPhotoManager = [[PhotoSelectManager alloc] init];
            mPhotoManager.mRootCtrl = self;
            mPhotoManager.delegate = self;
            mPhotoManager.photoDelegate = self;
            mPhotoManager.mDefaultName = @"touxiang";
            mPhotoManager.mbEdit = YES;
            mPhotoManager.OnPhotoSelect = @selector(OnPhotoSelect:);
            buttonIndex == 0?[mPhotoManager TakePhoto:YES]:[mPhotoManager TakePhoto:NO];
        }else if(buttonIndex == 2){
            
        }
        
    }
}
//选中图片回调
- (void)OnPhotoSelect:(PhotoSelectManager *)sender {
    fileway = sender.mLocalPath;
    [headView setImage:[UIImage imageWithContentsOfFile:fileway] forState:UIControlStateNormal];
    headViewIsPick = YES;
    
}
//退出相册管理者类回调
- (void)photoSelectManagerAccessFail{
    
}
-(void)commit
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:_phoneNum forKey:@"mobile"];
    [dict setObject:_password forKey:@"pwd"];
    UITextField *tx0 = (UITextField *)[secView viewWithTag:60000];
    UITextField *tx1 = (UITextField *)[secView viewWithTag:60001];
    UILabel *label2 = (UILabel *)[secView viewWithTag:60002];
    UILabel *label3 = (UILabel *)[secView viewWithTag:60003];
    NSString *sexStr;
    if (tx0.text.length == 0) {
        
    }
    else
    {
        [dict setObject:tx0.text forKey:@"name"];
    }
     if (tx1.text.length == 0)
    {
    
    }
    else
    {
        [dict setObject:tx1.text forKey:@"age"];
    }
    if ([label3.text isEqualToString:@"请输入生日"])
    {

    }
    else
    {
        [dict setObject:label3.text forKey:@"birthday"];
    }
    if ([label2.text isEqualToString:@"女"])
    {
        sexStr = @"0";
        [dict setObject:sexStr forKey:@"sex"];
    }
    else if([label2.text isEqualToString:@"男"])
    {
        sexStr = @"1";
        [dict setObject:sexStr forKey:@"sex"];
    }
    else
    {
        
    }
    
    if (lifePlaceLabel.text.length==0) {
       
    }
    else
    {
        [dict setObject:lifePlaceLabel.text forKey:@"larea"];
        [dict setObject:lifeDic[@"lat"] forKey:@"lat"];
        [dict setObject:lifeDic[@"lng"] forKey:@"lng"];
    }
    if (workPlaceLabel.text.length==0) {
        
    }
    else
    {
        [dict setObject:workPlaceLabel.text forKey:@"garea"];
        [dict setObject:workDic[@"lat"] forKey:@"glat"];
        [dict setObject:workDic[@"lng"] forKey:@"glng"];
    }
    if (activePlaceLabel.text.length==0) {
        
    }
    else
    {
        [dict setObject:activePlaceLabel.text forKey:@"harea"];
        [dict setObject:activeDic[@"lat"] forKey:@"hlat"];
        [dict setObject:activeDic[@"lng"] forKey:@"hlng"];
    }
 
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [user objectForKey:@"deviceToken"];
    if (deviceToken) {
        [dict setObject:deviceToken forKey:@"devicetoken"];
    }
    else
    {
        [dict setObject:@"devicetoken" forKey:@"devicetoken"];
    }
  
    NSString *url = [NSString stringWithFormat:@"%@basicregist",SERVER_URL];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [self StartLoading];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:0];
    if (fileway) {
        [d setObject:fileway forKey:@"file"];
    }
    NSLog(@"%@",dict);
    [_sfManager addUploadTaskWithUrl:url normalParam:dict imageParam:d completion:^(BOOL isSuccess, NSData *data) {
        if (isSuccess) {
            [weakSelf StopLoading];
            if (data && data.length>0) {
                NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (info) {
                    if ([[info[@"code"] stringValue]isEqualToString:@"1"]) {
                        [weakSelf showMsg:@"注册成功"];
                        NSLog(@"%@",info);
                        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                        
                        [user setObject:info[@"token"] forKey:@"token"];
                        [user setObject:weakSelf.phoneNum forKey:@"mobile"];
                        [user setObject:info[@"uid"] forKey:@"uid"];
                        [user setObject:info[@"flag"] forKey:@"flag"];
                        [user synchronize];
                        [[NSNotificationCenter defaultCenter]postNotificationName:ORDERDEAL object:nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:MyQRELOADVC object:nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:PressRELOADVC object:nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:CHANGEUSER object:nil];
                        [weakSelf performSelector:@selector(goToNextPage) withObject:nil afterDelay:1];
                    }
                    else
                    {
                        [weakSelf showMsg:[NSString stringWithFormat:@"%@",info[@"message"]]];
                    }
                }
                else
                {
                    [weakSelf showMsg:@"注册失败"];
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
-(void)goToNextPage
{
    HomeViewController *homeVC = (HomeViewController *)self.tabBarController;
    homeVC.mTabView.miIndex = 0;
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)verifyIDCardNumber:(NSString *)value
 {
        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
            return NO;
    }
        NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
        NSString *leapMmdd = @"0229";
        NSString *year = @"(19|20)[0-9]{2}";
        NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
        NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
        NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
        NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
        NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
        NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
        NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
        int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7+ ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9+ ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10+ ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8  + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2  + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
         NSInteger remainder = summary % 11;
         NSString *checkBit = @"";
         NSString *checkString = @"10X98765432";
         checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
         return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
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

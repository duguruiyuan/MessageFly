//
//  SelfInfoViewController.m
//  MessageFly
//
//  Created by xll on 15/2/11.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SelfInfoViewController.h"
#import "PickDateView.h"
#import "PhotoSelectManager.h"
#import "AgeSelectView.h"
#import "MapViewController.h"
@interface SelfInfoViewController ()<PickDateDelegate,UIActionSheetDelegate,photoSelectManagerDelegate>
{
    UIScrollView *mainSC;
    NSString *pickDate;
    UIView *secView;
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

@implementation SelfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"个人资料" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIButton *setBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 40, 30) bgImageName:nil imageName:nil title:@"修改" selector:@selector(commit) target:self];
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setBtn];
    [self makeUI];
}

-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    mainSC.backgroundColor =[UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 560);
    [self.view addSubview:mainSC];
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, WIDTH, 90)];
    firstView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:firstView];
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 30, 60, 30) title:@"头像" font:17]          ;
    [firstView addSubview:tishi1];
    
    headView = [MyControll createButtonWithFrame:CGRectMake(WIDTH-90, 10, 70, 70) bgImageName:@"picdefault@2x.png" imageName:nil title:nil selector:@selector(headClick) target:self];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 35;
    [firstView addSubview:headView];
    [headView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"face"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang"]];
    
    UIButton *headBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH, 90) bgImageName:nil imageName:nil title:nil selector:@selector(headClick) target:self];
    [firstView addSubview:headBtn];
    
    
    
    secView =[MyControll createToolView5WithFrame:CGRectMake(0, 120, WIDTH, 200) withColor:[UIColor whiteColor] withNameArray:@[@"昵称",@"年龄(岁)",@"性别",@"生日"] withFont:17];
    [mainSC addSubview:secView];
    NSString *str;
    if ([self.dataDic[@"sex"] isEqualToString:@"0"]) {
        str = @"女";
    }
    else
    {
        str = @"男";
    }
    NSArray*nameArray =@[[NSString stringWithFormat:@"%@",self.dataDic[@"name"]],[NSString stringWithFormat:@"%@",self.dataDic[@"age"]],str,[NSString stringWithFormat:@"%@",self.dataDic[@"birthday"]]];
    for (int i=0; i<4; i++) {
        if (i<2) {
            UITextField *textfield = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH-150, i*50, 140, 50) text:nameArray[i] placehold:@"请输入昵称" font:14];
            if (i==1) {
                textfield.placeholder = @"请选择年龄";
            }
            textfield.textAlignment = NSTextAlignmentRight;
            textfield.tag = 60000+i;
            textfield.textColor = [UIColor lightGrayColor];
            if (i==1) {
                textfield.enabled = NO;
            }
            [secView addSubview:textfield];
            if (i==1) {
                textfield.keyboardType = UIKeyboardTypeNumberPad;
            }
        }
       else
       {
           UILabel *label = [MyControll createLabelWithFrame:CGRectMake(WIDTH-150, i*50, 140, 50) title:nameArray[i] font:14];
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
    
    id dicofshenghuo =self.dataDic[@"shenghuo"];
    id dicofgongzuo =self.dataDic[@"gongzuo"];
    id dicofhuodong =self.dataDic[@"huodong"];
    lifePlaceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 0, WIDTH/5*4-85, 50) title:nil font:15];
    [thirdView addSubview:lifePlaceLabel];

    workPlaceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 50, WIDTH/5*4-85, 50) title:nil font:15];
    [thirdView addSubview:workPlaceLabel];

    activePlaceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 100, WIDTH/5*4-85, 50) title:nil font:15];
    [thirdView addSubview:activePlaceLabel];
    if (dicofshenghuo&&[dicofshenghuo isKindOfClass:[NSDictionary class]]) {
        lifePlaceLabel.text= dicofshenghuo[@"address"];
    }
    else
    {
        lifePlaceLabel.text= @"请选择生活区域";
    }
    if (dicofgongzuo&&[dicofgongzuo isKindOfClass:[NSDictionary class]]) {
        workPlaceLabel.text= dicofgongzuo[@"address"];
    }
    else
    {
        workPlaceLabel.text= @"请选择工作区域";
    }
    if (dicofhuodong&&[dicofhuodong isKindOfClass:[NSDictionary class]]) {
        activePlaceLabel.text= dicofhuodong[@"address"];
    }
    else
    {
        activePlaceLabel.text= @"请选择活动区域";
    }
    
    for (int i = 0; i<3; i++) {
        UIView *line = [MyControll createLineWithFrame:CGRectMake(WIDTH-45, i*50, 1, 50) withColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
        [thirdView addSubview:line];
        
        UIButton *mapBtn = [MyControll createButtonWithFrame:CGRectMake(WIDTH-44, i*50, 44, 50) bgImageName:nil imageName:@"p3" title:nil selector:@selector(mapClick:) target:self];
        mapBtn.tag = 200+i;
        [thirdView addSubview:mapBtn];
        
        UIButton *btn = [MyControll createButtonWithFrame:CGRectMake(0, i*50, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(mapClick:) target:self];
        btn.tag  = 200+i;
        [thirdView addSubview:btn];
    }
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
        if (pickDate) {
            pickDateView.showDate = pickDate;
        }
        else{
            if ([self.dataDic[@"birthday"] length]<16) {
                pickDateView.showDate = pickDateView.startDate;
            }
            else{
                pickDateView.showDate = [NSString stringWithFormat:@"%@ 12:00",self.dataDic[@"birthday"]];
            }
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
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
        }
        else if (buttonIndex == 1)
        {
            UILabel *label = (UILabel *)[secView viewWithTag:60000+2];
            label.text = @"女";
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
  
}
//退出相册管理者类回调
- (void)photoSelectManagerAccessFail{
    
}
-(void)commit
{
     [self.view endEditing:YES];
    UITextField *tx0 = (UITextField *)[secView viewWithTag:60000];
    UITextField *tx1 = (UITextField *)[secView viewWithTag:60001];
    UILabel *label2 = (UILabel *)[secView viewWithTag:60002];
    UILabel *label3 = (UILabel *)[secView viewWithTag:60003];
    NSString *sexStr;
    if (tx0.text.length == 0) {
        [self showMsg:@"昵称输入不能为空"];
        return;
    }
    else if (tx1.text.length == 0)
    {
        [self showMsg:@"年龄输入不能为空"];
        return;
    }
    else if (label3.text.length==0)
    {
        [self showMsg:@"出生日期不能为空"];
        return;
    }
    
    if ([label2.text isEqualToString:@"女"])
    {
        sexStr = @"0";
    }
    else
    {
        sexStr = @"1";
    }
    
    [self StartLoading];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:0];
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:token forKey:@"token"];
    [dict setObject:tx0.text forKey:@"name"];
    [dict setObject:sexStr forKey:@"sex"];
    [dict setObject:tx1.text forKey:@"age"];
    [dict setObject:label3.text forKey:@"birthday"];
    if (lifeDic) {
        [dict setObject:lifePlaceLabel.text forKey:@"larea"];
        [dict setObject:lifeDic[@"lat"] forKey:@"lat"];
        [dict setObject:lifeDic[@"lng"] forKey:@"lng"];
    }
   
    if (workDic) {
        [dict setObject:workPlaceLabel.text forKey:@"garea"];
        [dict setObject:workDic[@"lat"] forKey:@"glat"];
        [dict setObject:workDic[@"lng"] forKey:@"glng"];
    }
    if (activeDic) {
        [dict setObject:activePlaceLabel.text forKey:@"harea"];
        [dict setObject:activeDic[@"lat"] forKey:@"hlat"];
        [dict setObject:activeDic[@"lng"] forKey:@"hlng"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@updateuserinfo",SERVER_URL];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithCapacity:0];
    if (fileway) {
        [d setObject:fileway forKey:@"file"];
    }
    [_sfManager addUploadTaskWithUrl:url normalParam:dict imageParam:d completion:^(BOOL isSuccess, NSData *data) {
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
                        [weakSelf showMsg:@"修改个人资料成功"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:CHANGEUSER object:nil];
                        [weakSelf performSelector:@selector(GoBack) withObject:nil afterDelay:1];
                    }
                    else
                    {
                        [weakSelf showMsg:dict[@"message"]];
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
-(void)endSomething
{
    [self StopLoading];
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

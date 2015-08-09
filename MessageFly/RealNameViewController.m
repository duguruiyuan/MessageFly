//
//  RealNameViewController.m
//  MessageFly
//
//  Created by xll on 15/2/25.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "RealNameViewController.h"
#import "PhotoSelectManager.h"
#import "MapViewController.h"
@interface RealNameViewController ()<UIActionSheetDelegate,photoSelectManagerDelegate>
{
    UIScrollView *mainSC;
    UITextField *nickNameTX;
    UITextField *IDNumTX;
    UIButton *headView;
    UIButton *IDPicView;

    PhotoSelectManager *mPhotoManager;
    NSString *headImagePath;
    NSString *idImagePath;

}
@property(nonatomic,strong)ServerFetcherManager *sfManager;@end

@implementation RealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [MyControll createLabelWithFrame:CGRectMake(0, 0, 50, 35) title:@"实名认证" font:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    UIButton *backBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, 60, 30) bgImageName:nil imageName:@"16@2x_03" title:nil selector:@selector(GoBack) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self makeUI];
}
-(void)makeUI
{
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.backgroundColor =[UIColor colorWithRed:0.95f green:0.94f blue:0.96f alpha:1.00f];
    mainSC.contentSize = CGSizeMake(WIDTH, 715);
    [self.view addSubview:mainSC];
    
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake(20, 15, 150, 20) title:@"真实姓名" font:15];
    [mainSC addSubview:tishi1];
    
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, WIDTH, 50)];
    firstView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:firstView];
    
    nickNameTX = [MyControll createTextFieldWithFrame:CGRectMake(20, 10, WIDTH-40, 30) text:nil placehold:@"请输入真实姓名" font:16];
    [firstView addSubview:nickNameTX];
    
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake(20, 110, 150, 20) title:@"身份证号码" font:15];
    [mainSC addSubview:tishi2];
    
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 140, WIDTH, 50)];
    secView.backgroundColor  = [UIColor whiteColor];
    [mainSC addSubview:secView];
    
    IDNumTX = [MyControll createTextFieldWithFrame:CGRectMake(20, 10, WIDTH-40, 30) text:nil placehold:@"请输入身份证号码" font:16];
    IDNumTX.clearButtonMode = UITextFieldViewModeWhileEditing;
    [secView addSubview:IDNumTX];
    
    UILabel *tishi3 = [MyControll createLabelWithFrame:CGRectMake(20, 205, WIDTH-40, 40) title:@"点击上传身份证正面照和真实头像照，所上传资料只用于审核，不会对外公开" font:13];
    tishi3.textColor= [UIColor colorWithRed:0.51f green:0.51f blue:0.51f alpha:1.00f];
    tishi3.numberOfLines = 2;
    [mainSC addSubview:tishi3];
    
    UIView *picView = [[UIView alloc]initWithFrame:CGRectMake(0, 255, WIDTH, 135)];
    picView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:picView];
    
    headView = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2-80)/2, 15, 80, 80) bgImageName:nil imageName:@"22@2x" title:nil selector:@selector(selectPicClick:) target:self];
    headView.tag = 100;
    [picView addSubview:headView];
    
    IDPicView = [MyControll createButtonWithFrame:CGRectMake((WIDTH/2-80)/2 + WIDTH/2, 15, 80, 80) bgImageName:nil imageName:@"22@2x" title:nil selector:@selector(selectPicClick:) target:self];
    IDPicView.tag = 101;
    [picView addSubview:IDPicView];
    
    UILabel *headLabel = [MyControll createLabelWithFrame:CGRectMake((WIDTH/2-120)/2, 105, 120, 20) title:@"真实头像照" font:14];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [picView addSubview:headLabel];
    
    UILabel *IDLabel = [MyControll createLabelWithFrame:CGRectMake((WIDTH/2-120)/2+ WIDTH/2, 105, 120, 20) title:@"身份证正面照" font:14];
    IDLabel.textAlignment = NSTextAlignmentCenter;
    [picView addSubview:IDLabel];

    UIButton *commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, CGRectGetMaxY(picView.frame)+20, 260, 40) bgImageName:nil imageName:@"m23@2x" title:nil selector:@selector(commit) target:self];
    [mainSC addSubview:commit];
    mainSC.contentSize = CGSizeMake(WIDTH, CGRectGetMaxY(commit.frame)+20);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *flag = [user objectForKey:@"flag"];
    if (flag&&([flag isEqual:@"2"]||[flag isEqualToString:@"1"])) {
        NSString *name = [user objectForKey:@"name"];
        NSString *icnum = [user objectForKey:@"icnum"];
        NSString *face = [user objectForKey:@"face"];
        NSString *image = [user objectForKey:@"image"];
        nickNameTX.text = name;
        nickNameTX.textColor = [UIColor lightGrayColor];
        nickNameTX.enabled = NO;
        IDNumTX.text = icnum; 
        IDNumTX.textColor = [UIColor lightGrayColor];
        IDNumTX.enabled = NO;
        [headView sd_setImageWithURL:[NSURL URLWithString:face] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"picdefault@2x"]];
        headView.enabled = NO;
        [IDPicView sd_setImageWithURL:[NSURL URLWithString:image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"picdefault@2x"]];
        IDPicView.enabled = NO;
        commit.hidden = YES;
    
    }
}
-(void)selectPicClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册" ,nil];
        sheet.tag = 1000;
        [sheet showInView:self.view];
    }
    else
    {
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册" ,nil];
        sheet.tag = 1001;
        [sheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1000) {
        if (buttonIndex == 0 || buttonIndex == 1) {
            mPhotoManager = [[PhotoSelectManager alloc] init];
            mPhotoManager.mRootCtrl = self;
            mPhotoManager.delegate = self;
            mPhotoManager.photoDelegate = self;
            mPhotoManager.mDefaultName = @"headimage.png";
            mPhotoManager.mbEdit = YES;
            mPhotoManager.OnPhotoSelect = @selector(headImageSelect:);
            buttonIndex == 0?[mPhotoManager TakePhoto:YES]:[mPhotoManager TakePhoto:NO];
        }
    }
    else
    {
        if (buttonIndex == 0 || buttonIndex == 1) {
            mPhotoManager = [[PhotoSelectManager alloc] init];
            mPhotoManager.mRootCtrl = self;
            mPhotoManager.delegate = self;
            mPhotoManager.photoDelegate = self;
            mPhotoManager.mDefaultName = @"headimage.png";
            mPhotoManager.mbEdit = YES;
            mPhotoManager.OnPhotoSelect = @selector(idImageSelect:);
            buttonIndex == 0?[mPhotoManager TakePhoto:YES]:[mPhotoManager TakePhoto:NO];
        }
    }
}
//选中图片回调
- (void)headImageSelect:(PhotoSelectManager *)sender {
    UIImage *image =  [UIImage imageWithContentsOfFile:sender.mLocalPath];
    
    NSData *data = nil;
    NSString *picType;
    if (UIImagePNGRepresentation(image)) {
        
        data = UIImageJPEGRepresentation(image, 0.8);
        picType = @"jpg";
    }else{
        data = UIImageJPEGRepresentation(image, 0.8);
        picType = @"jpg";
    }
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    filePath = [filePath stringByAppendingPathComponent:@"myCaches"];
    NSDate *date =[NSDate date];
    NSString *str = [NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]];
    filePath = [NSString stringWithFormat:@"%@/%@.%@",filePath,str,picType];
    [data writeToFile:filePath atomically:YES];
    headImagePath = filePath;
    [headView setImage:[UIImage imageWithContentsOfFile:headImagePath] forState:UIControlStateNormal];
}
//选中图片回调
- (void)idImageSelect:(PhotoSelectManager *)sender {
    UIImage *image =  [UIImage imageWithContentsOfFile:sender.mLocalPath];
    
    NSData *data = nil;
    NSString *picType;
    if (UIImagePNGRepresentation(image)) {
        
        data = UIImageJPEGRepresentation(image, 0.8);
        picType = @"jpg";
    }else{
        data = UIImageJPEGRepresentation(image, 0.8);
        picType = @"jpg";
    }
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    filePath = [filePath stringByAppendingPathComponent:@"myCaches"];
    NSDate *date =[NSDate date];
    NSString *str = [NSString stringWithFormat:@"%d",(int)[date timeIntervalSince1970]];
    filePath = [NSString stringWithFormat:@"%@/%@.%@",filePath,str,picType];
    [data writeToFile:filePath atomically:YES];
    idImagePath = filePath;
    
    [IDPicView setImage:[UIImage imageWithContentsOfFile:idImagePath] forState:UIControlStateNormal];
}
//退出相册管理者类回调
- (void)photoSelectManagerAccessFail{
    
}
-(void)commit
{
    if (![self verifyIDCardNumber:IDNumTX.text]) {
        [self showMsg:@"身份证格式不正确"];
        return;
    }
    else if([nickNameTX.text isEqualToString:@""])
    {
        [self showMsg:@"请输入你的真实姓名"];
        return;
    }
    else if(!headImagePath)
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *flag = [user objectForKey:@"flag"];
        if ([flag isEqualToString:@"2"]||[flag isEqualToString:@"3"]) {
            
        }
        else
        {
            [self showMsg:@"请上传你的真实头像"];
            return;
        }
    }
    else if(!idImagePath)
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *flag = [user objectForKey:@"flag"];
        if ([flag isEqualToString:@"2"]||[flag isEqualToString:@"3"]) {
            
        }
        else
        {
        [self showMsg:@"请上传你的身份证正面照"];
        return;
        }
    }
    [self regist];
}
-(void)regist
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (nickNameTX.text.length==0) {
        [dict setObject:@"" forKey:@"name"];
    }
    else
    {
        [dict setObject:nickNameTX.text forKey:@"name"];
    }
    [dict setObject:IDNumTX.text forKey:@"icard"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid = [user objectForKey:@"uid"];
    NSString *token = [user objectForKey:@"token"];
     NSString *deviceToken  =  [user objectForKey:@"deviceToken"];
    if (deviceToken) {
        [dict setObject:deviceToken forKey:@"devicetoken"];
    }
    else
    {
        [dict setObject:@"devicetoken" forKey:@"devicetoken"];
    }
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:token forKey:@"token"];
      NSString *url = [NSString stringWithFormat:@"%@realname",SERVER_URL];
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
    [self StartLoading];
   
    
    NSString *flag = [user objectForKey:@"flag"];
    if ([flag isEqualToString:@"2"]||[flag isEqualToString:@"3"]) {
        NSLog(@"%@",dict);
        [_sfManager addUploadTaskWithUrl:url normalParam:dict imageParam:nil completion:^(BOOL isSuccess, NSData *data) {
            if (isSuccess) {
                [weakSelf StopLoading];
                if (data && data.length>0) {
                    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if ([[info[@"code"] stringValue]isEqualToString:@"1"]) {
                        [weakSelf showMsg:@"修改成功"];

                        [user setObject:info[@"list"][@"rname"] forKey:@"name"];
                        [user setObject:info[@"list"][@"icnum"] forKey:@"icnum"];
                        [user setObject:info[@"list"][@"image"] forKey:@"image"];
                        [user setObject:info[@"list"][@"rface"] forKey:@"face"];
                        [user synchronize];
                        
                        [weakSelf performSelector:@selector(GoBack) withObject:nil afterDelay:1];
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
    else
    {
          NSLog(@"%@",dict);
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        if (headImagePath) {
            [dic setObject:headImagePath forKey:@"file"];
        }
        if (idImagePath) {
            [dic setObject:idImagePath forKey:@"video"];
        }
        NSLog(@"%@~%@",dict,dic);
        [_sfManager addUploadTaskWithUrl:url normalParam:dict imageParam:dic completion:^(BOOL isSuccess, NSData *data) {
            if (isSuccess) {
                [weakSelf StopLoading];
                if (data && data.length>0) {
                    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if ([[info[@"code"] stringValue]isEqualToString:@"1"]) {
                        [weakSelf showMsg:@"认证成功,等待通知"];
                        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                        [user setObject:@"1" forKey:@"flag"];
                        
                        [user setObject:info[@"list"][@"rname"] forKey:@"name"];
                        [user setObject:info[@"list"][@"icnum"] forKey:@"icnum"];
                        [user setObject:info[@"list"][@"image"] forKey:@"image"];
                        [user setObject:info[@"list"][@"rface"] forKey:@"face"];
                        [user synchronize];
                        [weakSelf performSelector:@selector(GoBack) withObject:nil afterDelay:1];
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

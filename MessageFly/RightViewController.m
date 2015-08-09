//
//  RightViewController.m
//  MessageFly
//
//  Created by xll on 15/4/1.
//  Copyright (c) 2015年 xll. All rights reserved.
//
#define  TopicMaxLength 5
#import "RightViewController.h"
#import "TimeSelectView.h"
#import "VoiceBtnView.h"
#import "LoginViewController.h"
#import "RealNameViewController.h"
#import "ChargeViewController.h"
@interface RightViewController ()<UIScrollViewDelegate,PicSelectDelegate,TimeSelectDelegate,UIAlertViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    UIScrollView *mainSC;
    UIView *firstView;
    UITextView *contentView;
    UITextField *moneyTX;
    UITextField *timeTX;
    UILabel *sexLabel;
    RadiusView *radiusView;
    SexSelectView *sexView;
    
    UILabel *timeLabel;
    UILabel *finalPlaceLabel;
    UILabel *toufangPlaceLabel;
    UILabel *radiusLabel;
    UIView *fourView;
    int deletePicNum;
    
    UIButton*voiceBtn;
    
    MyRecord *record ;
    double timeLength;
    
    VoiceBtnView *voiceBtnView;
    
    BOOL ifHasVoice;
    UIView *fifthView;
    UIView *sixView;
    UIButton *commit;
    UITextView *jiguanView;
    UILabel *jiguantishi;
}
@property(nonatomic,strong)NSDictionary *finalDic;
@property(nonatomic,strong)NSDictionary *toufangDic;
@property(nonatomic,strong)NSMutableArray *uploadPicArray;
@property(nonatomic,strong)ServerFetcherManager *sfManager;
@end

@implementation RightViewController
-(void)viewDidDisappear:(BOOL)animated
{
    [voiceBtnView stopPlay];
}
-(void)dealloc
{
    UITextField *tx = (UITextField *)[firstView viewWithTag:20000];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:tx];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    ifHasVoice = NO;
    self.uploadPicArray = [NSMutableArray arrayWithCapacity:0];
    mainSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,  HEIGHT-64-50-40)];
    mainSC.showsVerticalScrollIndicator = NO;
    mainSC.delegate = self;
    mainSC.contentSize = CGSizeMake(WIDTH, 1145);
    [self.view addSubview:mainSC];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    firstView =[MyControll createToolView2WithFrame:CGRectMake(0, 15, WIDTH, 300) withColor:[UIColor whiteColor] withNameArray:@[@"姓名",@"性别",@"年龄",@"籍贯",@"身高(cm)",@"体重(kg)"]];
    [mainSC addSubview:firstView];
    NSArray *placeholdArray = @[@"请输入姓名",@"",@"请输入年龄",@"",@"请输入身高",@"请输入体重"];
    for (int i = 0; i<6; i++) {
        if (i!=1&&i!=3) {
            UITextField *tx = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH/5+40, 10+ i*50, WIDTH/5*4-50, 30) text:nil placehold:placeholdArray[i] font:15];
            tx.text = @"";
            tx.tag = 20000+i;
            if (i==2||i==4||i==5) {
                tx.delegate = self;
                tx.keyboardType = UIKeyboardTypeNumberPad;
            }
            tx.textAlignment = NSTextAlignmentRight;
            [firstView addSubview:tx];
        }
        else if (i==3)
        {
            jiguanView = [[UITextView alloc]initWithFrame:CGRectMake(WIDTH/5+40, 10+i*50, WIDTH/5*4-50, 30)];
            jiguanView.font = [UIFont systemFontOfSize:15];
            jiguanView.delegate = self;
            jiguanView.textAlignment = NSTextAlignmentRight;
            [firstView addSubview:jiguanView];
        }
        else if (i==1)
        {
            sexLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/5+40, 60, WIDTH/5*4-50, 30) title:@"女" font:15];
            sexLabel.textAlignment = NSTextAlignmentRight;
            sexLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.82f alpha:1.00f];
            [firstView addSubview:sexLabel];
            sexLabel.userInteractionEnabled = YES;
            UIButton *sexBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(sexClick) target:self];
            [sexLabel addSubview:sexBtn];
            
        }
        
    }
    
    jiguantishi = [MyControll createLabelWithFrame:CGRectMake(WIDTH-150, 160, 140, 30) title:@"请输入籍贯" font:15];
    jiguantishi.textColor = [UIColor colorWithRed:0.82f green:0.82f blue:0.84f alpha:1.00f];
    jiguantishi.textAlignment = NSTextAlignmentRight;
    [firstView addSubview:jiguantishi];
    
    
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(20, 330, 150, 20) title:@"语音描述" font:15];
    [mainSC addSubview:tishi];
    
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 360, WIDTH, 80)];
    secView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:secView];
    
    voiceBtn = [MyControll createButtonWithFrame:CGRectMake((WIDTH-240)/2, 15, 240, 50) bgImageName:nil imageName:@"15@2x" title:nil selector:nil target:self];
    [secView addSubview:voiceBtn];
    [voiceBtn addTarget:self action:@selector(voiceClick) forControlEvents:UIControlEventTouchDown];
    [voiceBtn addTarget:self action:@selector(voiceStop) forControlEvents:UIControlEventTouchUpInside];
    [voiceBtn addTarget:self action:@selector(voiceStop) forControlEvents:UIControlEventTouchUpOutside];
    
    voiceBtnView = [[VoiceBtnView alloc]initWithFrame:CGRectMake((WIDTH-260)/2, 15, 260, 50)];
    voiceBtnView.myBlock = ^(VoiceBtnView *myView)
    {
        ifHasVoice = NO;
        voiceBtn.hidden = NO;
        voiceBtnView.hidden = YES;
    };
    voiceBtnView.hidden = YES;
    [secView addSubview:voiceBtnView];
    
    UILabel *tishi1 = [MyControll createLabelWithFrame:CGRectMake((voiceBtn.frame.size.width-140)/2, 0, 140, 50) title:@"按住说话" font:15];
    tishi1.textAlignment = NSTextAlignmentCenter;
    tishi1.textColor = [UIColor whiteColor];
    [voiceBtn addSubview:tishi1];
    
    UILabel *tishi3 = [MyControll createLabelWithFrame:CGRectMake(20, 455, 150, 20) title:@"文字描述" font:15];
    [mainSC addSubview:tishi3];
    
    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, 485, WIDTH, 100)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:thirdView];
    
    contentView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, WIDTH-40, 80)];
    contentView.text = @"";
    contentView.font = [UIFont systemFontOfSize:15];
    [thirdView addSubview:contentView];
    
    
    UILabel *tishi4 = [MyControll createLabelWithFrame:CGRectMake(20, 600, 150, 20) title:@"图片描述" font:15];
    [mainSC addSubview:tishi4];
    
    fourView = [[UIView alloc]initWithFrame:CGRectMake(0, 630, WIDTH, 90)];
    fourView.backgroundColor = [UIColor whiteColor];
    [mainSC addSubview:fourView];
    
    UIButton *addPic = [MyControll createButtonWithFrame:CGRectMake(20, 10, 70, 70) bgImageName:@"22@2x" imageName:nil title:nil selector:@selector(addPicClick) target:self];
    [fourView addSubview:addPic];
    
    
    
    fifthView = [MyControll createToolView4WithFrame:CGRectMake(0, 735, WIDTH, 150) withColor:[UIColor whiteColor] withNameArray:@[@"失踪时间",@"有效时长:",@"线索酬金:"]];
    [mainSC addSubview:fifthView];
    
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH-WIDTH/2-40, 0, WIDTH/2, 50) title:nil font:15];
    timeLabel.text = @"请选择时间";
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [fifthView addSubview:timeLabel];
    UIImageView *xiala = [MyControll createImageViewWithFrame:CGRectMake(WIDTH-30, 0, 17, 50) imageName:@"9@2x"];
    xiala.contentMode = UIViewContentModeScaleAspectFit;
    [fifthView addSubview:xiala];
    
    UIButton *timeBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(timeClick) target:self];
    [fifthView addSubview:timeBtn];
    
    
    UIButton *reduceBtn1 = [MyControll createButtonWithFrame:CGRectMake(WIDTH- 210, 105, 40, 40) bgImageName:nil imageName:@"o9@2x" title:nil selector:@selector(moneyClick:) target:self];
    reduceBtn1.tag = 100;
    reduceBtn1.clipsToBounds = YES;
    reduceBtn1.layer.cornerRadius= 3;
    [fifthView addSubview:reduceBtn1];
    moneyTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH-165, 110, 70, 30) text:@"10" placehold:nil font:15];
    moneyTX.textAlignment = NSTextAlignmentCenter;
    moneyTX.clipsToBounds = YES;
    moneyTX.keyboardType = UIKeyboardTypeNumberPad;
    moneyTX.layer.cornerRadius = 5;
    moneyTX.layer.borderWidth = 0.5;
    moneyTX.layer.borderColor = [[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]CGColor];
    [fifthView addSubview:moneyTX];
    
    UIButton *addBtn1 =[MyControll createButtonWithFrame:CGRectMake(WIDTH-90, 105, 40, 40) bgImageName:nil imageName:@"o11@2x" title:nil selector:@selector(moneyClick:) target:self];
    addBtn1.tag = 101;
    addBtn1.clipsToBounds = YES;
    addBtn1.layer.cornerRadius= 3;
    [fifthView addSubview:addBtn1];
    
    UILabel *tishi5 = [MyControll createLabelWithFrame:CGRectMake(WIDTH-45, 105, 40, 40) title:@"元/人" font:14];
    [fifthView addSubview:tishi5];
    
    UIButton *reduceBtn2 = [MyControll createButtonWithFrame:CGRectMake(WIDTH- 210, 55, 40, 40) bgImageName:nil imageName:@"o9@2x" title:nil selector:@selector(moneyClick:) target:self];
    reduceBtn2.tag = 102;
    reduceBtn2.clipsToBounds = YES;
    reduceBtn2.layer.cornerRadius= 3;
    [fifthView addSubview:reduceBtn2];
    timeTX = [MyControll createTextFieldWithFrame:CGRectMake(WIDTH-165, 60, 70, 30) text:@"10" placehold:nil font:15];
    timeTX.textAlignment = NSTextAlignmentCenter;
    timeTX.clipsToBounds = YES;
    timeTX.keyboardType = UIKeyboardTypeNumberPad;
    timeTX.layer.cornerRadius = 5;
    timeTX.layer.borderWidth = 0.5;
    timeTX.layer.borderColor = [[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]CGColor];
    [fifthView addSubview:timeTX];
    
    UIButton *addBtn2 =[MyControll createButtonWithFrame:CGRectMake(WIDTH-90, 55, 40, 40) bgImageName:nil imageName:@"o11@2x" title:nil selector:@selector(moneyClick:) target:self];
    addBtn2.tag = 103;
    addBtn2.clipsToBounds = YES;
    addBtn2.layer.cornerRadius= 3;
    [fifthView addSubview:addBtn2];
    UILabel *tishi6 = [MyControll createLabelWithFrame:CGRectMake(WIDTH-45, 55, 40, 40) title:@"小时" font:14];
    [fifthView addSubview:tishi6];
    
    sixView = [MyControll createToolView4WithFrame:CGRectMake(0, 900, WIDTH, 150) withColor:[UIColor whiteColor] withNameArray:@[@"确认最后位置",@"投放地址",@"投放半径(km)"]];
    [mainSC addSubview:sixView];
    
    finalPlaceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2-20, 0, WIDTH/2-25, 50) title:nil font:15];
    finalPlaceLabel.text = @"";
    [sixView addSubview:finalPlaceLabel];
    
    UIButton *finalBtn = [MyControll createButtonWithFrame:CGRectMake(0, 0, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(mapClick:) target:self];
    finalBtn.tag = 200;
    [sixView addSubview:finalBtn];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *myplace = [user objectForKey:@"myplace"];
    toufangPlaceLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2-20, 50, WIDTH/2-25, 50) title:nil font:15];
    toufangPlaceLabel.text = myplace;
    toufangPlaceLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.82f alpha:1.00f];
    [sixView addSubview:toufangPlaceLabel];
    
    UIButton *toufangBtn = [MyControll createButtonWithFrame:CGRectMake(0, 50, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(mapClick:) target:self];
    toufangBtn.tag = 201;
    [sixView addSubview:toufangBtn];
    
    radiusLabel = [MyControll createLabelWithFrame:CGRectMake(WIDTH/2, 100, WIDTH/2-10, 50) title:@"2km" font:15];
    radiusLabel.textAlignment =NSTextAlignmentRight;
    [sixView addSubview:radiusLabel];
    
    UIButton *radiusBtn = [MyControll createButtonWithFrame:CGRectMake(0, 100, WIDTH, 50) bgImageName:nil imageName:nil title:nil selector:@selector(choseRadiusClick) target:self];
    [sixView addSubview:radiusBtn];
    
    UIView *line_1 = [MyControll createLineWithFrame:CGRectMake(WIDTH-40, 10, 1, 30) withColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
    [sixView addSubview:line_1];
    
    UIButton *mapBtn1 = [MyControll createButtonWithFrame:CGRectMake(WIDTH-39, 0, 39, 50) bgImageName:nil imageName:@"p3" title:nil selector:@selector(mapClick:) target:self];
    mapBtn1.tag = 200;
    [sixView addSubview:mapBtn1];
    
    UIView *line_2 = [MyControll createLineWithFrame:CGRectMake(WIDTH-40, 60, 1, 30) withColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
    [sixView addSubview:line_2];
    
    UIButton *mapBtn2 = [MyControll createButtonWithFrame:CGRectMake(WIDTH-39, 50, 39, 50) bgImageName:nil imageName:@"p3" title:nil selector:@selector(mapClick:) target:self];
    mapBtn2.tag = 201;
    [sixView addSubview:mapBtn2];
    
    
    commit = [MyControll createButtonWithFrame:CGRectMake((WIDTH-260)/2, 1075, 260, 45) bgImageName:nil imageName:@"p1" title:nil selector:@selector(commit) target:self];
    [mainSC addSubview:commit];
    
    UITextField *tx = (UITextField *)[firstView viewWithTag:20000];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:tx];
}
- (void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > TopicMaxLength) {
                textField.text = [toBeString substringToIndex:TopicMaxLength];
            }
        }else {
        }
    }else {
        if (toBeString.length > TopicMaxLength) {
            textField.text = [toBeString substringToIndex:TopicMaxLength];
        }
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > 3 && range.length!=1){
        textField.text = [toBeString substringToIndex:3];
        return NO;
        
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView1
{
    if (jiguanView.text.length==0) {
        jiguantishi.hidden = NO;
    }
    else
    {
        jiguantishi.hidden = YES;
    }
}
-(void)sexClick
{
    [self.view endEditing:YES];
    if (sexView) {
        return;
    }
    sexView = [[SexSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [[UIScreen mainScreen]bounds].size.height)];
    sexView.myBlock = ^(NSString *str)
    {
        if ([str isEqualToString:@""]) {
           sexView = nil;
        }
        else
        {
            sexLabel.text = str;
            sexLabel.textColor = [UIColor blackColor];
            sexView = nil;
        }
};
    [self.tabBarController.view addSubview:sexView];
}
-(void)mapClick:(UIButton *)sender
{
    if (sender.tag == 200) {
        MapViewController *vc = [[MapViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.myLocaltionBlock = ^(NSDictionary *dic)
        {
            finalPlaceLabel.text = dic[@"placename"];
            _finalDic = [NSDictionary dictionaryWithDictionary:dic];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender.tag == 201)
    {
        MapViewController *vc = [[MapViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.myLocaltionBlock = ^(NSDictionary *dic)
        {
            toufangPlaceLabel.text = dic[@"placename"];
            toufangPlaceLabel.textColor = [UIColor blackColor];
            _toufangDic = [NSDictionary dictionaryWithDictionary:dic];
        };
        [self.navigationController pushViewController:vc animated:YES];
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
-(void)choseRadiusClick
{
    if (radiusView) {
        return;
    }
    radiusView = [[RadiusView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [[UIScreen mainScreen]bounds].size.height)];
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
        fourView.frame = CGRectMake(0, 630, WIDTH, picHeight+20);
        fifthView.frame = CGRectMake(0, fourView.frame.origin.y+fourView.frame.size.height+15, WIDTH, 150);
        sixView.frame = CGRectMake(0, fifthView.frame.origin.y+fifthView.frame.size.height+15, WIDTH, 150);
        commit.frame = CGRectMake(0, sixView.frame.origin.y+sixView.frame.size.height+25, WIDTH, 45);
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
        fourView.frame = CGRectMake(0, 630, WIDTH, picHeight+20);
        fifthView.frame = CGRectMake(0, fourView.frame.origin.y+fourView.frame.size.height+15, WIDTH, 150);
        sixView.frame = CGRectMake(0, fifthView.frame.origin.y+fifthView.frame.size.height+15, WIDTH, 150);
        commit.frame = CGRectMake(0, sixView.frame.origin.y+sixView.frame.size.height+25, WIDTH, 45);
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
    else
    {
        if (buttonIndex == 1) {
            LoginViewController  *vc = [[LoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)timeClick
{
    TimeSelectView *timeSelectView = [[TimeSelectView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [[UIScreen mainScreen]bounds].size.height)];
    timeSelectView.delegate = self;
    timeSelectView.tag = 502;
    [self.tabBarController.view addSubview:timeSelectView];
}
-(void)timeSelect:(TimeSelectView *)timeSelectView1 TimeStr:(NSString *)timeStr1
{
    if (![timeStr1 isEqualToString:@"0"]) {
        timeLabel.text = timeStr1;
        timeLabel.textColor = [UIColor blackColor];
    }
    TimeSelectView *timeSelectView = (TimeSelectView*)[self.tabBarController.view viewWithTag:502];
    [timeSelectView removeFromSuperview];
}
-(void)voiceClick
{
    mainSC.scrollEnabled = NO;
    record = [MyRecord sharedInstance];
    [record startRecord];
    [self showVoiceLoadingView];
}
-(void)goToNext
{
    ifHasVoice = YES;
    voiceBtn.hidden = YES;
    voiceBtnView.voiceLength =timeLength;
    [voiceBtnView passData];
    voiceBtnView.filePath = record.recordPath;
    voiceBtnView.hidden = NO;
}
-(void)voiceStop
{
    mainSC.scrollEnabled = YES;
    [record stopRecord];
    timeLength = record.voiceLength;
    if (timeLength<1.0) {
        [self showMsg:@"录音太短"];
        [self hideVoiceLoadingView];
        return;
    }
    [self hideVoiceLoadingView];
    //    [record playAudio:voicePath];
    
    [self performSelector:@selector(goToNext) withObject:nil afterDelay:0.2];
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
    UITextField *tx0 = (UITextField *)[firstView viewWithTag:20000];
    UITextField *tx2 = (UITextField *)[firstView viewWithTag:20002];
//    UITextField *tx3 = (UITextField *)[firstView viewWithTag:20003];
    UITextField *tx4 = (UITextField *)[firstView viewWithTag:20004];
    UITextField *tx5 = (UITextField *)[firstView viewWithTag:20005];
    if (tx0.text.length==0) {
        [self showMsg:@"姓名输入不能为空"];
        return;
    }
    else if (tx2.text.length == 0)
    {
        [self showMsg:@"年龄不能为空"];
        return;
    }
    else if (jiguanView.text.length==0)
    {
        [self showMsg:@"籍贯不能为空"];
        return;
    }
    else if ([timeLabel.text isEqualToString:@"请选择时间"])
    {
        [self showMsg:@"失踪时间不能为空"];
        return;
    }
    else if (timeTX.text.length==0)
    {
        [self showMsg:@"有效时长不能为空"];
        return;
    }
    else if (moneyTX.text.length==0)
    {
        [self showMsg:@"线索酬金不能为空"];
        return;
    }
    else if (toufangPlaceLabel.text.length==0)
    {
        [self showMsg:@"投放地址不能为空"];
        return;
    }
    else if (finalPlaceLabel.text.length==0)
    {
        [self showMsg:@"最后确认位置不能为空"];
        return;
    }
    else if (radiusLabel.text.length==0)
    {
        [self showMsg:@"投放半径不能为空"];
        return;
    }
    else if ([sexLabel.text isEqualToString:@""])
    {
        [self showMsg:@"性别填写不能为空"];
        return;
    }
//    else if (contentView.text.length==0)
//    {
//        [self showMsg:@"文字描述不能为空"];
//        return;
//    }

    NSString *url = [NSString stringWithFormat:@"%@careateorder1",SERVER_URL];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:uid forKey:@"uid"];
    [dict setObject:token forKey:@"token"];
    [dict setObject:tx0.text forKey:@"name"];
    if ([sexLabel.text isEqualToString:@"男"]) {
        [dict setObject:@"1" forKey:@"sex"];
    }
    else
    {
        [dict setObject:@"0" forKey:@"sex"];
    }
    [dict setObject:tx2.text forKey:@"age"];
    [dict setObject:jiguanView.text forKey:@"address"];
    [dict setObject:tx4.text forKey:@"height"];
    [dict setObject:tx5.text forKey:@"weight"];
//    [dict setObject:contentView.text forKey:@"text"];
    [dict setObject:timeLabel.text forKey:@"ltime"];
    [dict setObject:timeTX.text forKey:@"hour"];
    [dict setObject:moneyTX.text forKey:@"money"];
    [dict setObject:finalPlaceLabel.text forKey:@"zaddress"];
    if (!_finalDic) {
        [dict setObject:@"" forKey:@"zlat"];
        [dict setObject:@"" forKey:@"zlng"];
    }
    else
    {
        [dict setObject:_finalDic[@"lat"] forKey:@"zlat"];
        [dict setObject:_finalDic[@"lng"] forKey:@"zlng"];
    }
    [dict setObject:toufangPlaceLabel.text forKey:@"taddress"];
    if (!_toufangDic) {
//        [dict setObject:@"" forKey:@"zlat"];
//        [dict setObject:@"" forKey:@"zlng"];
//        [dict setObject:@"" forKey:@"city"];
//        [dict setObject:@"" forKey:@"taddress"];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *myplace = [user objectForKey:@"myplace"];
        NSString *mycity = [user objectForKey:@"mycity"];
        NSString *lat  =[user objectForKey:@"lat"];
        NSString *lng = [user objectForKey:@"lng"];
        [dict setObject:mycity forKey:@"city"];
        [dict setObject:myplace forKey:@"address"];
        [dict setObject:lat forKey:@"zlat"];
        [dict setObject:lng forKey:@"zlng"];
    }
    else
    {
        [dict setObject:_toufangDic[@"lat"] forKey:@"tlat"];
        [dict setObject:_toufangDic[@"lng"] forKey:@"tlng"];
        [dict setObject:_toufangDic[@"cityname"] forKey:@"city"];
        [dict setObject:_toufangDic[@"placename"] forKey:@"taddress"];
    }
    [dict setObject:@"" forKey:@"paddress"];
    [dict setObject:[radiusLabel.text substringToIndex:radiusLabel.text.length-2] forKey:@"radis"];
    [dict setObject:[NSString stringWithFormat:@"%f",(float)timeLength] forKey:@"videosec"];
    
    NSLog(@"%@~~~%@",url,dict);
    __weak typeof(self) weakSelf=self;
    _sfManager = [ServerFetcherManager sharedServerManager];
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.uploadPicArray.count>0) {
        for (int i = 0; i<self.uploadPicArray.count; i++) {
            [dic setObject:self.uploadPicArray[i] forKey:[NSString stringWithFormat:@"file[%d]",i]];
        }
    }
    
    NSLog(@"picDic%@ ~%@",dic,record.recordPath);
    if (ifHasVoice) {
        if (contentView.text.length==0)
        {
            [dict setObject:@"" forKey:@"text"];
        }
        else
        {
            [dict setObject:contentView.text forKey:@"text"];
        }
        [self StartLoading];
        
        [_sfManager addUploadTaskWithUrl:url normalParam:dict images:dic voices:@{@"video":record.recordPath} completion:^(BOOL isSuccess, NSData *data) {
            if (isSuccess) {
                [weakSelf StopLoading];
                if (data && data.length>0) {
                    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if ([[info[@"code"] stringValue]isEqualToString:@"1"]) {
                        [weakSelf showMsg:@"发布成功"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:ORDERDEAL object:nil];
                        [weakSelf performSelector:@selector(doSomething) withObject:nil afterDelay:1];
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
    else
    {
        if (contentView.text.length==0)
        {
            [self showMsg:@"请输入语音信息或者文字信息"];
            return;
        }
        else
        {
            [dict setObject:contentView.text forKey:@"text"];
        }
        [self StartLoading];
    
        [_sfManager addUploadTaskWithUrl:url normalParam:dict images:dic voices:nil completion:^(BOOL isSuccess, NSData *data) {
            if (isSuccess) {
                [weakSelf StopLoading];
                if (data && data.length>0) {
                    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if ([[info[@"code"] stringValue]isEqualToString:@"1"]) {
                        [weakSelf showMsg:@"发布成功"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:ORDERDEAL object:nil];
                        [weakSelf performSelector:@selector(doSomething) withObject:nil afterDelay:1];
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

}
-(void)doSomething
{
    UITextField *tx0 = (UITextField *)[firstView viewWithTag:20000];
    UITextField *tx2 = (UITextField *)[firstView viewWithTag:20002];
    UITextField *tx3 = (UITextField *)[firstView viewWithTag:20003];
    UITextField *tx4 = (UITextField *)[firstView viewWithTag:20004];
    UITextField *tx5 = (UITextField *)[firstView viewWithTag:20005];
    
    tx0.text =@"";
    tx2.text =@"";
    tx3.text =@"";
    tx4.text =@"";
    tx5.text =@"";
    
    ifHasVoice = NO;
    voiceBtn.hidden = NO;
    voiceBtnView.hidden = YES;
    
    contentView.text = @"";
    
    [self.uploadPicArray removeAllObjects];
    [self refreshUI];
    
    timeLabel.text = @"";
    toufangPlaceLabel.text = @"";
    radiusLabel.text = @"";
    finalPlaceLabel.text = @"";
    timeTX.text =@"10";
    moneyTX.text = @"10";
    _finalDic= nil;
    _toufangDic = nil;
    jiguanView.text = @"";
    jiguantishi.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        _sc.contentOffset = CGPointMake(0, 0);
    }];
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

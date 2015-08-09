//
//  ShareView.m
//  MessageFly
//
//  Created by xll on 15/4/15.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ShareView.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
@implementation ShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    self.backgroundColor =[UIColor clearColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[UIScreen mainScreen]bounds].size.height)];
    bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self addSubview:bgView];
    
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    UIView *shareView ;
    float btnWidth = (self.frame.size.width-15*2-30)/4;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]&&[QQApiInterface isQQInstalled]&&[QQApiInterface isQQSupportApi]) {
        isAll = YES;
        shareView = [MyControll createViewWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height, self.frame.size.width,30 +btnWidth+10+20+20+(10+btnWidth+10 +20+20)+30)];
        [UIView animateWithDuration:0.3 animations:^{
            shareView.frame =CGRectMake(0, [[UIScreen mainScreen]bounds].size.height -(30 +btnWidth+10+20+20+(10+btnWidth+10 +20+20)+40), self.frame.size.width, 30 +btnWidth+10+20+20+(10+btnWidth+10 +20+20)+40);
        }];
    }
    else
    {
        isAll = NO;
        shareView = [MyControll createViewWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height, self.frame.size.width,30 +btnWidth+10+20+20+40)];
        [UIView animateWithDuration:0.3 animations:^{
            shareView.frame =CGRectMake(0, [[UIScreen mainScreen]bounds].size.height -(30 +btnWidth+10+20+20+40), self.frame.size.width, 30 +btnWidth+10+20+20+40);
        }];
    }
 
    shareView.tag = 70;
    shareView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.95];
    shareView.userInteractionEnabled = YES;
    [self addSubview:shareView];
    
    
    
    NSArray *sharePic = @[@"p14@2x",@"p15@2x",@"p16@2x",@"p17@2x",@"p22@2x"];
    NSArray *shareTitle = @[@"微信好友",@"朋友圈",@"QQ空间",@"QQ好友",@"新浪微博"];
    
    if (!isAll) {
        float marginWidth = 15;
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
        {
            UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(marginWidth , 30, btnWidth, btnWidth)];
            wxBtn.layer.cornerRadius = 5;
            wxBtn.clipsToBounds = YES;
            wxBtn.tag = 100000;
            [wxBtn setImage:[UIImage imageNamed:sharePic[0]] forState:UIControlStateNormal];
            [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:wxBtn];
            UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(marginWidth , 30 + btnWidth+10, btnWidth, 20)];
            l.textColor = [UIColor lightGrayColor];
            l.text =shareTitle[0];
            l.textAlignment = NSTextAlignmentCenter;
            l.font = [UIFont systemFontOfSize:14];
            [shareView addSubview:l];
            marginWidth = marginWidth+btnWidth+10;
        }
        
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
        {
            UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(marginWidth , 30, btnWidth, btnWidth)];
            wxBtn.layer.cornerRadius = 5;
            wxBtn.clipsToBounds = YES;
            wxBtn.tag = 100001;
            [wxBtn setImage:[UIImage imageNamed:sharePic[1]] forState:UIControlStateNormal];
            [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:wxBtn];
            UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(marginWidth , 30 + btnWidth+10, btnWidth, 20)];
            l.textColor = [UIColor lightGrayColor];
            l.text =shareTitle[1];
            l.textAlignment = NSTextAlignmentCenter;
            l.font = [UIFont systemFontOfSize:14];
            [shareView addSubview:l];
            marginWidth = marginWidth+btnWidth+10;
        }
        
        if ([QQApiInterface isQQInstalled]&&[QQApiInterface isQQSupportApi])
        {
            UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(marginWidth , 30, btnWidth, btnWidth)];
            wxBtn.layer.cornerRadius = 5;
            wxBtn.clipsToBounds = YES;
            wxBtn.tag = 100002;
            [wxBtn setImage:[UIImage imageNamed:sharePic[2]] forState:UIControlStateNormal];
            [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:wxBtn];
            UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(marginWidth , 30 + btnWidth+10, btnWidth, 20)];
            l.textColor = [UIColor lightGrayColor];
            l.text =shareTitle[2];
            l.textAlignment = NSTextAlignmentCenter;
            l.font = [UIFont systemFontOfSize:14];
            [shareView addSubview:l];
            marginWidth = marginWidth+btnWidth+10;
            
        }
        if ([QQApiInterface isQQInstalled]&&[QQApiInterface isQQSupportApi])
        {
            UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(marginWidth , 30, btnWidth, btnWidth)];
            wxBtn.layer.cornerRadius = 5;
            wxBtn.clipsToBounds = YES;
            wxBtn.tag = 100003;
            [wxBtn setImage:[UIImage imageNamed:sharePic[3]] forState:UIControlStateNormal];
            [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:wxBtn];
            UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(marginWidth , 30 + btnWidth+10, btnWidth, 20)];
            l.textColor = [UIColor lightGrayColor];
            l.text =shareTitle[3];
            l.textAlignment = NSTextAlignmentCenter;
            l.font = [UIFont systemFontOfSize:14];
            [shareView addSubview:l];
            marginWidth = marginWidth+btnWidth+10;
            
        }
        UIButton *sinaBtn = [[UIButton alloc]initWithFrame:CGRectMake(marginWidth , 30, btnWidth, btnWidth)];
        sinaBtn.layer.cornerRadius = 5;
        sinaBtn.clipsToBounds = YES;
        sinaBtn.tag = 100004;
        [sinaBtn setImage:[UIImage imageNamed:sharePic[4]] forState:UIControlStateNormal];
        [sinaBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:sinaBtn];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(marginWidth , 30 + btnWidth+10, btnWidth, 20)];
        lb.textColor = [UIColor lightGrayColor];
        lb.text =shareTitle[4];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:14];
        [shareView addSubview:lb];
        marginWidth = marginWidth+btnWidth+10;
    }
    else
    {
        for (int i = 0; i<sharePic.count; i++) {
            UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(15 +(btnWidth+10)*(i%4), 30+(10+btnWidth+10 +20+20)*(i/4), btnWidth, btnWidth)];
            wxBtn.layer.cornerRadius = 5;
            wxBtn.clipsToBounds = YES;
            wxBtn.tag = 100000+i;
            [wxBtn setImage:[UIImage imageNamed:sharePic[i]] forState:UIControlStateNormal];
            [wxBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:wxBtn];
            UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(15 +(btnWidth+10)*(i%4) , 30 + btnWidth+10+(10+btnWidth+10 +20+20)*(i/4), btnWidth, 20)];
            l.textColor = [UIColor lightGrayColor];
            l.text =shareTitle[i];
            l.textAlignment = NSTextAlignmentCenter;
            l.font = [UIFont systemFontOfSize:14];
            [shareView addSubview:l];
        }
    }
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, shareView.frame.size.height-40,vWIDTH, 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.userInteractionEnabled = YES;
    [shareView addSubview:whiteView];
    
    UIButton *cancelBtn = [MyControll createButtonWithFrame:CGRectMake((vWIDTH-300)/2, 0, 300, 40) bgImageName:nil imageName:nil title:@"取消" selector:@selector(shareBtnClick:) target:self];
    cancelBtn.tag = 100005;
    [whiteView addSubview:cancelBtn];
    
}
-(void)shareBtnClick:(UIButton *)sender
{
    NSString *shareText =[NSString stringWithFormat:@"欢迎您使用信儿快飞APP"];
    int index = (int)sender.tag;
    UIImage *image = [UIImage imageNamed:@"Icon60"];
    if (index == 100000) {
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareText image:image location:nil urlResource:nil presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
        else
        {
            [self showMsg:@"你没有安装微信"];
        }
    }
    else if (index == 100001)
    {
        
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareText image:image location:nil urlResource:nil presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
        else
        {
            [self showMsg:@"你没有安装微信"];
        }
    }
    else if (index == 100002)
    {
        if ([QQApiInterface isQQInstalled]&&[QQApiInterface isQQSupportApi])
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareText image:[UIImage imageNamed:@"Icon60"] location:nil urlResource:nil presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
        else
        {
            [self showMsg:@"你没有安装QQ"];
        }
    }
    else if (index == 100003)
    {
        if ([QQApiInterface isQQInstalled]&&[QQApiInterface isQQSupportApi])
        {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareText image:image location:nil urlResource:nil presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
        else
        {
            [self showMsg:@"你没有安装QQ"];
        }
    }
    else if (index == 100004)
    {
        NSString *str = [NSString stringWithFormat:@"%@ http://202.85.214.88/xiner/down.html",shareText];
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:image location:nil urlResource:nil presentedController:(UIViewController*)_delegate completion:^(UMSocialResponseEntity *response){
//                if (response.responseCode == UMSResponseCodeSuccess) {
//                    NSLog(@"分享成功！");
//                }
//            }];
        [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
        //进入授权页面
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler(_delegate,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                //获取微博用户名、uid、token等
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                //进入你的分享内容编辑页面
                [[UMSocialControllerService defaultControllerService]
                 setShareText:str shareImage:image
                 socialUIDelegate:self];
                //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(_delegate,[UMSocialControllerService defaultControllerService],YES);
            }
        });
        }
    [self removeFromSuperview];
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    
}
-(void)tap:(UIGestureRecognizer *)sender
{
    [self removeFromSuperview];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
    else
    {
        [self removeFromSuperview];
    }
}
@end

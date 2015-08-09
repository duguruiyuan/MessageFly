//
//  ReplyDetailTableViewCell.m
//  MessageFly
//
//  Created by xll on 15/4/13.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ReplyDetailTableViewCell.h"
#import "LunBoTuViewController.h"
@implementation ReplyDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *t = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"我的回复" font:18];
    t.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:t];
    voiceView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, sWIDTH, 95)];
    voiceView.backgroundColor = [UIColor whiteColor];
    [self addSubview:voiceView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, sWIDTH-20, 1)];
    line1.backgroundColor =[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    [voiceView addSubview:line1];
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"语音" font:16];
    tishi.textColor = [UIColor lightGrayColor];
    [voiceView addSubview:tishi];
    
    soundBtn = [[SoundBtn alloc]initWithFrame:CGRectMake((sWIDTH-200)/2, 35, 200, 50)];
    [voiceView addSubview:soundBtn];
    
    
    
    wordView = [[UIView alloc]initWithFrame:CGRectMake(0, 135, sWIDTH, 100)];
    wordView.backgroundColor = [UIColor whiteColor];
    [self addSubview:wordView];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, sWIDTH-20, 1)];
    line2.backgroundColor =[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    [wordView addSubview:line2];
    
    UILabel *tishi2 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"文字" font:16];
    tishi2.textColor = [UIColor lightGrayColor];
    [wordView addSubview:tishi2];
    
    contentLabel = [MyControll createLabelWithFrame:CGRectMake(20, 40, sWIDTH-40, 50) title:nil font:14];
    [wordView addSubview:contentLabel];
    
    picView  = [[UIView alloc]initWithFrame:CGRectMake(0, 235, sWIDTH, 100)];
    picView.backgroundColor = [UIColor whiteColor];
    [self addSubview:picView];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, sWIDTH-20, 1)];
    line3.backgroundColor =[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    [picView addSubview:line3];
    
    UILabel *tishi3 = [MyControll createLabelWithFrame:CGRectMake(20, 10, 150, 20) title:@"图片" font:16];
    tishi3.textColor = [UIColor lightGrayColor];
    [picView addSubview:tishi3];
    
    CGFloat picWidth = (sWIDTH-40-30)/4;
    picSCView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, sWIDTH, picWidth)];
    [picView addSubview:picSCView];
    
}
-(void)config:(NSDictionary *)dic
{
    dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    CGFloat height = 40;
    
    if (![dic[@"radio"] isEqualToString:@""]) {
       [soundBtn loadVoiceData:dic];
        height =height+ 95;
    }
    else
    {
        voiceView.hidden = YES;
    }
    if (![dic[@"text"] isEqualToString:@""]) {
        CGSize sizeOfcontent = [MyControll getSize:dic[@"text"] Font:15 Width:sWIDTH-40 Height:1000];
        contentLabel.frame = CGRectMake(20, 35, sWIDTH-40, sizeOfcontent.height+5);
        contentLabel.text = dic[@"text"];
        wordView.frame = CGRectMake(0, height, sWIDTH, contentLabel.frame.origin.y+contentLabel.frame.size.height);
        height =wordView.frame.origin.y+wordView.frame.size.height+10;
    }
    else
    {
        wordView.hidden = YES;
    }
    NSArray *picArray = dic[@"image"];
    CGFloat picWidth = (sWIDTH-40-30)/4;
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
        picView.frame = CGRectMake(0, height, sWIDTH, picHeight+40);
        picSCView.frame = CGRectMake(0, 35, sWIDTH, picHeight);
        height = height+picView.frame.size.height;
        
    }
    else
    {
        picView.hidden = YES;
    }
    
    
}
-(void)checkPhoto:(UIGestureRecognizer *)sender
{
    NSArray *picArray = dataDic[@"image"];
    LunBoTuViewController *vc = [[LunBoTuViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [vc picShow:picArray atIndex:(int)(sender.view.tag-200)];
    [_delegate presentViewController:vc animated:NO completion:nil];
}
-(void)dealloc
{
    [soundBtn stopPlay];
}
@end

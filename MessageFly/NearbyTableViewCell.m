//
//  NearbyTableViewCell.m
//  MessageFly
//
//  Created by xll on 15/2/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "NearbyTableViewCell.h"

@implementation NearbyTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    
    UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cWIDTH, 1)];
    line0.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    line0.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    [self.contentView addSubview:line0];
    
    headView = [MyControll createImageViewWithFrame:CGRectMake(20, 10, 60, 60) imageName:@"picdefault@2x"];
    headView.clipsToBounds = YES;
    headView.layer.cornerRadius = 5;
    [self.contentView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(90, 20, cWIDTH-90-70, 20) title:@"海淀区航天桥东航天科技" font:16];
    nameLabel.font =[UIFont boldSystemFontOfSize:16];
    nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:nameLabel];
    
    mapView = [MyControll createImageViewWithFrame:CGRectMake(cWIDTH-70, 20, 10, 20) imageName:@"11@2x_24"];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    mapView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:mapView];
    
    distance = [MyControll createLabelWithFrame:CGRectMake(cWIDTH-60, 20, 50, 20) title:@"1.2km" font:12];
    distance.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    distance.textAlignment = NSTextAlignmentRight;
    distance.textColor = [UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.00f];
    [self.contentView addSubview:distance];
    
    moneyLabel = [MyControll createLabelWithFrame:CGRectMake(90, 50, 40, 20) title:@"酬金:" font:14];
    moneyLabel.textColor = [UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.00f];
    [self.contentView addSubview:moneyLabel];
    
    
    moneyNum = [MyControll createLabelWithFrame:CGRectMake(125, 50, 40, 20) title:@"12" font:18];
    moneyNum.textColor = [UIColor redColor];
    [self.contentView addSubview:moneyNum];
    danwei = [MyControll createLabelWithFrame:CGRectMake(170, 50, 35, 20) title:@"元/人" font: 14];
    [self.contentView addSubview:danwei];
    
    
    typeView = [MyControll createImageViewWithFrame:CGRectMake(220, 51, 40, 17) imageName:@"11@2x_09"];
    [self.contentView addSubview:typeView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 80, cWIDTH, 1)];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    line1.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    [self.contentView addSubview:line1];
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(20, 85, cWIDTH/2-30, 20) title:@"30分钟前" font:14];
    timeLabel.textColor =[UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.00f];
    [self.contentView addSubview:timeLabel];
    
    
    endTimeLabel = [MyControll createLabelWithFrame:CGRectMake(cWIDTH-150, 85, 140, 20) title:@"剩余时间：10：10" font:14];
    endTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    endTimeLabel.textAlignment = NSTextAlignmentRight;
    endTimeLabel.textColor = [UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.00f];
    [self.contentView addSubview:endTimeLabel];
    
    
    clockView = [MyControll createImageViewWithFrame:CGRectMake(cWIDTH-160, 85, 13, 20) imageName:@"11@2x_15"];
    clockView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    clockView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:clockView];
    
    flagView = [MyControll createImageViewWithFrame:CGRectMake(cWIDTH-75, 40, 65, 40) imageName:@"11@2x_06"];
    flagView.hidden = YES;
    flagView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    flagView.contentMode =UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:flagView];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 110, cWIDTH, 15)];
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    line2.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self.contentView addSubview:line2];
}
-(void)config:(NSDictionary *)dic
{
    [headView startAnimating];
    [headView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]] placeholderImage:[UIImage imageNamed:@"picdefault@2x"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    [headView stopAnimating];
    }];
    nameLabel.text = dic[@"address"];
    NSString *moneyStr =dic[@"money"];
    CGSize size = [MyControll getSize:moneyStr Font:18 Width:100 Height:20];
    moneyNum.frame = CGRectMake(125, 50, size.width+5, 20);
    moneyNum.text = moneyStr;
    danwei.frame = CGRectMake(moneyNum.frame.origin.x+moneyNum.frame.size.width, 50, 35, 20);
    
    typeView.frame = CGRectMake(danwei.frame.origin.x +danwei.frame.size.width , 51, 40, 17);
    if (_type == -1) {
        if ([dic[@"state"] isEqualToString:@"0"]) {
            typeView.image = [UIImage imageNamed:@"11@2x_09"];
        }
        else if ([dic[@"state"] isEqualToString:@"1"])
        {
            typeView.image = [UIImage imageNamed:@"11@2x_19"];
        }
        else if ([dic[@"state"] isEqualToString:@"2"])
        {
            typeView.image = [UIImage imageNamed:@"11@2x_27"];
        }
        else if ([dic[@"state"] isEqualToString:@"3"])
        {
            typeView.image = [UIImage imageNamed:@"yishixiao@2x"];
        }
        
    }
    else if (_type == -2)
    {
        typeView.hidden = YES;
    }
    else
    {
        if ([dic[@"state"] isEqualToString:@"0"]) {
            if (_type == 3) {
                typeView.image = [UIImage imageNamed:@"11@2x_19"];
            }
            else
            {
                typeView.image = [UIImage imageNamed:@"11@2x_09"];
            }
        }
        else if ([dic[@"state"] isEqualToString:@"3"])
        {
            typeView.image = [UIImage imageNamed:@"yishixiao@2x"];
        }
        else if ([dic[@"state"] isEqualToString:@"2"])
        {
            typeView.image = [UIImage imageNamed:@"11@2x_27"];
        }
    }
    
    distance.text = [NSString stringWithFormat:@"%.2fkm",[dic[@"distance"] floatValue]/1000];
    CGSize sizeofDistance = [MyControll getSize:distance.text Font:12 Width:70 Height:20];
    distance.frame = CGRectMake(cWIDTH-sizeofDistance.width-15,20, sizeofDistance.width+5, 20);
    mapView.frame = CGRectMake(cWIDTH-sizeofDistance.width-25, 20, 10, 20);
    
    
    
    endTimeLabel.text = [NSString stringWithFormat:@"剩余时间：%@",dic[@"ltime"]];
    
    CGSize sizeofEndTime = [MyControll getSize:endTimeLabel.text Font:14 Width:140 Height:20];
    endTimeLabel.frame = CGRectMake(cWIDTH-sizeofEndTime.width-15, 85, sizeofEndTime.width+5, 20);
    clockView.frame = CGRectMake(cWIDTH-sizeofEndTime.width-25, 85, 13, 20);
    
    int time = [dic[@"time"] intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *str = [MyControll dayLabelForMessage:date];
    timeLabel.text = str;
    
    if ([dic[@"type"] isEqualToString:@"1"]) {
        flagView.hidden = YES;
    }
    else
    {
        flagView.hidden = NO;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

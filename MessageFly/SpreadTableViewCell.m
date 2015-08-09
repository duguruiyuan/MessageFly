//
//  SpreadTableViewCell.m
//  MessageFly
//
//  Created by xll on 15/2/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "SpreadTableViewCell.h"

@implementation SpreadTableViewCell
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
    contentLabel = [MyControll createLabelWithFrame:CGRectMake(20, 10, sWIDTH-40, 40) title:@"" font:15];
    [self.contentView addSubview:contentLabel];
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(20, 50, 150, 20) title:@"" font:14];
    timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:timeLabel];
    line = [[UIView alloc]initWithFrame:CGRectMake(0, 79.5, sWIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f];
    [self.contentView addSubview:line];
}
-(void)config:(NSDictionary *)dic
{
    CGSize size = [MyControll getSize:dic[@"text"] Font:15 Width:sWIDTH-40 Height:1000];
    contentLabel.frame = CGRectMake(20, 10, sWIDTH-40, size.height+5);
    timeLabel.frame = CGRectMake(20, 10+size.height+5, 150, 20);
    contentLabel.text = dic[@"text"];
    
    int time = [dic[@"time"] intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSString *str = [df stringFromDate:date];
    timeLabel.text = str;
    line.frame = CGRectMake(0, 10+size.height+5+20+9.5, sWIDTH, 0.5);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

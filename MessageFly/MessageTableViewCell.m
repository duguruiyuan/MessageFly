//
//  MessageTableViewCell.m
//  MessageFly
//
//  Created by xll on 15/2/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

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
    content = [MyControll createLabelWithFrame:CGRectMake(40, 10, sWIDTH-50, 40) title:@"" font:15];
    content.numberOfLines = 2;
    [self.contentView addSubview:content];
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(40, 55, sWIDTH-50, 20) title:@"09-29" font:14];
    timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:timeLabel];
    
    point = [MyControll createImageViewWithFrame:CGRectMake(10, 32.5, 15, 15) imageName:@"m19@2x"];
    point.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:point];
    
    line = [MyControll createLineWithFrame:CGRectMake(30, 84, sWIDTH-30, 1) withColor:[UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f]];
    
    [self.contentView addSubview:line];
}
-(void)config:(NSDictionary *)dic
{
    CGSize size = [MyControll getSize:dic[@"title"] Font:15 Width:sWIDTH-40 Height:1000];
    content.frame = CGRectMake(40, 10, sWIDTH-50, size.height+5);
    timeLabel.frame = CGRectMake(40, 10+size.height+5, 150, 20);

    content.text =dic[@"title"];
    int time = [dic[@"time"] intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    timeLabel.text = currentDateStr;
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

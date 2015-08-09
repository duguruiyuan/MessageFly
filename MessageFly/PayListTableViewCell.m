//
//  PayListTableViewCell.m
//  MessageFly
//
//  Created by xll on 15/2/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "PayListTableViewCell.h"

@implementation PayListTableViewCell
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
    content = [MyControll createLabelWithFrame:CGRectMake(20, 10, sWIDTH-40, 25) title:@"来往之帮充值50.00元" font:16];
    [self.contentView addSubview:content];
    
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(20, 35, sWIDTH-40, 20) title:@"14-12-23" font:14];
    timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:timeLabel];
    
    UIView *line = [MyControll createLineWithFrame:CGRectMake(0, 64, sWIDTH, 1) withColor:[UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f]];
    
    [self.contentView addSubview:line];
}
-(void)config:(NSDictionary *)dic
{
    content.text = dic[@"text"];
    timeLabel.text = dic[@"time"];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

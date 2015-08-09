//
//  ProfitTableViewCell.m
//  MessageFly
//
//  Created by xll on 15/2/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "ProfitTableViewCell.h"

@implementation ProfitTableViewCell
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
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(20, 0, 150, 40) title:@"2015-01-23" font:16];
    [self.contentView addSubview:timeLabel];
    
    moneyLabel = [MyControll createLabelWithFrame:CGRectMake(sWIDTH-150, 0, 140, 40) title:nil font:16];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:moneyLabel];
    
    UIView *line = [MyControll createLineWithFrame:CGRectMake(0, 39, sWIDTH, 1) withColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f]];
    [self.contentView addSubview:line];
}
-(void)config:(NSDictionary *)dic withType:(int)type
{
    if (type == 1) {
        moneyLabel.text = [NSString stringWithFormat:@"+%@",dic[@"money"]];
        moneyLabel.textColor = [UIColor colorWithRed:0.11f green:0.53f blue:0.00f alpha:1.00f];
        timeLabel.text =dic[@"data"];
    }
    else if(type ==2)
    {
        moneyLabel.text = [NSString stringWithFormat:@"-%@",dic[@"money"]];
        moneyLabel.textColor = [UIColor colorWithRed:0.94f green:0.26f blue:0.00f alpha:1.00f];
        timeLabel.text =dic[@"data"];
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

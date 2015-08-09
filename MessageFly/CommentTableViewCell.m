//
//  CommentTableViewCell.m
//  MessageFly
//
//  Created by xll on 15/4/10.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
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
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(20, 10, 80, 20) title:nil font:14];
    [self.contentView addSubview:nameLabel];
    
    for (int i = 0; i<5; i++) {
        UIImageView *star = [MyControll createImageViewWithFrame:CGRectMake(110+18*i, 10, 16, 20) imageName:@"m16@2x_14"];
        star.contentMode = UIViewContentModeScaleAspectFit;
        star.tag = 100+i;
        [self.contentView addSubview:star];
    }
    timeLabel = [MyControll createLabelWithFrame:CGRectMake(sWIDTH - 100, 10, 90, 20) title:nil font:13];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    
    descLabel = [MyControll createLabelWithFrame:CGRectMake(20, 40, sWIDTH-40, 20) title:nil font:14];
    [self.contentView addSubview:descLabel];
    
    line = [MyControll createLineWithFrame:CGRectMake(20, 69.5, sWIDTH-20, 0.1) withColor:[UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f]];
    [self.contentView addSubview:line];
}
-(void)config:(NSDictionary *)dic
{
    nameLabel.text = dic[@"name"];
    
    int time = [dic[@"time"] intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *str = [MyControll dayLabelForMessage:date];
    timeLabel.text = str;
    for (int i = 0; i<5; i++) {
        if (i<[dic[@"star"]intValue]) {
            UIImageView *star =(UIImageView *)[self.contentView viewWithTag:100+i];
            star.image = [UIImage imageNamed:@"m16@2x_14"];
        }
        else
        {
            UIImageView *star =(UIImageView *)[self.contentView viewWithTag:100+i];
            star.image = [UIImage imageNamed:@"m16@2x_16"];
        }
    }
     descLabel.text = dic[@"text"];
    CGSize size = [MyControll getSize:dic[@"text"] Font:15 Width:sWIDTH-40 Height:1000];
    descLabel.frame = CGRectMake(20, 40, sWIDTH-40, size.height+5);
    line.frame = CGRectMake(0, 40+size.height+5+9.5, sWIDTH, 0.5);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

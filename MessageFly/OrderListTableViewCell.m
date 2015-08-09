//
//  OrderListTableViewCell.m
//  MessageFly
//
//  Created by xll on 15/4/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "OrderListTableViewCell.h"

@implementation OrderListTableViewCell

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
    headView = [MyControll createImageViewWithFrame:CGRectMake(20, 10, 60, 60) imageName:@"picdefault@2x"];
    headView.layer.cornerRadius =30;
    headView.clipsToBounds = YES;
    [self.contentView addSubview:headView];
    
    nameLabel = [MyControll createLabelWithFrame:CGRectMake(90, 10, sWIDTH-100, 20) title:@"" font:18];
    [self.contentView addSubview:nameLabel];
    
    UILabel *moblieLabel = [MyControll createLabelWithFrame:CGRectMake(90, 30, 70, 20) title:@"联系电话:" font:15];
    moblieLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:moblieLabel];
    
    phoneNum = [MyControll createLabelWithFrame:CGRectMake(165, 30, sWIDTH-175, 20) title:@"" font:15];
    phoneNum.textColor = [UIColor lightGrayColor];
    [self addSubview:phoneNum];
    
    UILabel *tishi = [MyControll createLabelWithFrame:CGRectMake(90, 50, 70, 20) title:@"接单诚信" font:15];
    tishi.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:tishi];
    
    
}
-(void)config:(NSDictionary *)dic
{
    [headView sd_setImageWithURL:[NSURL URLWithString:dic[@"face"]] placeholderImage:[UIImage imageNamed:@"picdefault@2x"]];
    nameLabel.text = dic[@"name"];
    phoneNum.text = dic[@"mobile"];
    for (int i= 0; i<5; i++) {
        if (i<[dic[@"getcerity"] intValue]) {
            UIImageView *star = [MyControll createImageViewWithFrame:CGRectMake(165+18*i, 50, 16, 20) imageName:@"m16@2x_14"];
            star.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:star];
        }
        else
        {
            UIImageView *star = [MyControll createImageViewWithFrame:CGRectMake(165+18*i, 50, 16, 20) imageName:@"m16@2x_16"];
            star.contentMode = UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:star];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

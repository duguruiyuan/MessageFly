//
//  NearbyTableViewCell.h
//  MessageFly
//
//  Created by xll on 15/2/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyTableViewCell : UITableViewCell
{
    UIImageView *headView;
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *endTimeLabel;
    UILabel *distance;
    UIImageView *mapView;
    UILabel *moneyLabel;
    UIImageView *typeView;
    UILabel *moneyNum;
    UILabel *danwei;
    UIImageView *clockView;
    UIImageView *flagView;
    
}
@property(nonatomic)int type;
-(void)config:(NSDictionary *)dic;
@end

//
//  ProfitTableViewCell.h
//  MessageFly
//
//  Created by xll on 15/2/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfitTableViewCell : UITableViewCell
{
    UILabel *timeLabel;
    UILabel *moneyLabel;
}
-(void)config:(NSDictionary *)dic withType:(int)type;
@end

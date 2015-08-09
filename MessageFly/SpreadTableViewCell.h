//
//  SpreadTableViewCell.h
//  MessageFly
//
//  Created by xll on 15/2/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpreadTableViewCell : UITableViewCell
{
    UILabel *contentLabel;
    UILabel *timeLabel;
    UIView *line;
}
-(void)config:(NSDictionary *)dic;
@end

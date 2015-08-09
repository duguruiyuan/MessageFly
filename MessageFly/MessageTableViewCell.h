//
//  MessageTableViewCell.h
//  MessageFly
//
//  Created by xll on 15/2/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
{
    UILabel *content;
    UILabel *timeLabel;
    UIImageView *point;
    UIView *line;
}
-(void)config:(NSDictionary *)dic;
@end

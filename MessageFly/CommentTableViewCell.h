//
//  CommentTableViewCell.h
//  MessageFly
//
//  Created by xll on 15/4/10.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
{
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *descLabel;
    UIView *line;
}
-(void)config:(NSDictionary *)dic;
@end

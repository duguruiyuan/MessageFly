//
//  OrderListTableViewCell.h
//  MessageFly
//
//  Created by xll on 15/4/8.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListTableViewCell : UITableViewCell
{
    UIImageView *headView;
    UILabel *nameLabel;
    UILabel *phoneNum;
    
}
-(void)config:(NSDictionary *)dic;
@end

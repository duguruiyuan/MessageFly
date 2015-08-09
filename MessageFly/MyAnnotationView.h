//
//  MyAnnotationView.h
//  MessageFly
//
//  Created by xll on 15/4/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BMKAnnotationView.h"

@interface MyAnnotationView : BMKAnnotationView
{
    UILabel *moneyLabel;
    UILabel *timeLabel;
    UILabel *addressLabel;
    NSMutableDictionary *dict;
}
@property(nonatomic, assign)UIViewController *delegate;
-(void)config:(NSDictionary *)dic;
@end

//
//  AcountVIew.h
//  MessageFly
//
//  Created by xll on 15/4/10.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"

@interface AcountVIew : BaseADView
{
    UILabel *countNum;
    NSMutableDictionary *dataDic;
}
@property(nonatomic,assign)UIViewController *delegate;
-(void)config:(NSDictionary *)dic;
@end

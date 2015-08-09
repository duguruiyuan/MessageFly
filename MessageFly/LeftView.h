//
//  LeftView.h
//  MessageFly
//
//  Created by xll on 15/2/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import "BaseADView.h"
@interface LeftView : BaseADView
{
    MyRecord *record ;
    double timeLength;
}
@property(nonatomic,assign)UIViewController *delegate;
@property(nonatomic,strong)UIScrollView *sc;
@end

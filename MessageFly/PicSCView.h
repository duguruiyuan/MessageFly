//
//  PicSCView.h
//  MessageFly
//
//  Created by xll on 15/2/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicSCView : UIView
{
    UIScrollView *mainSC;
    int page;
    NSArray *array;
}
@property(nonatomic,assign)UIViewController *delegate;
@property(nonatomic)CGRect rect;
@property(nonatomic)float distance;
-(void)loadPicArray:(NSArray *)dataArray;
@end

//
//  MoveView.h
//  dddd
//
//  Created by xll on 15/5/12.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoveView : UIView
{
    UILabel *contentLabel;
    NSTimer *timer;
    float timelength;
}
//@property(nonatomic)NSString *contentword;
//@property(nonatomic)int fontSize;
//@property(nonatomic)float moveTime;
-(void)config:(NSString *)contentword withFont:(int)fondSize withTime:(float)movetime;
@end

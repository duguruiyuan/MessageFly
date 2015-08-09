//
//  ReplyForQiangDanTableViewCell.h
//  MessageFly
//
//  Created by xll on 15/4/14.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicSCView.h"
#import "SoundBtn.h"
@interface ReplyForQiangDanTableViewCell : UITableViewCell
{
    UIView *voiceView;
    UIView *picView;
    UIView *wordView;
    UILabel *contentLabel;
    UIView *picSCView;
    UILabel *t;
    SoundBtn *soundBtn;
    NSMutableDictionary *dataDic;
}
@property(nonatomic)UIViewController *delegate;
-(void)config:(NSDictionary *)dic;
@end

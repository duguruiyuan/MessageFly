//
//  AgeSelectView.h
//  MessageFly
//
//  Created by xll on 15/5/9.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgeSelectView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *dataArray;
    NSString *selectNum;
}
@property(nonatomic,copy)void(^myBlock)(NSString *str);

@end

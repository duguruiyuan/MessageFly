//
//  SexSelectView.h
//  MessageFly
//
//  Created by xll on 15/4/1.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexSelectView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *dataArray;
    NSString *selectNum;
}
@property(nonatomic,copy)void(^myBlock)(NSString *str);

@end

//
//  RadiusView.h
//  MessageFly
//
//  Created by xll on 15/3/26.
//  Copyright (c) 2015年 xll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadiusView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *dataArray;
    NSString *selectNum;
}
@property(nonatomic,copy)void(^myBlock)(NSString *str);
@end

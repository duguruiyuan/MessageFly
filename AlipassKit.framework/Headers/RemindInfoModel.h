//
//  RemindInfoModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/**
 * 提醒属性Model
 */
@interface RemindInfoModel : BaseModel
/**提醒提前时间*/
@property(nonatomic,retain) NSString *offset;
@end

//
//  TextMessageModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/**
 * 当为EventTicket类型卡券，且操作信息类型为text时需要用到本model类
 */
@interface TextMessageModel : BaseModel
+(id)messageModelWithLabel:(NSString*)aLabel value:(NSString*)aValue;
@property(nonatomic,retain) NSString *label;
@property(nonatomic,retain) NSString *value;
@end

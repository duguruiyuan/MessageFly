//
//  EInfoUnitModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/**
 * Pass特性 EInfo的最小单元，用于组合成复杂的EInfo对象
 */
@interface EInfoUnitModel : BaseModel
+(id)infoUnitWithKey:(NSString*)akey label:(NSString*)alabel value:(NSString*)avalue type:(NSString*)atype;
/**字段关键字*/
@property(nonatomic,retain) NSString *key;

/**显示名称*/
@property(nonatomic,retain) NSString *label;

/**显示具体值*/
@property(nonatomic,retain) NSString *value;

/**字段类型*/
@property(nonatomic,retain) NSString *type;
@end

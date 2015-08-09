//
//  EVoucherInfoModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "OperationModel.h"
#import "EInfoModel.h"
#import "RemindInfoModel.h"

/**
 * 基础属性Model
 */
@interface EVoucherInfoModel : BaseModel

/**pass描述*/
@property(nonatomic,retain) NSString *description;

/**pass名称*/
@property(nonatomic,retain) NSString *title;

/**pass类型*/
@property(nonatomic,retain) NSString *type;

/**pass子类型*/
@property(nonatomic,retain) NSString *product;

/**pass生效时间*/
@property(nonatomic,retain) NSString *startDate;

/**pass失效时间*/
@property(nonatomic,retain) NSString *endDate;

/**操作信息,数组元素类型是OperationModel*/
@property(nonatomic,retain) NSMutableArray *operation;

/**Pass特性*/
@property(nonatomic,retain) EInfoModel *einfo;

/**提醒信息*/
@property(nonatomic,retain) RemindInfoModel *remindInfo;
@end

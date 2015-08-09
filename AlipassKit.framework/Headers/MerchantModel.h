//
//  MerchantModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/**
 * 渠道商属性Model
 */
@interface MerchantModel : BaseModel

/**渠道商全称*/
@property(nonatomic,retain) NSString *mname;

/**渠道商电话*/
@property(nonatomic,retain) NSString *mtel;

/**渠道商简介*/
@property(nonatomic,retain) NSString *minfo;
@end

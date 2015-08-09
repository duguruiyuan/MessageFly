//
//  PlatformModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/**
 * 渠道属性Model
 */
@interface PlatformModel : BaseModel
/**渠道商在支付包的partnerID*/
@property(nonatomic,retain) NSString *channelID;
@property(nonatomic,retain) NSString *channelType;

/**渠道商服务URL*/
@property(nonatomic,retain) NSString *webServiceUrl;
@end

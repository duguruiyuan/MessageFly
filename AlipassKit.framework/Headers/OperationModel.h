//
//  OperationModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "TextMessageModel.h"
#import "AppDetailModel.h"
#import "QRCodeImageModel.h"
/**
 * 操作属性Model
 */
@interface OperationModel : BaseModel

/**操作区展示类型*/
@property(nonatomic,retain) NSString *format;

/**altText*/
@property(nonatomic,retain) NSString *altText;

/**message可以是NSString、NSArray或者AppDetailModel类型 QRCodeImageModel类型 如果是NSArray，数组元素类型是TextMessageModel*/
@property(nonatomic,retain) id message;

/**展示信息编码格式*/
@property(nonatomic,retain) NSString *messageEncoding;

@end

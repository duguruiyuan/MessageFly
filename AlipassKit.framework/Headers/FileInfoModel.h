//
//  FileInfoModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/**
 * 文件属性Model
 */
@interface FileInfoModel : BaseModel
/**版本信息，目前为1 或者 2*/
@property(nonatomic,retain,readonly) NSString *formatVersion;

/**共享属性*/
@property(nonatomic) BOOL canShare;

/**渠道商交易唯一标识*/
@property(nonatomic,retain) NSString *serialNumber;
@end

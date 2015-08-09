//
//  AlipassModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVoucherInfoModel.h"
#import "BaseModel.h"
#import "AppDetailModel.h"
#import "AppInfoModel.h"
#import "EInfoModel.h"
#import "EInfoUnitModel.h"
#import "EVoucherInfoModel.h"
#import "FileInfoModel.h"
#import "MerchantModel.h"
#import "OperationModel.h"
#import "PlatformModel.h"
#import "RemindInfoModel.h"
#import "StyleModel.h"
#import "TextMessageModel.h"
/**
 * pass.json 对应的Model
 */
@interface AlipassModel : BaseModel
/**基础属性*/
@property(nonatomic,retain) EVoucherInfoModel *evoucherInfo;

/**渠道商属性*/
@property(nonatomic,retain) MerchantModel *merchant;

/**渠道属性*/
@property(nonatomic,retain) PlatformModel *platform;

/**样式属性*/
@property(nonatomic,retain) StyleModel *style;

/**文件属性*/
@property(nonatomic,retain) FileInfoModel *fileInfo;

/**应用属性*/
@property(nonatomic,retain) AppInfoModel *appInfo;

@property(nonatomic,retain,readonly)NSString* source;
@end

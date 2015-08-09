//
//  AppInfoModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDetailModel.h"
#import "BaseModel.h"
/**
 * 应用属性Model
 */
@interface AppInfoModel : BaseModel
/**显示的应用名称*/
@property(nonatomic,retain)  NSString *label;

/**相关文案说明*/
@property(nonatomic,retain)  NSString *message;

/**应用相关信息*/
@property(nonatomic,retain)  AppDetailModel *app;
@end

//
//  AppDetailModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/**
 * APP详细信息
 */
@interface AppDetailModel : BaseModel

/**Android 版本下的应用ID*/
@property(nonatomic,retain) NSString *android_appid;

/**IOS 版本下的应用ID*/
@property(nonatomic,retain) NSString *ios_appid;

/**Android版本下的应用调用地址*/
@property(nonatomic,retain) NSString *android_launch;

/**IOS 下的应用调用地址*/
@property(nonatomic,retain) NSString *ios_launch;

/**Android下应用下载地址*/
@property(nonatomic,retain) NSString *android_download;

/**IOS下应用下载地址*/
@property(nonatomic,retain) NSString *ios_download;
@end

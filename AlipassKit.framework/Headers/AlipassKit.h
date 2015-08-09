//
//  AlipassKit.h
//  AlipassKit
//
//  Created by jianfeng.hjf on 13-6-16.
//  Copyright (c) 2013年 jianfeng.hjf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AlipassKitVer.h"
#import "AlipassModel.h"
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
#import "QRCodeImageModel.h"
typedef enum {
    ALPKit_Failed = -1,
    ALPKit_Success,
}ALPKit_Result;

@interface AlipassKitClient : NSObject

/*
 * @abstract, Alipass SDK 版本
 */
@property (nonatomic, readonly) NSString *version;

/*
 * @abstrace, 商户源标志Id
 */
@property (nonatomic, copy) NSString *sourceId;

/*
 * @abstract, Alipass 文件名
   @文件名称规则
         __sourceId__serialNumber__
 */
@property (nonatomic, copy) NSString *passFilename;

/*
 * @abstrace, 初始化，
   @sourceId, 商户源标志Id
   @name, Alipass文件名称
 */
- (id)initWithSourceId:(NSString *)sid andName:(NSString *)name;

/*
 * @abstract, 生成Alipass文件, 
 
   @alipassModel, Alipass文件主要数据构成
   @logo,     渠道商Logo图片, 将保存为png格式图片
   @icon,     商户应用icon图片, 将保存为png格式图片
   @strip,    pass内容图片,如麦当劳优惠券图片、电影票电影海报图片, 将保存为png格式图片
   @p12FilePath   p12密钥的文件路径
   @password  p12密钥的密码
   @completion    返回结果值
                    SUCCESS - 成功
                    < 0     - 失败
 */
- (void)generatePassWithObjects:(AlipassModel *)alipassModel
                           logo:(UIImage *)logo
                           icon:(UIImage *)icon
                          strip:(UIImage *)strip
                  andPcks12FilePath:(NSString *)p12FilePath
         withPcks12FilePassword:(NSString *)password
                     completion:(void (^)(NSInteger result))completion;

/*
 * @abstract, 生成Alipass文件,
 
   @alipassModel, Alipass文件主要数据构成
   @logoPath,     渠道商Logo图片文件
   @iconPath,     商户应用icon图片文件
   @stripPath,    pass内容图片文件
   @p12FilePath   p12密钥的文件路径
   @password  p12密钥的密码
   @completion    返回结果值
                    SUCCESS - 成功
                    < 0     - 失败
 */
- (void)generatePassWithFiles:(AlipassModel *)alipassModel
                         logo:(NSString *)logoPath
                         icon:(NSString *)iconPath
                        strip:(NSString *)stripPath
                andPcks12FilePath:(NSString *)p12FilePath
       withPcks12FilePassword:(NSString *)password
                   completion:(void (^)(NSInteger result))completion;

/*
 * @abstract, 打开支付宝客户端,
   
   @return,   返回结果值
                SUCCESS - 成功
                < 0     - 失败
 */
- (ALPKit_Result)jumpToAlipayClient;

@end

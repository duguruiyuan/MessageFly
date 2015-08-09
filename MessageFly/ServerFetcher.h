//
//  ServerFetcher.h
//  TestHebei
//
//  Created by LYD on 15/1/30.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ServerFetcher;

@protocol serverFetcherDelegate <NSObject>
//请求数据成功
- (void)HttpTaskFinishWithClass:(ServerFetcher *)SF;
//请求数据失败
- (void)HttpTaskFailureWithClass:(ServerFetcher *)SF;

@end

@interface ServerFetcher : NSObject<NSURLConnectionDataDelegate>

//代理属性
@property(nonatomic, weak)__weak id<serverFetcherDelegate>delegate;
//任务id
@property(nonatomic, strong)NSString *taskId;
//请求完成回调
@property(nonatomic, strong)void (^completion)(BOOL isSuccess, NSData *data);
//普通参数
@property(nonatomic, strong)NSDictionary *normalParamDict;
//图片文件参数
@property(nonatomic, strong)NSDictionary *imageFileDict;
//音频文件参数
@property(nonatomic, strong)NSDictionary *voiceFileDict;

//执行请求任务 -- get请求
- (void)executeTaskWithGet:(NSString *)API;
//执行请求任务 -- post请求
- (void)executeTaskWithPost:(NSString *)API andBody:(NSDictionary *)body;
//执行上传任务
- (void)executeTaskWithUpload:(NSString *)API;


////上传数据到服务器（一张图片）
//- (void)uploadImage:(UIImage *)image andURL:(NSString *)url andQueue:(NSDictionary *)queue;
//
////多张图片同时上传
//- (void)uploadImages:(NSMutableArray *)images andURL:(NSString *)url andQueue:(NSDictionary *)queue;
//
////上传音频文件到服务器
//- (void)uploadAudioPath:(NSString *)path andURL:(NSString *)url andQueue:(NSDictionary *)queue;
//
////上传json数组到服务器
//- (void)uploadJson:(NSDictionary *)json andURL:(NSString *)url andQueue:(NSDictionary *)queue;
-(void)cancelRequest;
@end

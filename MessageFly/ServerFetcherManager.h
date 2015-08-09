//
//  ServerFetcherManager.h
//  TestHebei
//
//  Created by LYD on 15/1/30.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerFetcher.h"

@interface ServerFetcherManager : NSObject<serverFetcherDelegate>
//单例类实例化方法
+ (ServerFetcherManager *)sharedServerManager;

//添加get请求任务
- (void)addHttpTaskWithGet:(NSString *)urlStr andParameter:(NSDictionary *)dict completion:(void (^)(BOOL isSuccess, NSData *data))completion;
//添加post请求任务
- (void)addHttpTaskWithPost:(NSString *)urlStr normalParam:(NSDictionary *)dict completion:(void (^)(BOOL isSuccess, NSData *data))completion;
//直接发起请求,不考虑重复的任务
- (void)requestWithUrl:(NSString *)urlStr andParameter:(NSDictionary *)dict completion:(void (^)(BOOL isSuccess, NSData *data))completion;

//添加post请求任务 --- 上传图片
- (void)addUploadTaskWithUrl:(NSString *)urlStr normalParam:(NSDictionary *)dict imageParam:(NSDictionary *)file completion:(void (^)(BOOL isSuccess, NSData *data))completion;

//添加post请求任务 --- 上传音频
- (void)addUploadTaskWithUrl:(NSString *)urlStr normalParam:(NSDictionary *)dict voiceParam:(NSDictionary *)file completion:(void (^)(BOOL isSuccess, NSData *data))completion;

//添加post请求任务 --- 上传视频
- (void)addUploadTaskWithUrl:(NSString *)urlStr normalParam:(NSDictionary *)dict videoParam:(NSDictionary *)file completion:(void (^)(BOOL isSuccess, NSData *data))completion;

//添加post请求任务 --- 上传各种文件
- (void)addUploadTaskWithUrl:(NSString *)urlStr normalParam:(NSDictionary *)dict images:(NSDictionary *)images voices:(NSDictionary *)voices completion:(void (^)(BOOL isSuccess, NSData *data))completion;

//下载文件
- (void)addDownloadTaskWithUrl:(NSString *)urlStr filePath:(NSString *)filePath underwayHandler:(void (^)(long long uploadBytes, long long expectedBytes))underwayHandler completionHandler:(void (^)(BOOL, NSData *))completionHandler;

@end

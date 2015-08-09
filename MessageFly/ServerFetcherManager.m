//
//  ServerFetcherManager.m
//  TestHebei
//
//  Created by LYD on 15/1/30.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import "ServerFetcherManager.h"

@implementation ServerFetcherManager{
    //请求的任务队列 ---- 不允许有重复任务
    NSMutableDictionary *_taskDict;
    //请求的任务队列 ---- 不考虑重复任务
    NSMutableArray *_taskArr;
    //请求任务返回的资源队列
    NSMutableDictionary *_sourceDict;
}

//单例类
+ (ServerFetcherManager *)sharedServerManager{
    static ServerFetcherManager *serverManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serverManager = [[ServerFetcherManager alloc] init];
        serverManager->_taskDict = [[NSMutableDictionary alloc] init];
        serverManager->_taskArr = [[NSMutableArray alloc] init];
        serverManager->_sourceDict = [[NSMutableDictionary alloc] init];
    });
    
    return serverManager;
}

//实例化请求任务
- (ServerFetcher *)createHttpTask{
    //把请求任务加入到任务队列
    ServerFetcher *SF = [[ServerFetcher alloc] init];
    SF.taskId = nil;
    SF.delegate = self;
    [_taskArr addObject:SF];
    return SF;
}

//实例化请求任务
- (ServerFetcher *)createHttpTask:(NSString *)taskId {
    //把请求任务加入到任务队列
    ServerFetcher *SF = [[ServerFetcher alloc] init];
    SF.taskId = taskId;
    SF.delegate = self;
    [_taskDict setObject:SF forKey:taskId];
    return SF;
}

//添加get请求任务
- (void)addHttpTaskWithGet:(NSString *)urlStr andParameter:(NSDictionary *)dict completion:(void (^)(BOOL isSuccess, NSData *data))completion{
    
    NSString *paramStr = [self httpBodyWithGet:dict];
    NSString *url = [NSString stringWithFormat:@"%@%@",urlStr,paramStr];
    NSString *taskId = url;
    //判断请求任务是否已经存在于任务队列中
    if (![_taskDict objectForKey:taskId]) {
        //进行网络请求
        ServerFetcher *SF = [self createHttpTask:taskId];
        SF.completion = completion;
        [SF executeTaskWithGet:url];
    }else{
        NSLog(@"请求任务已经存在");
        if (completion) {
            completion(NO,nil);
        }
    }
}

//添加post请求任务
- (void)addHttpTaskWithPost:(NSString *)urlStr normalParam:(NSDictionary *)dict completion:(void (^)(BOOL isSuccess, NSData *data))completion{
    
    //判断请求任务是否已经存在于任务队列中
    NSString *taskId = [NSString stringWithFormat:@"%@%@",urlStr,[self combineParam:dict]];
    
    if (![_taskDict objectForKey:taskId]) {
        //进行网络请求
        ServerFetcher *SF = [self createHttpTask:taskId];
        SF.completion = completion;
        [SF executeTaskWithPost:urlStr andBody:dict];
        
    }
}

//直接发起请求,不考虑重复的任务
- (void)requestWithUrl:(NSString *)urlStr andParameter:(NSDictionary *)dict completion:(void (^)(BOOL isSuccess, NSData *data))completion{
    NSString *paramStr = [self httpBodyWithGet:dict];
    NSString *url = [NSString stringWithFormat:@"%@%@",urlStr,paramStr];
    //判断请求任务是否已经存在于任务队列中
    //进行网络请求
    ServerFetcher *SF = [self createHttpTask];
    SF.completion = completion;
    [SF executeTaskWithGet:url];
}

//添加post请求任务 --- 上传图片
- (void)addUploadTaskWithUrl:(NSString *)urlStr normalParam:(NSDictionary *)dict imageParam:(NSDictionary *)file completion:(void (^)(BOOL, NSData *))completion{
    
    //判断请求任务是否已经存在于任务队列中
    NSString *taskId = [NSString stringWithFormat:@"%@%@",urlStr,[self combineParam:dict]];
    taskId = [NSString stringWithFormat:@"%@%@",taskId,[self combineParam:file]];
    
    if (![_taskDict objectForKey:taskId]) {
        //进行网络请求
        ServerFetcher *SF = [self createHttpTask:taskId];
        SF.normalParamDict = dict;
        SF.imageFileDict = file;
        SF.completion = completion;
        [SF executeTaskWithUpload:urlStr];
        
    }
}

//添加post请求任务 --- 上传音频
- (void)addUploadTaskWithUrl:(NSString *)urlStr normalParam:(NSDictionary *)dict voiceParam:(NSDictionary *)file completion:(void (^)(BOOL, NSData *))completion{
    
    //判断请求任务是否已经存在于任务队列中
    NSString *taskId = [NSString stringWithFormat:@"%@%@",urlStr,[self combineParam:dict]];
    taskId = [NSString stringWithFormat:@"%@%@",taskId,[self combineParam:file]];
    
    if (![_taskDict objectForKey:taskId]) {
        //进行网络请求
        ServerFetcher *SF = [self createHttpTask:taskId];
        SF.normalParamDict = dict;
        SF.voiceFileDict = file;
        SF.completion = completion;
        [SF executeTaskWithUpload:urlStr];
        
    }
}

//添加post请求任务 --- 上传视频
- (void)addUploadTaskWithUrl:(NSString *)urlStr normalParam:(NSDictionary *)dict videoParam:(NSDictionary *)file completion:(void (^)(BOOL, NSData *))completion{

}

//添加post请求任务 --- 上传各种文件
- (void)addUploadTaskWithUrl:(NSString *)urlStr normalParam:(NSDictionary *)dict images:(NSDictionary *)images voices:(NSDictionary *)voices completion:(void (^)(BOOL, NSData *))completion{
    
    //判断请求任务是否已经存在于任务队列中
    NSString *taskId = [NSString stringWithFormat:@"%@%@",urlStr,[self combineParam:dict]];
    taskId = [NSString stringWithFormat:@"%@%@",taskId,[self combineParam:images]];
    taskId = [NSString stringWithFormat:@"%@%@",taskId,[self combineParam:voices]];
    
    if (![_taskDict objectForKey:taskId]) {
        //进行网络请求
        ServerFetcher *SF = [self createHttpTask:taskId];
        SF.normalParamDict = dict;
        SF.imageFileDict = images;
        SF.voiceFileDict = voices;
        SF.completion = completion;
        [SF executeTaskWithUpload:urlStr];
        
    }
}

//下载文件
- (void)addDownloadTaskWithUrl:(NSString *)urlStr filePath:(NSString *)filePath underwayHandler:(void (^)(long long uploadBytes, long long expectedBytes))underwayHandler completionHandler:(void (^)(BOOL, NSData *))completionHandler{
    
}

//拼接参数 -- get
- (NSString *)httpBodyWithGet:(NSDictionary *)dict {
    
    NSMutableString *paraStr = [[NSMutableString alloc] init];
    for (NSString *key in [dict allKeys]) {
        NSString *value = [dict objectForKey:key];
        [paraStr appendFormat:@"&%@=%@",key,value];
    }
    if (paraStr) {
        return paraStr;
    }else{
        return @"";
    }
}

//拼接请求的参数 ---- 作为taskId的一部分
- (NSString *)combineParam:(NSDictionary *)dict {
    return [self httpBodyWithGet:dict];
}

//拼接参数 -- post
- (NSString *)httpBodyWithPost:(NSDictionary *)dict {
    
    NSMutableString *paraStr = [[NSMutableString alloc] init];
    for (NSString *key in [dict allKeys]) {
        NSString *value = [dict objectForKey:key];
        [paraStr appendFormat:@"&%@=%@",key,value];
    }
    if (paraStr) {
        return paraStr;
    }else{
        return @"";
    }
}

#pragma mark --- 任务完成回调
//请求完成 --- 请求成功
- (void)HttpTaskFinishWithClass:(ServerFetcher *)SF{
    if (SF.taskId) {
        [_taskDict removeObjectForKey:SF.taskId];
    }else{
        [_taskArr removeObject:SF];
    }
}

//请求失败
- (void)HttpTaskFailureWithClass:(ServerFetcher *)SF{
    if (SF.taskId) {
        [_taskDict removeObjectForKey:SF.taskId];
    }else{
        [_taskArr removeObject:SF];
    }
}


@end

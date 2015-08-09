//
//  ServerFetcher.m
//  TestHebei
//
//  Created by LYD on 15/1/30.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import "ServerFetcher.h"
//POST上传的分割线
#define SR_POST_BOUNDARY @"---------------------------7d33a816d302b6"

@implementation ServerFetcher{
    //判断当前去的请求是否是上传操作
    BOOL _isUpload;
    
    NSString *_httpBody;
    NSMutableData *_responseData;
    NSError *_error;
    NSURL *_url;
    NSMutableURLRequest *_request;
    NSURLConnection *_connection;
}
-(void)cancelRequest
{
    _request = nil;
    [_connection cancel];
}
//执行get请求任务
- (void)executeTaskWithGet:(NSString *)API{
    _url = [NSURL URLWithString:API];
    _request = [[NSMutableURLRequest alloc] initWithURL:_url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    NSLog(@"URL:%@",API);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error=nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:_request returningResponse:nil error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"error ==== %@",error);
            if (_completion) {//请求完成回调
                if (error) {//网络请求失败
                    _completion(NO,nil);
                    if (_delegate && [_delegate respondsToSelector:@selector(HttpTaskFailureWithClass:)]) {
                        [_delegate HttpTaskFailureWithClass:self];
                    }
                }else{//请求成功
                    _completion(YES,data);
                    if (_delegate && [_delegate respondsToSelector:@selector(HttpTaskFinishWithClass:)]) {
                        [_delegate HttpTaskFinishWithClass:self];
                    }
                }
            }
        });
    });
}

//执行请求任务 -- post请求
- (void)executeTaskWithPost:(NSString *)API andBody:(NSDictionary *)body{
    
    NSMutableString *mStr = [[NSMutableString alloc] init];
    int i=0;
    for (NSString *key in [body allKeys]) {
        [mStr appendFormat:@"%@=%@",key,[body objectForKey:key]];
        if (i < body.count-1) {
            [mStr appendString:@"&"];
        }
    }
    
    _url = [NSURL URLWithString:API];
    _request = [[NSMutableURLRequest alloc] initWithURL:_url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [_request setHTTPMethod:@"POST"];
    [_request setHTTPBody:[mStr dataUsingEncoding:NSUTF8StringEncoding]];
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
    [_connection start];
}

//执行上传任务
- (void)executeTaskWithUpload:(NSString *)API{
    _url = [NSURL URLWithString:API];
    _request = [[NSMutableURLRequest alloc] init];
    [_request setURL:_url];
    [_request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", SR_POST_BOUNDARY];
    [_request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    //拼接普通参数
    if (_normalParamDict && [_normalParamDict isKindOfClass:[NSDictionary class]]) {
        [body appendData:[self combineNormalParam]];
    }
    
    //拼接图片参数
    if (_imageFileDict && [_imageFileDict isKindOfClass:[NSDictionary class]]) {
        [body appendData:[self combineImageParam]];
    }
    
    //拼接音频参数
    if (_voiceFileDict && [_voiceFileDict isKindOfClass:[NSDictionary class]]) {
        [body appendData:[self combineVoiceParam]];
    }
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [_request setHTTPBody:body];
    
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
}

//拼接普通参数
- (NSData *)combineNormalParam{
    NSMutableData *data = [NSMutableData data];
    [data appendData:[[NSString stringWithFormat:@"--%@\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    for (NSString *key in _normalParamDict.allKeys) {
        id value = [_normalParamDict objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",key,value] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [data appendData:[[NSString stringWithFormat:@"--%@\r\n",SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            NSLog(@"please use addMultiPartData:withName:type:filename: Methods to implement");
        }
    }
    return data;
}

//拼接图片参数
- (NSData *)combineImageParam{
    NSMutableData *data = [NSMutableData data];
    for (NSString *key in _imageFileDict.allKeys) {
        
        NSString *imagePath = [_imageFileDict objectForKey:key];
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:imagePath];
        [fh seekToFileOffset:0];
        NSData *imageData = [fh availableData];
        [fh closeFile];
        //        NSLog(@"imagePath === %@",imagePath);
        
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"card.jpg\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[NSData dataWithData:imageData]];
        [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return data;
}

//拼接音频参数
- (NSData *)combineVoiceParam{
    NSMutableData *data = [NSMutableData data];
    for (NSString *key in _voiceFileDict.allKeys) {
        NSString *voicePath = [_voiceFileDict objectForKey:key];
        //        NSLog(@"voicePath === %@",voicePath);
        
        //音频文件 --- 压缩上传
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:voicePath];
        [fh seekToFileOffset:0];
        NSData *voiceData = [fh availableData];
        [fh closeFile];
        
        //拼接文件
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"video.wav\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[@"Content-Type: video/mpeg4\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[NSData dataWithData:voiceData]];
        [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return data;
}




//上传音频文件到服务器
- (void)uploadAudioPath:(NSString *)path andURL:(NSString *)url andQueue:(NSDictionary *)queue{
    _url = [NSURL URLWithString:url];
    _request = [[NSMutableURLRequest alloc] init];
    [_request setURL:_url];
    [_request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", SR_POST_BOUNDARY];
    [_request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    //其他非文件信息
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    for (NSString *key in queue.allKeys) {
        id value = [queue objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",key,value] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n",SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            NSLog(@"please use addMultiPartData:withName:type:filename: Methods to implement");
        }
    }
    
    //判断音频是否存在
    if (path.length != 0) {
        //音频文件 --- 压缩上传
        NSFileHandle *fh = [NSFileHandle fileHandleForReadingAtPath:path];
        [fh seekToFileOffset:0];
        NSData *file = [fh availableData];
        [fh closeFile];
        //拼接文件
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"video\"; filename=\"video.aac\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: video/wav\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:file]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [_request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:_request returningResponse:nil error:nil];
    _responseData = [NSMutableData dataWithData:returnData];
    
}


//上传图片  ---- 一张图片
- (void)uploadImage:(UIImage *)image andURL:(NSString *)url andQueue:(NSDictionary *)queue{
    _url = [NSURL URLWithString:url];
    
    _request = [[NSMutableURLRequest alloc] init];
    [_request setURL:_url];
    [_request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", SR_POST_BOUNDARY];
    [_request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    //其他非文件信息
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    for (NSString *key in queue.allKeys) {
        id value = [queue objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",key,value] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n",SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            NSLog(@"please use addMultiPartData:withName:type:filename: Methods to implement");
        }
    }
    
    // file 图片 --- 对图片进行压缩上传
    NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
    
    //拼接 file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"card\"; filename=\"card.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [_request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:_request returningResponse:nil error:nil];
    _responseData = [NSMutableData dataWithData:returnData];
    
}

//上传图片到服务器 ----- 多张图片
- (void)uploadImages:(NSMutableArray *)images andURL:(NSString *)url andQueue:(NSDictionary *)queue{
    _url = [NSURL URLWithString:url];
    _request = [[NSMutableURLRequest alloc] init];
    [_request setURL:_url];
    [_request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", SR_POST_BOUNDARY];
    [_request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    //其他非文件信息
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (NSString *key in queue.allKeys) {
        id value = [queue objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",key,value] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n",SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            NSLog(@"please use addMultiPartData:withName:type:filename: Methods to implement");
        }
    }
    
    //拼接图片
    int i=0;
    for (UIImage *image in images) {
        // file 图片 ---- 对图片进行压缩上传
        NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
        
        //拼接 file
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *contentStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file[]\"; filename=\"activity%d.jpg\"\r\n",i];
        [body appendData:[contentStr dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        i++;
    }
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [_request setHTTPBody:body];
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:_request returningResponse:nil error:nil];
    _responseData = [NSMutableData dataWithData:returnData];
    
}


//上传json数据 --- json:字典 key（拼接的属性）：值（字典或数组）
- (void)uploadJson:(NSDictionary *)json andURL:(NSString *)url andQueue:(NSDictionary *)queue {
    _url = [NSURL URLWithString:url];
    
    _request = [[NSMutableURLRequest alloc] init];
    [_request setURL:_url];
    [_request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", SR_POST_BOUNDARY];
    [_request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    //其他非文件信息
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    for (NSString *key in queue.allKeys) {
        id value = [queue objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",key,value] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n",SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            NSLog(@"please use addMultiPartData:withName:type:filename: Methods to implement");
        }
    }
    
    //json数据
    NSString *key = [[json allKeys] lastObject];
    if ([NSJSONSerialization isValidJSONObject:[json objectForKey:key]]) {
        NSLog(@"能够打包成json");
        NSData *arrayData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"arrayData == %@",arrayData);
        
        //拼接 json
        [body appendData:[@"Content-Type: application/json; encoding=utf-8\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",key,arrayData] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", SR_POST_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [_request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:_request returningResponse:nil error:nil];
    _responseData = [NSMutableData dataWithData:returnData];
}

#pragma mark --- 请求回调方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
    //NSLog(@"收到请求回复");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    //NSLog(@"下载中");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"下载完成");
    //传递当前请求对象
    if (_completion) {//直接回调
        _completion(YES, _responseData);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(HttpTaskFinishWithClass:)]) {
        [_delegate HttpTaskFinishWithClass:self];
    }
    _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"请求出错 error = %@",[error localizedRecoveryOptions]);
    if (_completion) {
        _completion(NO,nil);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(HttpTaskFailureWithClass:)]) {
        [_delegate HttpTaskFailureWithClass:self];
    }
}

- (void)dealloc{
    _completion = nil;
    NSLog(@"任务被销毁😊");
}

@end

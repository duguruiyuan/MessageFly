//
//  SignatureUtils.h
//  ALPPassDemo
//
//  Created by cuinacai on 13-6-18.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import "NSData+Base64.h"
@interface SignatureUtils : NSObject
+ (NSData *)getHashBytes:(NSData *)plainText;
-(SecKeyRef)getPublicKey:(NSString*)publicKeyString;
-(NSString *)signTheDataSHA1WithRSA:(NSString *)plainText andPcks12FilePath:(NSString *)p12FilePath
             withPcks12FilePassword:(NSString *)password;
-(OSStatus)verify:(NSString *)plainText signature:(NSData*)signatureData publicKey:(NSString*)publicKeyString;
@end

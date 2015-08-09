//
//  NSStringEx.h
//  iX3.0
//
//  Created by Feng Huajun on 09-5-10.
//  Copyright 2009 Infothinker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "util.h"

@interface NSString (NumberFormat) 

+(NSString*) stringForNumber:(double) f withCurrency:(NSString*) code;
+(NSString*) stringForNumber:(double) f ;
+(NSString*) numberStringWithNumber:(double) f;
+ (NSString*) stringForCNY:(double) f;

@end

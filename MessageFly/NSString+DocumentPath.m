//
//  NSString+DocumentPath.m
// 
//
//  Created by Bruce on 14-6-25.
//  Copyright (c) 2014年 Bruce. All rights reserved.
//

#import "NSString+DocumentPath.h"

@implementation NSString (DocumentPath)
+(NSString *)documentPathWith:(NSString *)fileName
{

    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
}
@end

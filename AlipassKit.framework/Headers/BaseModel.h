//
//  BaseModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
+(id)aliModel;
-(NSDictionary*)toDictionary;
-(NSArray*)arrayConverter:(NSArray*)converterArray;
@end

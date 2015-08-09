//
//  ALPPassZipTool.h
//  ALPPassDemo
//
//  Created by cuinacai on 13-6-20.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALPPassZipTool : NSObject
+(BOOL)zipFilesWithFilePaths:(NSArray*)paths withZipPath:(NSString*)zipPath;
+(NSString*)unzipFilePath:(NSString*)path toUnipPath:(NSString*)unzipPath;
@end

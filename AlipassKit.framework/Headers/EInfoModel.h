//
//  EInfoModel.h
//  AlipassKit
//
//  Created by cuinacai on 13-6-21.
//  Copyright (c) 2013年 cuinacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
/**
 * Pass特性Model
 */
@interface EInfoModel : BaseModel
/**Logo说明*/
@property(nonatomic,retain) NSString *logoText;

/**辅助Logo说明*/
@property(nonatomic,retain) NSString *secondLogoText;

/**显示内容,数组元素类型是EInfoUnitModel*/
@property(nonatomic,retain) NSMutableArray *headFields;

/**第一区域块展示内容,数组元素类型是EInfoUnitModel*/
@property(nonatomic,retain) NSMutableArray *primaryFields;

/**第二区域块展示内容,数组元素类型是EInfoUnitModel*/
@property(nonatomic,retain) NSMutableArray *secondaryFields;

/**辅助区域块展示内容,数组元素类型是EInfoUnitModel*/
@property(nonatomic,retain) NSMutableArray *auxiliaryFields;

/**背后区域块展示内容,数组元素类型是EInfoUnitModel*/
@property(nonatomic,retain) NSMutableArray *backFields;
@end

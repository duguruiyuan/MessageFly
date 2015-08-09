//
//  NSLocaleEx.h
//  iX3.0
//
//  Created by Feng Huajun on 5/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSLocale (Ext)

-(NSString*) currencyCode;
-(NSString*) currencySymbol;
-(NSString*) decimalSeparator;
+(NSString*) symbolForCurrencyCode:(NSString*) code;
+(NSString*) currencyStringForCurrencyCode:(NSString*) code;

@end

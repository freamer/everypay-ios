//
//  ErrorExtractor.h
//  everyPay
//
//  Created by Lauri Eskor on 25/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

/** 
 Helper for extracting errors from EveryPay server response.
 */

#import <Foundation/Foundation.h>

@interface ErrorExtractor : NSObject

/** 
 Extract error from EveryPay server response dictionary.
 @return Array of error objects present. In case of no errors, return an empty array.
 */
+ (NSArray *)errorsFromDictionary:(NSDictionary *)dictionary;

@end

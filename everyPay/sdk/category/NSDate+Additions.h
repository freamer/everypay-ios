//
//  NSDate+Additions.h
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

/** 
 Return date composed from year and month.
 */
+ (NSDate *)dateWithYear:(NSInteger)year andMonth:(NSInteger)month;

/** 
 return YES if month of date has passed.
 */

- (BOOL)dateHasPassed;

/** 
 Return string with format 9/2015.
 */
- (NSString *)expirationString;

@end

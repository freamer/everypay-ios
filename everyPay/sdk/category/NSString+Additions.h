//
//  NSString+Additions.h
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

/** 
 Returns a string where only digits are left
 */

- (NSString *)stringByRemovingAllNonNumerals;

@end

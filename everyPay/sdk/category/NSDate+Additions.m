//
//  NSDate+Additions.m
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+ (NSDate *)dateWithYear:(NSInteger)year andMonth:(NSInteger)month {
    NSDateComponents *components = [NSDateComponents new];
    [components setYear:year];
    [components setMonth:month];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *returnDate = [calendar dateFromComponents:components];
    return returnDate;
}

- (BOOL)dateHasPassed {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    BOOL result = nowComponents.year >= selfComponents.year && nowComponents.month >= selfComponents.month;
    return result;
}

- (NSString *)expirationString {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSString *returnString = [NSString stringWithFormat:@"%ld/%ld", (long)components.month, (long)components.year];
    return returnString;
}

@end

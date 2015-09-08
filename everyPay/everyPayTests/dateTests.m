//
//  dateTests.m
//  everyPay
//
//  Created by Lauri Eskor on 25/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSDate+Additions.h"

@interface dateTests : XCTestCase

@end

@implementation dateTests

- (void)testPassedDates {
    NSDate *dateInFuture = [NSDate dateWithYear:2020 andMonth:1];
    XCTAssert(![dateInFuture dateHasPassed]);
    
    // Date with same month/year as now is not passed
    NSDate *now = [NSDate date];
    XCTAssert(![now dateHasPassed]);
    
    NSDate *oldDate = [NSDate dateWithYear:2000 andMonth:1];
    XCTAssert([oldDate dateHasPassed]);
}

@end

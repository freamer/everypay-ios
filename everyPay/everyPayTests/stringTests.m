//
//  stringTests.m
//  everyPay
//
//  Created by Lauri Eskor on 25/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSString+Additions.h"

@interface stringTests : XCTestCase

@end

@implementation stringTests

- (void)testNonNumeralRemoval {
    NSString *stringWithOnlyNumerals = @"12345";
    NSString *result = [stringWithOnlyNumerals stringByRemovingAllNonNumerals];
    XCTAssert([stringWithOnlyNumerals isEqualToString:result]);
    
    NSString *stringWithGarbage = @"gb1%&2 lig3ljfg  4 ljgh5 lkjh";
    result = [stringWithGarbage stringByRemovingAllNonNumerals];
    XCTAssert([result isEqualToString:stringWithOnlyNumerals]);
    
    NSString *emptyString = @"";
    result = [emptyString stringByRemovingAllNonNumerals];
    XCTAssert([emptyString isEqualToString:result]);
    
    NSString *stringWithNoNumerals = @"lhdlfkjhzdlfgkhjdflskgh ldfh l hlh";
    result = [stringWithNoNumerals stringByRemovingAllNonNumerals];
    XCTAssert([emptyString isEqualToString:result]);
}

@end

//
//  luhnTests.m
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Luhn.h"

@interface luhnTests : XCTestCase

@end

@implementation luhnTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testValidCardNumber {
    NSString *validCardNumber = @"5450339000000014";
    BOOL isValid = [validCardNumber isValidCreditCardNumber];
    XCTAssert(isValid, @"Valid number 1");

    NSString *amexCardNumber = @"349 77536 28077 83";
    isValid = [amexCardNumber isValidCreditCardNumber];
    XCTAssert(isValid, @"Amex number");
}

- (void)testInvalidCardNumber {
    NSString *invalidNumber = @"545039000000014";
    BOOL isValid = [invalidNumber isValidCreditCardNumber];
    XCTAssert(!isValid, @"Invalid number 1");

    invalidNumber = @"";
    isValid = [invalidNumber isValidCreditCardNumber];
    XCTAssert(!isValid, @"Invalid number 2");
    
    invalidNumber = nil;
    isValid = [invalidNumber isValidCreditCardNumber];
    XCTAssert(!isValid, @"Invalid number 3");
    
    invalidNumber = @"5450339000000016";
    isValid = [invalidNumber isValidCreditCardNumber];
    XCTAssert(!isValid, @"Invalid number 4");

}

@end

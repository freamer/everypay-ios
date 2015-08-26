//
//  cardTests.m
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "EPCard.h"

#define kValidCardNumber @"5450339000000014"
#define kValidAmexCardNumber @"378638530069500"

@interface cardTests : XCTestCase

@end

@implementation cardTests

- (void)testValidCards {
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    EPCard *validCard = [[EPCard alloc] initWithName:@"Kaart" number:kValidCardNumber expirationDate:expirationDate andCVC:@"432"];
    NSError *isValid = [validCard validateCard];
    XCTAssert(isValid == nil, @"Card must be valid");
    
    EPCard *validAmexCard = [[EPCard alloc] initWithName:@"Kaart" number:kValidAmexCardNumber expirationDate:expirationDate andCVC:@"4321"];
    isValid = [validAmexCard validateCard];
    XCTAssert(isValid == nil, @"Amex card must be valid");
    
    validCard = [[EPCard alloc] initWithName:@"Kaart" number:kValidCardNumber expirationDate:expirationDate andCVC:@"43d2"];
    isValid = [validCard validateCard];
    XCTAssert(isValid == nil, @"Only digits must be left in numbers");
}

- (void)testCardCreationWithNilValue {
    NSDate *expirationDate = nil;
    EPCard *card = [[EPCard alloc] initWithName:@"Kaart" number:kValidAmexCardNumber expirationDate:expirationDate andCVC:@"432"];
    XCTAssert([card validateCard] != nil, @"Card with some missing things is not valid");
}

- (void)testExpiredCard {
    EPCard *card = [[EPCard alloc] initWithName:@"kaart" number:kValidAmexCardNumber expirationDate:[NSDate date] andCVC:@"2345"];
    NSError *error = [card validateCard];
    XCTAssert(error, @"expired card must be invalid");
}

- (void)testCVS {
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    EPCard *card = [[EPCard alloc] initWithName:@"Kaart" number:kValidCardNumber expirationDate:expirationDate andCVC:@"43"];
    NSError *error = [card validateCard];
    XCTAssert(error, @"Valid card must have cvc of lebgth 3");

    EPCard *amexCard = [[EPCard alloc] initWithName:@"Kaart" number:kValidAmexCardNumber expirationDate:expirationDate andCVC:@"43221"];
    error = [amexCard validateCard];
    XCTAssert(error, @"Amex card must have cvc of length 4");
}

- (void)testInvalidNumber {
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    EPCard *card = [[EPCard alloc] initWithName:@"Kaart" number:@"54503390000000142" expirationDate:expirationDate andCVC:@"443"];
    NSError *error = [card validateCard];
    XCTAssert(error, @"Card number must be invalid");
}

@end

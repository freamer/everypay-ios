//
//  NSError+Additions.m
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "NSError+Additions.h"
#import "Constants.h"

#define kErrorDomain @"com.everyPay"
@implementation NSError (Additions)

+ (NSError *)errorWithDescription:(NSString *)descrpition andCode:(NSInteger)errorCode {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(descrpition, nil)};
    NSError *returnError = [[NSError alloc] initWithDomain:kErrorDomain code:errorCode userInfo:userInfo];
    return returnError;
}

@end

//
//  Constants.h
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Define constants for global use
 */

// Network return blocks
typedef void (^DictionarySuccessBlock)(NSDictionary *dictionary);
typedef void (^StringSuccessBlock)(NSString *string);
typedef void (^FailureBlock)(NSError *error);
typedef void (^ArrayBlock)(NSArray *array);

// base urls
extern NSString *const kEveryPayApiTesting;
extern NSString *const kEveryPayApiLive;
extern NSString *const kMercantApiTesting;

// Json keys
extern NSString *const kKeyAccountId;
extern NSString *const kKeyApiUsername;
extern NSString *const kKeyHmac;
extern NSString *const kKeyNonce;
extern NSString *const kKeyTimestamp;
extern NSString *const kKeyUserIp;
extern NSString *const kKeyCardNumber;
extern NSString *const kKeyCardYear;
extern NSString *const kKeyCardMonth;
extern NSString *const kKeyCardName;
extern NSString *const kKeySingleUseToken;
extern NSString *const kKeyEncryptedToken;
extern NSString *const kKeyEncryptedPaymentInstrument;

extern NSString *const kKeyErrors;
extern NSString *const kKeyError;
extern NSString *const kKeyMessage;
extern NSString *const kKeyCode;

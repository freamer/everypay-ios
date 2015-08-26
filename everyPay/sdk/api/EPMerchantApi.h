//
//  EPMerchantApi.h
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface EPMerchantApi : NSObject

+ (NSURLSession *)sharedSession;

+ (void)getMerchantDataWithSuccess:(DictionarySuccessBlock)success andError:(FailureBlock)failure;
+ (void)sendPaymentWithToken:(NSString *)token andMerchantInfo:(NSDictionary *)merchantInfo withSuccess:(DictionarySuccessBlock)success andError:(FailureBlock)failure;

@end

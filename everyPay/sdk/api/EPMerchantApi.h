//
//  EPMerchantApi.h
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

/** 
 Sample implementations of client <-> merchant server communication.
 */

@interface EPMerchantApi : NSObject

/** 
 Get merchant EveryPay user and communication security data.
 */
+ (void)getMerchantDataWithSuccess:(DictionarySuccessBlock)success andError:(FailureBlock)failure;

/** 
 Send payment to merchant server
 
 @param token token received from EveryPay server
 @param merchantInfo dictionary containing merchant info data. See EPApi documentation for exact elements that must be there.
 */

+ (void)sendPaymentWithToken:(NSString *)token andMerchantInfo:(NSDictionary *)merchantInfo withSuccess:(DictionarySuccessBlock)success andError:(FailureBlock)failure;

@end

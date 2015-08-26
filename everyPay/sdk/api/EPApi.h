//
//  EPApi.h
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "EPCard.h"

// For easy include to projects
#import "EPCardInfoViewController.h"
#import "EPMerchantApi.h"

@interface EPApi : NSObject

+ (NSURLSession *)sharedSession;

+ (void)sendCard:(EPCard *)card withMerchantInfo:(NSDictionary *)merchantInfo withSuccess:(StringSuccessBlock)success andError:(ArrayBlock)failure;

@end

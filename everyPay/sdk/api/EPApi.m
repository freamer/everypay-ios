//
//  EPApi.m
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "EPApi.h"
#import "Constants.h"
#import "DeviceInfo.h"
#import "ErrorExtractor.h"

NSString *const kSendCardDetailsPath = @"encrypted_payment_instruments";

@implementation EPApi

+ (void)sendCard:(EPCard *)card withMerchantInfo:(NSDictionary *)merchantInfo withSuccess:(StringSuccessBlock)success andError:(ArrayBlock)failure {
    NSURL *baseApiUrl = [NSURL URLWithString:kEveryPayApiTesting];
    NSURL *url = [NSURL URLWithString:kSendCardDetailsPath relativeToURL:baseApiUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSMutableDictionary *merchantDictionary = [NSMutableDictionary dictionaryWithDictionary:merchantInfo];
    [merchantDictionary addEntriesFromDictionary:[card cardInfoDictionary]];
    
    NSDictionary *requestDictionary = @{kKeyEncryptedPaymentInstrument: merchantDictionary};
    NSError *jsonConversionError;

    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:kNilOptions error:&jsonConversionError];
    
    NSLog(@"Start request %@\n", request);
    NSLog(@"Request body %@\n", requestDictionary);
    
    NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Request completed with response\n %@", response);
        if (error) {
            failure(@[error]);
        } else {
            NSError *jsonParsingError;
            NSDictionary *responseDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParsingError];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(@[error]);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *errors = [ErrorExtractor errorsFromDictionary:responseDictionary];
                    if ([errors count] > 0) {
                        NSLog(@"Error processing payment: %@", errors);
                        failure(errors);
                    } else {
                        /** 
                         Response dictionary: 
                         {
                            "encrypted_payment_instrument" = {
                                "cc_token_encrypted" = "QEVuQwBAEAAcXJQdBNP2fcVbANPoc+KdE9flBsC4O8hZQPut4MLjMKAVjTt9JDI8eqTpYiDH9dE=-1440501330";
                            };
                         }
                         */
                        NSDictionary *tokenDictionary = [responseDictionary objectForKey:kKeyEncryptedPaymentInstrument];
                        NSString *encryptedToken = [tokenDictionary objectForKey:kKeyEncryptedToken];
                        success(encryptedToken);
                    }
                });
            }
        }
    }];
    
    [uploadTask resume];
}

@end

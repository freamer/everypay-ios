//
//  EPMerchantApi.m
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "EPMerchantApi.h"
#import "DeviceInfo.h"

NSString *const kGetMerchantInfoPath = @"/merchant_mobile_payments/generate_token_api_parameters";
NSString *const kSendPaymentPath = @"/merchant_mobile_payments/pay";

@implementation EPMerchantApi

+ (NSURLSession *)sharedSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return session;
}

+ (void)getMerchantDataWithSuccess:(DictionarySuccessBlock)success andError:(FailureBlock)failure {
    NSURL *merchantApiBaseUrl = [NSURL URLWithString:kMercantApiTesting];
    NSURL *url = [NSURL URLWithString:kGetMerchantInfoPath relativeToURL:merchantApiBaseUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";

    NSLog(@"Start request %@\n", request);

    NSData *deviceInfo = [DeviceInfo deviceInfoData];
    
    NSURLSessionUploadTask *uploadTask = [[EPMerchantApi sharedSession] uploadTaskWithRequest:request fromData:deviceInfo completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"Request completed with response\n %@", response);

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        } else {
            NSError *jsonParsingError;
            NSDictionary *responseDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParsingError];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseDictionary);
            });
        }
    }];

    [uploadTask resume];
}

+ (void)sendPaymentWithToken:(NSString *)token andMerchantInfo:(NSDictionary *)merchantInfo withSuccess:(DictionarySuccessBlock)success andError:(FailureBlock)failure {
    NSURL *merchantApiBaseUrl = [NSURL URLWithString:kMercantApiTesting];
    NSURL *url = [NSURL URLWithString:kSendPaymentPath relativeToURL:merchantApiBaseUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSLog(@"Start request %@\n", request);
    
    NSString *hmac = [merchantInfo objectForKey:kKeyHmac];
    NSDictionary *requestDictionary = @{kKeyHmac: hmac, kKeyEncryptedToken: token};
    NSError *jsonConversionError = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:kNilOptions error:&jsonConversionError];
    
    NSURLSessionUploadTask *uploadTask = [[EPMerchantApi sharedSession] uploadTaskWithRequest:request fromData:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"Request completed with response\n %@", response);
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        } else {
            NSError *jsonParsingError;
            NSDictionary *responseDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonParsingError];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseDictionary);
            });
        }
    }];
    
    [uploadTask resume];
}

@end

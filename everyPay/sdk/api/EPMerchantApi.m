//
//  EPMerchantApi.m
//  everyPay
//
//  Created by Lauri Eskor on 24/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "EPMerchantApi.h"
#import "DeviceInfo.h"
#import "ViewController.h"
#import "EPSession.h"

NSString *const kGetMerchantInfoPath = @"/merchant_mobile_payments/generate_token_api_parameters";
NSString *const kSendPaymentPath = @"/merchant_mobile_payments/pay";
NSString *const kApiVersion = @"api_version";
NSString *const kAccountId = @"account_id";

@implementation EPMerchantApi

+ (void)getMerchantDataWithSuccess:(DictionarySuccessBlock)success andError:(FailureBlock)failure apiVersion:(NSString *)apiVersion accountId:(NSString *)accountId{
    NSURL *merchantApiBaseUrl = [NSURL URLWithString:[EPSession sharedInstance].merchantApiBaseUrl];
    NSURL *url = [NSURL URLWithString:kGetMerchantInfoPath relativeToURL:merchantApiBaseUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"POST";

    NSLog(@"Start request %@\n", request);

    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    [requestDictionary setValue:apiVersion forKey:kApiVersion];
    [requestDictionary setValue:accountId forKey: kAccountId];
    NSData *requestData = [EPMerchantApi convertToDataWithDictionary:requestDictionary];
    NSLog(@"Request body %@", [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding]);
    NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"Request completed with response\n %@", response);

        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        } else {
            NSError *jsonParsingError;
            NSDictionary *responseDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParsingError];
            NSLog(@" Get Merchant Data Response body %@", responseDictionary);
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseDictionary);
            });
        }
    }];

    [uploadTask resume];
}

+ (void)sendPaymentWithToken:(NSString *)token andMerchantInfo:(NSDictionary *)merchantInfo withSuccess:(DictionarySuccessBlock)success andError:(FailureBlock)failure {
    NSURL *merchantApiBaseUrl = [NSURL URLWithString:[EPSession sharedInstance].merchantApiBaseUrl];
    NSURL *url = [NSURL URLWithString:kSendPaymentPath relativeToURL:merchantApiBaseUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSLog(@"Start request %@\n", request);
    
    NSString *hmac = [merchantInfo objectForKey:kKeyHmac];
    NSDictionary *requestDictionary = @{kKeyHmac: hmac, kKeyEncryptedToken: token};
    NSError *jsonConversionError = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:kNilOptions error:&jsonConversionError];
    NSLog(@"Request body %@", [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding]);
    NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"Request completed with response\n %@", response);
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        } else {
            NSError *jsonParsingError;
            NSDictionary *responseDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonParsingError];
            NSLog(@" Send payment response body %@",requestDictionary);
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseDictionary);
            });
        }
    }];
    
    [uploadTask resume];
}

+ (NSData *)convertToDataWithDictionary:(NSDictionary *)dictionary {
    NSError *jsonConversionError;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&jsonConversionError];
    return requestData;

}

@end

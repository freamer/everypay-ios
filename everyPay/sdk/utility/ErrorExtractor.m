//
//  ErrorExtractor.m
//  everyPay
//
//  Created by Lauri Eskor on 25/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "ErrorExtractor.h"
#import "NSError+Additions.h"
#import "Constants.h"

@implementation ErrorExtractor

/** Errordictionary has the following structure:
 {
 errors =     (
 {
 code = 2055;
 message = "Unknown api_user '7e250861ef710b10'";
 },
 {
 code = 2067;
 message = "Missing processing account field";
 },
 {
 code = 2068;
 message = "The processing account '' is invalid";
 }
 );
 }
 
 */
+ (NSArray *)errorsFromDictionary:(NSDictionary *)dictionary {
    NSMutableArray *returnArray = [NSMutableArray array];
    
    NSArray *errorsArray = [dictionary objectForKey:kKeyErrors];
    for (NSDictionary *errorDictionary in errorsArray) {
        NSInteger code = [[errorDictionary objectForKey:kKeyCode] integerValue];
        NSString *message = [errorDictionary objectForKey:kKeyMessage];
        NSError *error = [NSError errorWithDescription:message andCode:code];
        [returnArray addObject:error];
    }
    
    return [returnArray copy];
}

@end

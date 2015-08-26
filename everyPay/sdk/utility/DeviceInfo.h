//
//  DeviceInfo.h
//  everyPay
//
//  Created by Lauri Eskor on 25/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Class for collecting device info.
 */
@interface DeviceInfo : NSObject

+ (NSData *)deviceInfoData;
+ (NSDictionary *)deviceInfoDictionary;

@end

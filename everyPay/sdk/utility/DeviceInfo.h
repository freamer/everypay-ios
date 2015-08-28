//
//  DeviceInfo.h
//  everyPay
//
//  Created by Lauri Eskor on 25/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Class for collecting device info. Currently responds with dummy data.
 */

@interface DeviceInfo : NSObject

/** 
 Collects different device data.
 Collects device model, os and kernel versions.
 @return NSData with device info
 */
+ (NSData *)deviceInfoData;

@end

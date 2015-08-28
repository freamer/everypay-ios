//
//  DeviceInfo.m
//  everyPay
//
//  Created by Lauri Eskor on 25/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "DeviceInfo.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>

NSString *const kDeviceInfoKeyKernel = @"kernelVersion";
NSString *const kDeviceInfoDeviceModel = @"deviceModel";
NSString *const kDeviceInfoIOSVersion = @"iosVersion";
NSString *const kDeviceInfoRoot = @"device_info";

@implementation DeviceInfo

+ (NSData *)deviceInfoData {
    NSError *jsonConversionError;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:[DeviceInfo deviceInfoDictionary] options:kNilOptions error:&jsonConversionError];
    return requestData;
}

+ (NSDictionary *)deviceInfoDictionary {
    UIDevice *device = [UIDevice currentDevice];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *kernelVersion = [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
    NSString *osVersion = [device systemVersion];

    NSDictionary *deviceInfoDictionary = @{kDeviceInfoDeviceModel: deviceModel, kDeviceInfoIOSVersion: osVersion, kDeviceInfoKeyKernel: kernelVersion};
    NSDictionary *resultDictionary = @{kDeviceInfoRoot: deviceInfoDictionary};

    return resultDictionary;
}

@end

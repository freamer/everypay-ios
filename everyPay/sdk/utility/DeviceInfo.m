//
//  DeviceInfo.m
//  everyPay
//
//  Created by Lauri Eskor on 25/08/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "DeviceInfo.h"

// Sample device info from Android emulator
NSString *const kAndroidDeviceInfoString = @"{\"device_info\":{\"android_id\":{\"error\":null,\"value\":\"1ad47fa797c215844\"},\"app_install_token\":{\"error\":null,\"value\":\"7e46d8e7-8046-4b7a-a548-c53bcc076945\"},\"hardware\":{\"error\":null,\"value\":{\"board\":\"unknown\",\"brand\":\"generic_x86_64\",\"cpu_abi\":\"x86_64\",\"cpu_abi2\":\"\",\"device\":\"generic_x86_64\",\"hardware\":\"goldfish\",\"manufacturer\":\"unknown\",\"model\":\"Android SDK built for x86_64\",\"product\":\"sdk_phone_x86_64\",\"radio_version\":\"\",\"serial\":\"unknown\"}},\"net_macs\":{\"error\":null,\"value\":{\"eth0\":\"525400123456\"}},\"os\":{\"error\":null,\"value\":{\"bootloader\":\"unknown\",\"display\":\"sdk_phone_x86_64-eng 6.0 MRA44C 2166767 test-keys\",\"fingerprint\":\"generic_x86_64/sdk_phone_x86_64/generic_x86_64:6.0/MRA44C/2166767:eng/test-keys\",\"id\":\"MRA44C\",\"os\":\"Android\",\"tags\":\"test-keys\",\"version_name\":\"6.0\",\"version_sdk\":23},\"wifi_mac\":{\"error\":null,\"value\":\"020000000000\"}}}}";

// Dummy device info string 
NSString *const kIPhoneDeviceInfoString = @"{\"device_info\":{\"android_id\":{\"error\":null,\"value\":\"1ad47fa797c215844\"}}";

@implementation DeviceInfo

+ (NSData *)deviceInfoData {
    NSData *requestBodyData = [kIPhoneDeviceInfoString dataUsingEncoding:NSUTF8StringEncoding];
    return requestBodyData;
}

+ (NSDictionary *)deviceInfoDictionary {
    NSData *deviceInfoData = [DeviceInfo deviceInfoData];

    NSError *jsonError;
    NSDictionary *deviceInfoDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:deviceInfoData options:0 error:&jsonError];
    return deviceInfoDictionary;
}
@end

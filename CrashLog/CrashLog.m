//
//  CrashLog.m
//  CrashLog
//
//  Created by chedao on 17/3/15.
//  Copyright © 2017年 chedao. All rights reserved.
//

#import "CrashLog.h"
#import <UIKit/UIKit.h>
#import "sys/utsname.h"
@implementation CrashLog

+(CrashLog*)share{

    static CrashLog * crashLog = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        crashLog = [[CrashLog alloc] init];
    });
    return crashLog;
}


-(void)openCrashLogCollection{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}


#pragma mark--获取异常崩溃信息
void UncaughtExceptionHandler(NSException *exception){
    
    /**
     * 获取异常崩溃信息
     */
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSDictionary * dict = @{@"reason":reason,
                            @"name"  :name,
                            @"callStack":callStack,
                            @"appName":[[CrashLog share] getAppName],
                            @"appVersion":[[CrashLog share] getAppVersion],
                            @"systemVersion":[[CrashLog share] getSystemVersion],
                            @"phoneModel":[[CrashLog share] getPhoneModel],
                            @"deviceVersion":[[CrashLog share] getDeviceVersion]};

    
    [[CrashLog share] saveCrashLog:dict];
}

//crash日志文件
-(NSString*)crashLogFile{
 
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:@"/crashLog.plist"];
}
//保存crash
-(BOOL)saveCrashLog:(NSDictionary*)log{

    NSString *path = [self crashLogFile];
    NSMutableArray  * array = [NSMutableArray arrayWithArray:[self readCrahLog]];
    [array addObject:log];
   return  [array writeToFile:path atomically:YES];
    
}
//读取crash
-(NSArray*)readCrahLog{

    NSString *path = [self crashLogFile];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return  [NSArray arrayWithContentsOfFile:path];
    }
    return nil;
}
//移除crash
-(BOOL)removeCrashLog{

    return [[NSFileManager defaultManager] removeItemAtPath:[self crashLogFile] error:nil];
    
}


#pragma MARK ===== 获取手机设配信息
/** 设备名字 */
-(NSString*)getAppName{
    NSDictionary * dict = [[NSBundle mainBundle] infoDictionary];
    if (dict[@"CFBundleDisplayName"] != nil) {
        return dict[@"CFBundleDisplayName"];
    }
    return @"";
}

/** 版本号  */
-(NSString*)getAppVersion{
    NSDictionary * dict = [[NSBundle mainBundle] infoDictionary];
    return dict[@"CFBundleShortVersionString"];
}

/** 手机系统版本 */
-(NSString*)getSystemVersion{
    return [[UIDevice currentDevice] systemVersion];
}

/** 设备类型 iphone/ipad/ipod */
-(NSString*)getPhoneModel{
    return [[UIDevice currentDevice] model];
}

/** 设备型号 */
-(NSString*)getDeviceVersion{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    //    if ([deviceString hasPrefix:@"iPhone"])             return @"iPhone";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    //    if ([deviceString hasPrefix:@"iPod"])               return @"iPod";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;

}

@end

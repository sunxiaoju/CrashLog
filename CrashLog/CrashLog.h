//
//  CrashLog.h
//  CrashLog
//
//  Created by chedao on 17/3/15.
//  Copyright © 2017年 chedao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashLog : NSObject

+(CrashLog*)share;

/** 添加崩溃日志手机  */
-(void)openCrashLogCollection;

//读取crash
-(NSArray*)readCrahLog;
//移除crash
-(BOOL)removeCrashLog;
@end

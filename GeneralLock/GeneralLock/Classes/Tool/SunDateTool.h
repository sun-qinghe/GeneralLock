//
//  SunDateTool.h
//  MyBike
//
//  Created by sun on 2017/11/24.
//  Copyright © 2017年 sunxingxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunDateTool : NSObject

///获取yyyy-MM-dd
+ (NSString *)getYYYYMMDDWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)getYYYYMMDDWithDate:(NSDate *)date;

///获取yyyy-MM-dd HH:mm
+ (NSString *)getYYYYMMDDHHMMWithWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)getYYYYMMDDHHMMWithDate:(NSDate *)date;

///获取yyyy-MM-dd HH:mm:ss 格式
+ (NSString *)getYYYYMMDDHHMMSSWithDate:(NSDate *)date;

+ (NSString *)getStringWithDateFormatStr:(NSString *)dateFormat date:(NSDate *)date;
+ (NSString *)getStringWithDateFormatStr:(NSString *)dateFormat timeInterval:(NSTimeInterval)timeInterval;

@end

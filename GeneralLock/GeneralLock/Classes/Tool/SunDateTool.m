//
//  SunDateTool.m
//  MyBike
//
//  Created by sun on 2017/11/24.
//  Copyright © 2017年 sunxingxiang. All rights reserved.
//

#import "SunDateTool.h"

@implementation SunDateTool

///获取yyyy-MM-dd
+ (NSString *)getYYYYMMDDWithTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self getYYYYMMDDWithDate:date];
}

+ (NSString *)getYYYYMMDDWithDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

///获取yyyy-MM-dd HH:mm
+ (NSString *)getYYYYMMDDHHMMWithWithTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self getYYYYMMDDHHMMWithDate:date];
}

+ (NSString *)getYYYYMMDDHHMMWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
}

+ (NSString *)getStringWithDateFormatStr:(NSString *)dateFormat date:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:date];
}

+ (NSString *)getStringWithDateFormatStr:(NSString *)dateFormat timeInterval:(NSTimeInterval)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self getStringWithDateFormatStr:dateFormat date:date];
}

///获取yyyy-MM-dd HH:mm:ss 格式
+ (NSString *)getYYYYMMDDHHMMSSWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

@end

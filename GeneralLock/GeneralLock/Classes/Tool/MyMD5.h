//
//  MyMD5.h
//  ElectronicLock
//
//  Created by anzhongdianzi on 16/5/10.
//  Copyright © 2016年 niehaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMD5 : NSObject

+(NSString *)md5HexDigest:(NSString *)input;

+ (NSString *)set32MD5:(NSString *)str;

+ (NSString *) set16MD5:(NSString *) str;

@end

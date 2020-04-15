//
//  NSObject+Global.h
//  飞鸽运维
//
//  Created by anzhong on 2018/6/5.
//  Copyright © 2018年 anda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Global)

+ (BOOL)object_isNullOrNilWithObject:(id)object;

@end

@interface UIImage (image)

+ (instancetype)imageWithColor:(UIColor *)color;

- (instancetype)imageCompressToSize:(CGSize)size;

@end

@interface NSString (string)
+ (NSString *) setTS;
+ (NSMutableAttributedString *)attrWithString:(NSString *)str;
//+ (NSMutableAttributedString *)attrWithString:(NSString *)str WithColor:(UIColor *)color WithFontSize:(CGFloat)fontSize;
//- (CGSize)textSizeWithMaxSize:(CGSize)maxSize textFontSize:(CGFloat)fontSize;

/**
 验证 字符串中是否包含空格
 */
+ (BOOL)isHaveSpaceInString:(NSString *)string;

/**
 --去除 字符串 头尾空格 --
 */
+ (NSString *)removeSpaceInEndToEnd:(NSString *)string;

/**
 去除 字符串 包含所有空格
 */
+ (NSString *)removeAllSpace:(NSString *)string;

/**
 十进制字符串转换成十六进制字符串
 */
+ (NSString *)convertStringToHexStr:(NSString *)str;

/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal;

@end


@interface UITextField (textField)

+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder textColor:(UIColor *)color fontSize:(CGFloat)size;

@end


@interface NSDictionary (dic)

- (BOOL)isSuccess;

@end

@interface NSData (data)

+(NSData*) hexToBytesWithString:(NSString *)string;

@end


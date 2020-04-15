//
//  NSObject+Global.m
//  飞鸽运维
//
//  Created by anzhong on 2018/6/5.
//  Copyright © 2018年 anda. All rights reserved.
//

#import "NSObject+Global.h"

@implementation NSObject (Global)

+ (BOOL)object_isNullOrNilWithObject:(id)object;
{
    if (object == nil || [object isEqual:[NSNull class]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

@end

@implementation UIImage (image)

+ (instancetype)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context,rect);
    CGContextSaveGState(context);
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (instancetype)imageCompressToSize:(CGSize)size {
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
        NSAssert(newImage == nil, @"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}


@end

@implementation NSString (string)

/**
 时间戳
 */
+ (NSString *) setTS {
    // 10位时间戳
    int time = [[NSDate date] timeIntervalSince1970];
    NSString *ts = [NSString stringWithFormat:@"%d",time];
    
    return ts;
}

+ (NSMutableAttributedString *)attrWithString:(NSString *)str {
    NSUInteger location = [str rangeOfString:@":"].location;
    NSMutableAttributedString *mutAttrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [mutAttrStr addAttributes:@{
                                NSForegroundColorAttributeName:UIColorWithRGB(172, 172, 172)
                                } range:NSMakeRange(location + 1, str.length - location - 1)];
    return mutAttrStr;
}

//+ (NSMutableAttributedString *)attrWithString:(NSString *)str WithColor:(UIColor *)color WithFontSize:(CGFloat)fontSize; {
//    NSUInteger location = [str rangeOfString:@":"].location;
//    NSMutableAttributedString *mutAttrStr = [[NSMutableAttributedString alloc] initWithString:str];
//    [mutAttrStr addAttributes:@{
//                                NSForegroundColorAttributeName:color,
//                                NSFontAttributeName:UISystemFont(fontSize)
//                                } range:NSMakeRange(location + 1, str.length - location - 1)];
//    return mutAttrStr;
//}
//
//- (CGSize)textSizeWithMaxSize:(CGSize)maxSize textFontSize:(CGFloat)fontSize {
//    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
//    return size;
//}

+ (BOOL)isHaveSpaceInString:(NSString *)string {
    NSRange _range = [string rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

+ (NSString *)removeSpaceInEndToEnd:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)removeAllSpace:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - 将NSString转换成十六进制的字符串则可使用如下方式
+ (NSString *)convertStringToHexStr:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}
/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}


@end


@implementation UITextField (textField)

+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder textColor:(UIColor *)color fontSize:(CGFloat)size{
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.textColor = color;
    textField.font = [UIFont systemFontOfSize:size];
    return textField;
}

@end


@implementation NSDictionary (dic)
- (BOOL)isSuccess {
    if ([[self valueForKey:@"Success"] intValue]) {
        return YES;
    } else {
        return NO;
    }
}
@end


@implementation NSData (data)
/**
 十六进制字符串 -->  Data
 */
+(NSData*) hexToBytesWithString:(NSString *)string {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= string.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [string substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

@end

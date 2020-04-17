//
//  Encryption.h
//  AES128-test
//
//  Created by 安中 on 2017/9/25.
//  Copyright © 2017年 安中. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encryption : NSObject

+(NSData *)AES128ParmEncryptWithKey:(NSString *)key Encrypttext:(NSData *)text;   //加密

+(NSData *)AES128ParmDecryptWithKey:(NSString *)key Decrypttext:(NSData *)text;   //解密

+(NSString *) aes128_encrypt:(NSString *)key Encrypttext:(NSString *)text;

+(NSString *) aes128_decrypt:(NSString *)key Decrypttext:(NSString *)text;


/** --CBC 加密 -- */
+ (NSString*) AES128Encrypt:(NSString *)plainText Key:(NSString *)keyStr Iv:(NSString *)ivStr;
/** --CBC 解密 -- */
+ (NSString*) AES128Decrypt:(NSString *)encryptText Key:(NSString *)keyStr Iv:(NSString *)ivStr;



@end

//
//  Encryption.m
//  AES128-test
//
//  Created by 安中 on 2017/9/25.
//  Copyright © 2017年 安中. All rights reserved.
//

#import "Encryption.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

#define gkey @"16位长度的字符串" //自行修改
#define gIv @"16位长度的字符串" //自行修改

@implementation Encryption

// 加密
+(NSData *)AES128ParmEncryptWithKey:(NSString *)key Encrypttext:(NSData *)text  //加密

{
    
    char keyPtr[kCCKeySizeAES128+1];
    
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [text length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          
                                          0x0000 | kCCOptionECBMode,
                                          
                                          keyPtr, kCCBlockSizeAES128,
                                          
                                          NULL,
                                          
                                          [text bytes], dataLength,
                                          
                                          buffer, bufferSize,
                                          
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    }
    
    free(buffer);
    
    return nil;
    
}


// 解密
+ (NSData *)AES128ParmDecryptWithKey:(NSString *)key Decrypttext:(NSData *)text  //解密

{
    
    char keyPtr[kCCKeySizeAES128+1];
    
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [text length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          
                                          0x0000 | kCCOptionECBMode,
                                          
                                          keyPtr, kCCBlockSizeAES128,
                                          
                                          NULL,
                                          
                                          [text bytes], dataLength,
                                          
                                          buffer, bufferSize,
                                          
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        
    }
    
    free(buffer);
    
    return nil;
    
}


+(NSString *) aes128_encrypt:(NSString *)key Encrypttext:(NSString *)text

{
    
    const char *cstr = [text cStringUsingEncoding:NSUTF8StringEncoding];

    NSData *data = [NSData dataWithBytes:cstr length:text.length];
    
    
    //对数据进行加密
    
    NSData *result = [Encryption AES128ParmEncryptWithKey:key Encrypttext:data];
    
    
    //转换为2进制字符串

    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];

        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];

        for(int i = 0; i < result.length; i++){

            [output appendFormat:@"%02x", datas[i]];

        }

        return output;

    }

    return nil;
    
}



//data转换为十六进制的string
+ (NSString *)hexStringFromData:(NSData *)myD{
    
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    
    return hexStr;
}

+(NSString *) aes128_decrypt:(NSString *)key Decrypttext:(NSString *)text {
    
    //转换为2进制Data
    
    NSMutableData *data = [NSMutableData dataWithCapacity:text.length / 2];
    
    unsigned char whole_byte;
    
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    
    for (i=0; i < [text length] / 2; i++) {
        
        byte_chars[0] = [text characterAtIndex:i*2];
        
        byte_chars[1] = [text characterAtIndex:i*2+1];
        
        whole_byte = strtol(byte_chars, NULL, 16);
        
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    
    NSData* result = [Encryption  AES128ParmDecryptWithKey:key Decrypttext:data];
    
    if (result && result.length > 0) {
        
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}


+ (NSString*) AES128Encrypt:(NSString *)plainText Key:(NSString *)keyStr Iv:(NSString *)ivStr
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [keyStr getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [ivStr getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    int newSize = 0;
    
    if(diff > 0)
    {
        newSize = dataLength + diff;
    }
    
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for(int i = 0; i < diff; i++)
    {
        dataPtr[i + dataLength] = 0x00;
    }
    
    size_t bufferSize = newSize + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    memset(buffer, 0, bufferSize);
    
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,               //No padding
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          ivPtr,
                                          dataPtr,
                                          sizeof(dataPtr),
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [GTMBase64 stringByEncodingData:resultData];
    }
    free(buffer);
    return nil;
}

+ (NSString*) AES128Decrypt:(NSString *)encryptText Key:(NSString *)keyStr Iv:(NSString *)ivStr
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [keyStr getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [ivStr getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}


@end

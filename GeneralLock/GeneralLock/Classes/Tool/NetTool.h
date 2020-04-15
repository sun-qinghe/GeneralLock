//
//  NetTool.h
//  安达工厂
//
//  Created by anzhong on 2017/12/2.
//  Copyright © 2017年 anda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface NetTool : NSObject

+ (instancetype)sharedManager;

- (void)getWithUrl:(NSString *)url
              sign:(NSString *)signStr
        parameters:(NSDictionary *)parameter
           success:(void (^)(id successResponse))success
              fail:(void(^)(id failResponse))fail;

- (void)postWithUrl:(NSString *)url
               sign:(NSString *)signStr
         parameters:(NSDictionary *)parameter
            success:(void(^)(id successResponse))success
               fail:(void(^)(id failResponse))fail;

//post上传多张图片
- (void)uploadImgWithUrl:(NSString *)url
                  params:(NSDictionary *)params
             uploadImages:(NSArray *)images
                 success:(void (^)(id response))success
                 failure:(void (^)(AFHTTPRequestSerializer *operation,NSError *error))Error;

@end

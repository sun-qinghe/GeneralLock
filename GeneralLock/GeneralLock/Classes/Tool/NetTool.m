//
//  NetTool.m
//  安达工厂
//
//  Created by anzhong on 2017/12/2.
//  Copyright © 2017年 anda. All rights reserved.
//

#import "NetTool.h"
#import "MyMD5.h"

#define MD5_UID @"110"
@implementation NetTool

static NetTool *_instance;
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)getWithUrl:(NSString *)url
              sign:(NSString *)signStr
        parameters:(NSDictionary *)parameter
           success:(void (^)(id))success
              fail:(void (^)(id))fail {
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if (signStr.length > 0) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager.requestSerializer setValue:[MyMD5 md5HexDigest:signStr] forHTTPHeaderField:@"sign"];
        [manager.requestSerializer setValue:[NSString setTS]  forHTTPHeaderField:@"ts"];
        [manager.requestSerializer setValue:MD5_UID forHTTPHeaderField:@"uid"];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    
    NSLog(@"===========%@",url);
    
    [manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIWindow *window = KeyWindow;
        [window makeToast:@"网络错误" duration:1 position:CSToastPositionCenter];
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        fail(error);
    }];
}

- (void)postWithUrl:(NSString *)url
               sign:(NSString *)signStr
         parameters:(NSDictionary *)parameter
            success:(void(^)(id successResponse))success
               fail:(void(^)(id failResponse))fail {
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (signStr.length > 0) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
        [manager.requestSerializer setValue:[MyMD5 md5HexDigest:signStr] forHTTPHeaderField:@"sign"];
        [manager.requestSerializer setValue:[NSString setTS]  forHTTPHeaderField:@"ts"];
        [manager.requestSerializer setValue:MD5_UID forHTTPHeaderField:@"uid"];
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIWindow *window = KeyWindow;
        [window makeToast:@"网络错误" duration:1 position:CSToastPositionCenter];
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        fail(error);
    }];

    
}

//post上传多张图片
- (void)uploadImgWithUrl:(NSString *)url
                  params:(NSDictionary *)params
            uploadImages:(NSArray *)images
                 success:(void (^)(id response))success
                 failure:(void (^)(AFHTTPRequestSerializer *operation,NSError *error))Error{
    
    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //////注意
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    
    
    NSMutableDictionary *dict = [params mutableCopy];
    
    NSURLSessionDataTask *task = [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        
        for (int i = 0; i < images.count; i ++) {
            UIImage *image = images[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"head.jpg" mimeType:@"image/jpeg"];
//            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"upload%d",i+1] fileName:@"head.jpg" mimeType:@"image/jpeg"];
        }
        
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//        NSDictionary *responseDict = (NSDictionary *)responseObject;
//        success(responseDict);
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(dictionary);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        Error(nil ,error);
    }];
    
    
    //开始启动任务
    [task resume];
}



@end

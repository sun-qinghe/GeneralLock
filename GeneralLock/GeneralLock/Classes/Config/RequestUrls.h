//
//  RequestUrl.h
//  MyBike
//
//  Created by sun on 2017/11/19.
//  Copyright © 2017年 sunxingxiang. All rights reserved.
//

#ifndef RequestUrl_h
#define RequestUrl_h

#define Tcp_Host @"42.123.125.181"
#define Tcp_Port 6802

#define BASE_URL                  @"http://42.123.125.181:8082/"
#define kRequestUrl(url)          [NSString stringWithFormat:@"%@%@", BASE_URL,url]

//获取验证码
#define URL_GetVerifyCode         @"api/sms/SendSmsMsg"
//登录
#define URL_Login                 @"api/accounts/CheckVerifyCode"
//获取设备信息
#define URL_GetLockInfo           @"api/locks/GetLockInfo"
//获取设备位置
#define URL_GetLockGpsInfo        @"api/GpsInfo/GetLockGpsInfo"
//获取设备状态
#define URL_GetLockStateInfo      @"api/locks/GetLockStateInfo"
//获取设备状态
#define URL_CheckUserAvailable    @"api/accounts/UserIsOk"
//获取个人信息
#define URL_GetUserInfo           @"api/appuser/GetAppUserInfo"


#endif /* RequestUrl_h */


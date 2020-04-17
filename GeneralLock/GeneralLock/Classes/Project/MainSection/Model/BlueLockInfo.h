//
//  BlueLockInfo.h
//  GeneralLock
//
//  Created by anzhong on 2019/10/23.
//  Copyright © 2019 anda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** --蓝牙锁 信息 -- */
@interface BlueLockInfo : NSObject

/** --密码 -- */
@property (nonatomic, strong) NSString *BluetoothKEY;
/** --密钥 -- */
@property (nonatomic, strong) NSString *BluetoothSecKEY;
/** --mac 地址 -- */
@property (nonatomic, strong) NSString *BluetoothMAC;
/** --锁 二维码号 -- */
@property (nonatomic, strong) NSString *QrCodeNum;
/** --锁类型 -- */
@property (nonatomic, strong) NSString *BluetoothProtocol;

@end

NS_ASSUME_NONNULL_END

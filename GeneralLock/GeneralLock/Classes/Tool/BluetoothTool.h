//
//  BluetoothTool.h
//  安达工厂
//
//  Created by anzhong on 2017/12/5.
//  Copyright © 2017年 anda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef enum : NSUInteger {
    /** --连接成功 -- */
    BluetoothStateConnected,
    /** --连接失败 -- */
    BluetoothStateDisconnect,
    /** --断开连接 -- */
    BluetoothStateOff,
    /** --蓝牙没开 -- */
    BluetoothStateClose
} BluetoothState;

@class BluetoothTool;
@protocol BluetoothToolDelegate <NSObject>

-(void)bluetoothTool:(BluetoothTool *)bluetool WithResult:(NSString *)result;
- (void)bluetoothToolState:(BluetoothState)state;

@end

@interface BluetoothTool : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

+(instancetype)sharedManager;

/** --外接设备的连接状态 -- */
@property (nonatomic, assign) BluetoothState connectState;
/** --锁类型 -- */
@property (nonatomic, strong) NSString *bluetoothType;
/** --密钥字符串 -- */
@property (nonatomic, strong) NSString *secretString;
/** --mac 地址 -- */
@property (nonatomic, strong) NSString *macAddress;
/** --密码 -- */
@property (nonatomic, strong) NSString *password;
/** --token -- */
@property (nonatomic, strong) NSString *token;

@property (nonatomic, weak) id<BluetoothToolDelegate> delegate;

/**
 读取信号量
 */
- (void)readRSSI:(CBPeripheral *)peripheral;


/**
 给锁发送指令

 @param instruce 16进制字符串
 */
- (void)sendInstruct:(NSString *)instruce;


/**
 断开连接
 */
- (void)cancelPeripheralConnect;

/**
 扫码蓝牙

 @param services services
 */
- (void)scanWithServices:(NSArray *)services;

@end

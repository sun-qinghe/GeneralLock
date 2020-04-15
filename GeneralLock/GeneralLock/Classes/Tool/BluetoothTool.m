//
//  BluetoothTool.m
//  安达工厂
//
//  Created by anzhong on 2017/12/5.
//  Copyright © 2017年 anda. All rights reserved.
//

#import "BluetoothTool.h"
#import "Encryption.h"

@interface BluetoothTool ()<CBCentralManagerDelegate,CBPeripheralDelegate>

/** --CBCentralManager:类表示中心设备，扫描发现周边蓝牙设备 -- */
@property (nonatomic, strong) CBCentralManager *centralManager;
/** --周边蓝牙设备用CBPeripheral类表示 -- */
@property (nonatomic, strong) CBPeripheral *aroundPeripheral;
/** -- 一个服务可以细分为多种特征，使用 CBCharacteristic 表示，比如心率监测服务中，含有心率的测量值、地理位置的定位等 Characteristic -- */
@property (nonatomic, strong) CBCharacteristic *characteristic;

@end

@implementation BluetoothTool

static BluetoothTool *_instance;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)scanWithServices:(NSArray *)services {
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    NSLog(@"000000000000000");
    if (services.count == 0) {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    } else {
        NSMutableArray *uuidServices = [[NSMutableArray alloc] init];
        for (int i = 0; i < services.count; i ++) {
            [uuidServices addObject:[CBUUID UUIDWithString:services[i]]];
        }
        [self.centralManager scanForPeripheralsWithServices:uuidServices options:nil];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
    });
}

- (void)stopScan {
    [self.centralManager stopScan];
}
- (void)connectToPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager connectPeripheral:peripheral options:nil];
//    self.peripheral = peripheral;
}
- (void)readRSSI:(CBPeripheral *)peripheral {
    [peripheral readRSSI];
}

//检查App的设备BLE是否可用
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (@available(iOS 10.0, *)) {
        if (central.state != CBManagerStatePoweredOn) {
            if ([self.delegate respondsToSelector:@selector(bluetoothToolState:)]) {
                [self.delegate bluetoothToolState:BluetoothStateClose];
                if ([kUserDefaults objectForKey:@"BLE_token"]) {
                    [kUserDefaults removeObjectForKey:@"BLE_token"];
                }
            }
            return;
        } else {
            [self scanWithServices:@[]];
        }
    } else {
        if (central.state != CBCentralManagerStatePoweredOn) {
            if ([self.delegate respondsToSelector:@selector(bluetoothToolState:)]) {
                [self.delegate bluetoothToolState:BluetoothStateClose];
                if ([kUserDefaults objectForKey:@"BLE_token"]) {
                    [kUserDefaults removeObjectForKey:@"BLE_token"];
                }
            }
            return;
        } else {
            [self scanWithServices:@[]];
        }
    }
}

// 执行 蓝牙 搜索 扫描的方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@">>>>>>>>>>%@",self.macAddress);
    if (advertisementData[@"kCBAdvDataManufacturerData"]) {
        NSString *manufacturerStr = [NSString stringWithFormat:@"%@",advertisementData[@"kCBAdvDataManufacturerData"]];
        manufacturerStr = [manufacturerStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
        manufacturerStr = [manufacturerStr stringByReplacingOccurrencesOfString:@">" withString:@""];
        manufacturerStr = [manufacturerStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSRange range = NSMakeRange(4, 12);
        manufacturerStr = [manufacturerStr substringWithRange:range];
        manufacturerStr = [manufacturerStr uppercaseString];
        NSString *macStr = [self.macAddress stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSLog(@">>>>>>>>>>%@",manufacturerStr);
        if ([manufacturerStr isEqualToString:macStr]) {
            self.aroundPeripheral = peripheral;
            [self stopScan];
            [self connectToPeripheral:peripheral];
            [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
            [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
                [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
            });
        }
    }
}

//连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral setDelegate:self];
    //连接服务 发现服务
    [peripheral discoverServices:nil];
    if ([self.delegate respondsToSelector:@selector(bluetoothToolState:)]) {
        [self.delegate bluetoothToolState:BluetoothStateConnected];
    }
}
//连接失败，就会得到回调：
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(bluetoothToolState:)]) {
        [self.delegate bluetoothToolState:BluetoothStateDisconnect];
        if ([kUserDefaults objectForKey:@"BLE_token"]) {
            [kUserDefaults removeObjectForKey:@"BLE_token"];
        }
    }
}

// 断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@">>>>>>>>>>断开连接");
    if ([self.delegate respondsToSelector:@selector(bluetoothToolState:)]) {
        [self.delegate bluetoothToolState:BluetoothStateOff];
        if ([kUserDefaults objectForKey:@"BLE_token"]) {
            [kUserDefaults removeObjectForKey:@"BLE_token"];
        }
        self.connectState = BluetoothStateDisconnect;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error NS_AVAILABLE(10_13, 8_0) {
    
}
//获取服务后 成功  的回调方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error){
        NSLog(@"didDiscoverServicesn内容是: %@", [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services) {
        // 发现 特征
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
//发现特征 后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    for (CBCharacteristic *stic in service.characteristics) {
        // 读取指令
        if ([stic.UUID.UUIDString containsString:@"36F6"]) {
            [peripheral setNotifyValue:YES forCharacteristic:stic];
            [peripheral readValueForCharacteristic:stic];
        }
        // 写入 发指令
        if ([stic.UUID.UUIDString containsString:@"36F5"]) {
            self.characteristic = stic;
            [self getTokenWithType:self.bluetoothType];
        }
    }
}

//订阅的特征值有新的数据时回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@",
              [error localizedDescription]);
    }
    [peripheral readValueForCharacteristic:characteristic];
}


#pragma mark ==== 写入数据之后，在需要回复的前提下会回调如下两个代理方法 ====
// 写入成功
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error writing characteristic value: %@", [error localizedDescription]);
        return;
    }
}

// 写入成功后的应答 回复
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"didUpdateValueForCharacteristic error : %@", error.localizedDescription);
        return;
    }
    NSData *data = [Encryption AES128ParmDecryptWithKey:self.secretString Decrypttext:characteristic.value];
    NSString *dataString = [NSString stringWithFormat:@"%@",data];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    dataString = [dataString stringByReplacingOccurrencesOfString:@">" withString:@""];
    dataString = [dataString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (dataString.length != 0) {
        if ([self.delegate respondsToSelector:@selector(bluetoothTool:WithResult:)]) {
            [self.delegate bluetoothTool:self WithResult:dataString.uppercaseString];
        }
    }
}

#pragma mark 写入数据
-(void)writeChar:(NSData *)data {
    NSLog(@">>>>>>>>>>%@",data);
    if (self.characteristic) {
        [self.aroundPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    } else {
        if ([self.delegate respondsToSelector:@selector(bluetoothToolState:)]) {
            [self.delegate bluetoothToolState:BluetoothStateClose];
        }
    }
}

- (void)sendInstruct:(NSString *)instruce {
    NSData *data = [NSData hexToBytesWithString:instruce];
    NSData *CecretData = [Encryption AES128ParmEncryptWithKey:self.secretString Encrypttext:data];
    [self writeChar:CecretData];
}

/** --获取token值 -- */
- (void)getTokenWithType:(NSString *)bluetoothType {
//    Byte byte[] = {0x06,0x01,0x01,0x30,0x30,0x30,0x30,0x30,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
//    NSData *data = [[NSData alloc] initWithBytes:byte length:16];
//    NSLog(@"%@", data);
    NSLog(@">>>>>>>>>>%@",bluetoothType);
    if ([bluetoothType isEqualToString:@"ECU"] || [NSObject object_isNullOrNilWithObject:bluetoothType] || [bluetoothType isEqualToString:@"&nbsp;"]) {
        NSString *wandStr = @"060101";
        NSString *passwordStr = [NSString convertStringToHexStr:self.password];
        NSString *instruct = [NSString stringWithFormat:@"%@%@%@", wandStr, passwordStr, @"00000000000000"];
        NSData *data = [NSData hexToBytesWithString:instruct];
        NSData *secretData = [Encryption AES128ParmEncryptWithKey:self.secretString Encrypttext:data];
        [self writeChar:secretData];
    } else if ([bluetoothType isEqualToString:@"HL"]) {
        NSString *wandStr = @"06010101";
        NSString *instruct = [NSString stringWithFormat:@"%@%@", wandStr, @"000000000000000000000000"];
        NSData *data = [NSData hexToBytesWithString:instruct];
        NSData *secretData = [Encryption AES128ParmEncryptWithKey:self.secretString Encrypttext:data];
        [self writeChar:secretData];
    }
}

- (void)cancelPeripheralConnect:(CBPeripheral *)peripheral {
    [self.centralManager cancelPeripheralConnection:peripheral];
}

- (void)cancelPeripheralConnect {
    [self cancelPeripheralConnect:self.aroundPeripheral];
}

@end

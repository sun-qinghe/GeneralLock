//
//  MSBLEController.m
//  GeneralLock
//
//  Created by 安中 on 2019/10/18.
//  Copyright © 2019 anda. All rights reserved.
//

#import "MSBLEController.h"
#import "BluetoothTool.h"
#import "InstructDataModel.h"
#import "BlueLockInfo.h"
#import "Encryption.h"
#import "MSLogController.h"
#import "LogModel.h"

@interface MSBLEController ()<BluetoothToolDelegate>

@property (nonatomic, strong) NSString *bluetoothType;
@property (nonatomic, strong) BluetoothTool *bluethTool;

@property (nonatomic, strong) NSString *lockToken;
@property (nonatomic, strong) NSString *lockPassword;

@property (nonatomic, strong) NSMutableArray *instructDataSourse;

@end

@implementation MSBLEController

//https://gitee.com/wlyq/bluetooth/raw/master/bluetooth-datasourse.json

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    [self setTableView];
    if ([kUserDefaults objectForKey:@"BLE_token"]) {
        self.lockToken = [kUserDefaults objectForKey:@"BLE_token"];
    }
    
//    self.bluethTool = [BluetoothTool sharedManager];
//    self.bluethTool.bluetoothType = blueLockInfo.BluetoothProtocol;
//    self.bluethTool.secretString = secretKye;
//    self.bluethTool.macAddress = macAddress;
//    self.bluethTool.password = self.lockPassword;
//    self.bluethTool.delegate = self;
    
    [self getLockInfo];
}

#pragma mark - 加载数据
-(void)loadDataWithType:(NSString *)bluetoothType{
    NSLog(@">>>>>>>>>>%@",bluetoothType);
    if ([bluetoothType isEqualToString:@"ECU"]) {
        [[NetTool sharedManager] getWithUrl:@"https://gitee.com/lucky_jonas/GeneralLock/raw/master/bluetooth-datasourse.json" sign:nil parameters:nil success:^(id successResponse) {
            self.dataSource = [InstructDataModel mj_objectArrayWithKeyValuesArray:successResponse];
            [self tableviewRefresh:YES];
        } fail:^(id failResponse) {
            NSLog(@">>>>>>>>>>%@",failResponse);
        }];
    } else if ([bluetoothType isEqualToString:@"HL"]) {
        //本地获取配置文件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BT-HL.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"%lu",(unsigned long)dataArray.count);
        self.dataSource = [InstructDataModel mj_objectArrayWithKeyValuesArray:dataArray];
        if (error) {
            NSLog(@"%@",error);
        }
        [self tableviewRefresh:YES];
    } else if ([bluetoothType isEqualToString:@"ECU2017"]) {
        //本地获取配置文件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BT-ECU2017.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"%lu",(unsigned long)dataArray.count);
        self.dataSource = [InstructDataModel mj_objectArrayWithKeyValuesArray:dataArray];
        if (error) {
            NSLog(@"%@",error);
        }
        [self tableviewRefresh:YES];
    } else if ([bluetoothType isEqualToString:@"ECU2018"]) {
        //本地获取配置文件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BT-ECU2018.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"%lu",(unsigned long)dataArray.count);
        self.dataSource = [InstructDataModel mj_objectArrayWithKeyValuesArray:dataArray];
        if (error) {
            NSLog(@"%@",error);
        }
        [self tableviewRefresh:YES];
    } else {
        //本地获取配置文件
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BT-AZ.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"%lu",(unsigned long)dataArray.count);
        self.dataSource = [InstructDataModel mj_objectArrayWithKeyValuesArray:dataArray];
        if (error) {
            NSLog(@"%@",error);
        }
        [self tableviewRefresh:YES];
    }
    
//    [[NetTool sharedManager] getWithUrl:@"https://gitee.com/lucky_jonas/GeneralLock/raw/master/bluetooth-datasourse.json" sign:nil parameters:nil success:^(id successResponse) {
//        self.dataSourse = [InstructDataModel mj_objectArrayWithKeyValuesArray:successResponse];
//        [self tableviewRefresh:YES];
//    } fail:^(id failResponse) {
//        NSLog(@">>>>>>>>>>%@",failResponse);
//    }];
}

#pragma mark - tableView
-(void)setTableView{
    self.tableView.backgroundColor = UIColorWithRGB(235, 235, 235);
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(@(-SafeBottom));
    }];
    [self addRefreshHeader:NO footer:NO];
    
    //设置分割线左边距
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110 *kScaleW;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30 *kScaleW;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    InstructDataModel *instruct = self.dataSource[section];
    return instruct.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    InstructDataModel *instruct = self.dataSource[indexPath.section];
    InstructModel *model = instruct.data[indexPath.row];
    cell.textLabel.text = [self.configuration.language isEqualToString:@"EN"] ? model.engTitle : model.title;
    cell.imageView.image = UIImageNamed(model.img);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InstructDataModel *instruct = self.dataSource[indexPath.section];
    InstructModel *model = instruct.data[indexPath.row];
    if (self.lockToken.length == 0) {
        if (self.bluethTool.connectState == BluetoothStateDisconnect) {
            [self checkLaguageWithENAction:^{
                [self reconnectBTWithTipTitle:@"warning" Message:@"bluetooth has disconnected,reconnect?" CancelTitle:@"Cancel" OKTitle:@"OK"];
            } CHAction:^{
                [self reconnectBTWithTipTitle:@"提示" Message:@"蓝牙连接已断开,是否重新连接" CancelTitle:@"取消" OKTitle:@"确定"];
            }];
        } else {
            [self showToastWithENToast:@"please wait for the bluetooth connection" CHToast:@"请确保蓝牙已开启,等待蓝牙连接成功"];
        }
    } else {
        NSString *wandStr = model.instruct;
        NSString *passwordStr = [NSString convertStringToHexStr:self.lockPassword];
        NSString *instruct = [NSString stringWithFormat:@"%@%@%@000000", wandStr, passwordStr, self.lockToken];
        if ([self.bluetoothType isEqualToString:@"HL"] && [model.title isEqualToString:@"锁车"]) {
            instruct = [NSString stringWithFormat:@"%@%@0000000000000000", wandStr, self.lockToken];
        }
        NSLog(@">>>>>>>>>>%@",instruct);
        [self.bluethTool sendInstruct:instruct];
        if ([wandStr isEqualToString:@"033101"]) {
            LogModel *model = [[LogModel alloc] init];
            model.CmdTime = @"";
            model.Cmd = @"重启GSM";
            [self.instructDataSourse addObject:model];
        } else if ([wandStr isEqualToString:@"033201"]) {
            LogModel *model = [[LogModel alloc] init];
            model.CmdTime = @"";
            model.Cmd = @"DFU升级BLE";
            [self.instructDataSourse addObject:model];
        }
        
        LogModel *model = [[LogModel alloc] init];
        NSString *timeStr = [SunDateTool getYYYYMMDDHHMMSSWithDate:[NSDate date]];
        NSLog(@">>>>>>>>>>%@",timeStr);
        model.CmdTime = [self.configuration.language isEqualToString:@"EN"] ? [NSString stringWithFormat:@"send time:%@",timeStr] : [NSString stringWithFormat:@"发送时间:%@",timeStr];
        model.Cmd = instruct;
        [self.instructDataSourse addObject:model];
    }
}

#pragma mark - 重新连接蓝牙提示
-(void)reconnectBTWithTipTitle:(NSString *)tipStr
                       Message:(NSString *)message
                   CancelTitle:(NSString *)cancelTitle
                       OKTitle:(NSString *)okTitle {
    [JXTAlertView showAlertViewWithTitle:tipStr message:message cancelButtonTitle:cancelTitle otherButtonTitle:okTitle cancelButtonBlock:^(NSInteger buttonIndex) {
    } otherButtonBlock:^(NSInteger buttonIndex) {
        [self.bluethTool scanWithServices:@[]];
    }];
}

- (void)bluetoothToolState:(BluetoothState)state {
    switch (state) {
        case BluetoothStateConnected:
            [self showToastWithENToast:@"bluetooth connected" CHToast:@"蓝牙连接成功"];
            break;
        case BluetoothStateDisconnect:
            [self showToastWithENToast:@"failed to connected" CHToast:@"连接失败"];
            break;
        case BluetoothStateOff:
            [self showToastWithENToast:@"bluetooth disconnected" CHToast:@"蓝牙连接断开"];
            self.lockToken = nil;
            break;
        case BluetoothStateClose:
            [self showToastWithENToast:@"please make sure bluetooth be opened" CHToast:@"请确保蓝牙打开"];
        default:
            break;
    }
}

- (void)bluetoothTool:(BluetoothTool *)bluetool WithResult:(NSString *)result {
    NSLog(@"返回resule：%@", result);
    LogModel *model = [[LogModel alloc] init];
    NSString *timeStr = [SunDateTool getYYYYMMDDHHMMSSWithDate:[NSDate date]];
    NSLog(@">>>>>>>>>>%@",timeStr);
    model.CmdTime = [self.configuration.language isEqualToString:@"EN"] ? [NSString stringWithFormat:@"reply time:%@",timeStr] : [NSString stringWithFormat:@"回复时间:%@",timeStr];
    model.Cmd = result;
    [self.instructDataSourse addObject:model];
    if ([self.bluetoothType isEqualToString:@"ECU"] || [NSObject object_isNullOrNilWithObject:self.bluetoothType]  || [self.bluetoothType isEqualToString:@"&nbsp;"]) {
        if ([result containsString:@"060204"]) {
            NSRange range = NSMakeRange(6, 8);
            self.lockToken = [result substringWithRange:range];
            NSLog(@">>>>>>>>>>%@",self.lockToken);
            [kUserDefaults setObject:self.lockToken forKey:@"BLE_token"];
        } else if ([result containsString:@"055201"]) {
            [self showToastWithENToast:@"revoke defense success" CHToast:@"撤防成功"];
        } else if ([result containsString:@"055401"]) {
            [self showToastWithENToast:@"setup defense success" CHToast:@"设防成功"];
        } else if ([result containsString:@"055601"]) {
            [self showToastWithENToast:@"ACC is ON" CHToast:@"ACC已开启"];
        } else if ([result containsString:@"055801"]) {
            [self showToastWithENToast:@"ACC is OFF" CHToast:@"ACC已关闭"];
        } else if ([result containsString:@"055A01"]) {
            [self showToastWithENToast:@"batterylock is opened" CHToast:@"电池锁已打开"];
        } else if ([result containsString:@"055C01"]) {
            [self showToastWithENToast:@"unlocked" CHToast:@"开锁成功"];
            [self.instructDataSourse addObject:model];
        } else if ([result containsString:@"055E01"]) {
            [self showToastWithENToast:@"locked" CHToast:@"关锁成功"];
        } else if ([result containsString:@"061101"]) {
            NSString *time = [self getTimeStrWithResult:result];
            [self showToastWithENToast:[NSString stringWithFormat:@"locked time: %@",time] CHToast:[NSString stringWithFormat:@"锁车时间: %@",time]];
        } else if ([result containsString:@"061201"]) {
            int level = [self getKeyCmdWithResult:result];
            [self showToastWithENToast:[NSString stringWithFormat:@"battery voltage: %d",level] CHToast:[NSString stringWithFormat:@"电池电压: %d",level]];
        } else if ([result containsString:@"061301"]) {
            NSString *imei = [self getIMEIOrICCIDStrWithResult:result];
            [self showToast:[NSString stringWithFormat:@"IMEI: %@",imei]];
        } else if ([result containsString:@"061401"]) {
            NSString *version = [self getVersionStrWithResult:result];
            [self showToast:[NSString stringWithFormat:@"version: %@",version]];
        } else if ([result containsString:@"061501"]) {
            NSString *rssiStr = [self getRSSIStrWithResult:result];
            [self showToast:[NSString stringWithFormat:@"RSSI: %@",rssiStr]];
        } else if ([result containsString:@"061601"]) {
            NSString *iccid = [self getIMEIOrICCIDStrWithResult:result];
            [self showToast:[NSString stringWithFormat:@"ICCID: %@",iccid]];
        }
    } else if ([self.bluetoothType isEqualToString:@"HL"]) {
        if ([result containsString:@"0602"]) {
            NSRange range = NSMakeRange(6, 8);
            self.lockToken = [result substringWithRange:range];
            [kUserDefaults setObject:self.lockToken forKey:@"BLE_token"];
        } else if ([result containsString:@"050201"]) {
            [self showToastWithENToast:@"unlocked" CHToast:@"开锁成功"];
            [self.instructDataSourse addObject:model];
        } else if ([result containsString:@"050801"]) {
            [self showToastWithENToast:@"locked" CHToast:@"关锁成功"];
        }
    }
}

#pragma mark - 从蓝牙返回指令里获取电压
-(int)getKeyCmdWithResult:(NSString *)result{
    NSString *keyStr = [self getKeyStrWithResult:result];
    int level = [self getIntegerByDecimal:keyStr];
    return level;
}

#pragma mark - 从蓝牙返回指令里获取时间
-(NSString *)getTimeStrWithResult:(NSString *)result{
    NSString *keyStr = [self getKeyStrWithResult:result];
    NSLog(@">>>>>>>>>>%@",keyStr);
    
    NSMutableArray *keywords = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        NSString *targetStr = [keyStr substringToIndex:2];
        NSString *unit = [NSString stringWithFormat:@"%d",[self getIntegerByDecimal:targetStr]];
        NSLog(@"unit>>>>>>>>>>%@",unit);
        [keywords addObject:unit];
        keyStr = [keyStr substringFromIndex:2];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",keywords[0],keywords[1],keywords[2],keywords[3],keywords[4],keywords[5]];
    NSLog(@"keyword>>>>>>>>>>%@",timeStr);
    return timeStr;
}

#pragma mark - 从蓝牙返回指令里获取设备版本
-(NSString *)getVersionStrWithResult:(NSString *)result{
    NSString *keyStr = [self getKeyStrWithResult:result];
    NSLog(@">>>>>>>>>>%@",keyStr);
    
    NSMutableArray *keywords = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        NSString *targetStr = [keyStr substringToIndex:2];
        NSString *unit = [NSString stringWithFormat:@"%d",[self getIntegerByDecimal:targetStr]];
        NSLog(@"unit>>>>>>>>>>%@",unit);
        [keywords addObject:unit];
        keyStr = [keyStr substringFromIndex:2];
    }
    NSString *versionStr = [NSString stringWithFormat:@"GSM: %@ %@ %@ %@ %@ %@, BLE: %@ %@ %@ %@ %@ %@",keywords[0],keywords[1],keywords[2],keywords[3],keywords[4],keywords[5],keywords[6],keywords[7],keywords[8],keywords[9],keywords[10],keywords[11]];
    NSLog(@"versionStr>>>>>>>>>>%@",versionStr);
    return versionStr;
}

#pragma mark - 从蓝牙返回指令里获取RSSI
-(NSString *)getRSSIStrWithResult:(NSString *)result{
    NSString *keyStr = [self getKeyStrWithResult:result];
    NSLog(@">>>>>>>>>>%@",keyStr);
    
    NSString *RSSIString = [NSString stringWithFormat:@"%d",[self getIntegerByDecimal:keyStr]];
    NSLog(@"RSSIString>>>>>>>>>>%@",RSSIString);
    return RSSIString;
}

#pragma mark - 从蓝牙返回指令里获取IMEI/ICCID
-(NSString *)getIMEIOrICCIDStrWithResult:(NSString *)result{
    NSString *keyStr = [self getKeyStrWithResult:result];
    NSLog(@"keyStr>>>>>>>>>>%@",keyStr);
    NSString *iccid = [self getTheCorrectNum:keyStr];
    NSLog(@"ICCID>>>>>>>>>>%@",iccid);
    return iccid;
}

#pragma mark - 从蓝牙返回指令里获取关键位
-(NSString *)getKeyStrWithResult:(NSString *)result{
    NSRange lengthRange = NSMakeRange(6, 2);
    NSString *lengthString = [result substringWithRange:lengthRange];
//    int length = lengthString.intValue;
    int length = [self getIntegerByDecimal:lengthString];
    
    NSRange range = NSMakeRange(8, 2 *length);
    NSString *string = [result substringWithRange:range];
    NSLog(@">>>>>>>>>>%@",string);
    return string;
}

#pragma mark - 十六进制转十进制数字
- (int)getIntegerByDecimal:(NSString *)decimal {
    NSString *temp10 = [NSString stringWithFormat:@"%lu",strtoul([decimal UTF8String],0,16)];
    NSLog(@"心跳数字 10进制 %@",temp10);
    //转成数字
    int cycleNumber = [temp10 intValue];
    NSLog(@"心跳数字 ：%d",cycleNumber);
    return cycleNumber;
}

#pragma mark - 去掉数字前面的0
-(NSString *)getTheCorrectNum:(NSString*)tempString{
    while ([tempString hasPrefix:@"0"]){
        tempString = [tempString substringFromIndex:1];
        NSLog(@"压缩之后的tempString:%@",tempString);
    }
    return tempString;
}

- (void)popSelf {
    [self.navigationController popViewControllerAnimated:YES];
    if ([kUserDefaults objectForKey:@"BLE_token"]) {
        [self.bluethTool cancelPeripheralConnect];
    }
}
-(void)rightBarButtonClick{
    MSLogController *vc = [[MSLogController alloc] init];
    vc.dataSource = self.instructDataSourse;
    [self pushViewController:vc animated:YES];
}
- (void)setNavigationItem {
    [self setRightBarButtonItemWithImage:UIImageNamed(@"消息")];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImageNamed(@"导航栏箭头") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
}

#pragma mark - 获取锁信息
-(void)getLockInfo{
    NSDictionary *parameters = @{@"deviceNo":self.deviceNo};
    [[NetTool sharedManager] getWithUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GetLockInfo] sign:nil parameters:parameters success:^(id successResponse) {
        if ([successResponse isSuccess]) {
            BlueLockInfo *blueLockInfo = [BlueLockInfo mj_objectWithKeyValues:successResponse[@"Data"][0]];
            NSString *keyIV = [[blueLockInfo.QrCodeNum stringByAppendingString:@"0000000000000000"] substringToIndex:16];
            NSString *macAddress = blueLockInfo.BluetoothMAC;
            NSLog(@">>>>>>>>>>%@",macAddress);
            NSString *decodePassword = [Encryption AES128Decrypt:blueLockInfo.BluetoothKEY Key:keyIV Iv:keyIV];
            NSString *decodeSecretKey = [Encryption AES128Decrypt:blueLockInfo.BluetoothSecKEY Key:keyIV Iv:keyIV];
            self.lockPassword = [decodePassword substringToIndex:6];
            NSLog(@">>>>>>>>>>%@",self.lockPassword);
            Byte bytes[16];
            NSArray *secretKeyArray = [decodeSecretKey componentsSeparatedByString:@","];
            if (secretKeyArray.count == 16) {
                for (int i = 0; i < 16; i++) {
                    NSString *str16 = [NSString getHexByDecimal:[secretKeyArray[i] integerValue]];
                    str16 = [@"0x" stringByAppendingString:str16];
                    const char *str16char = [str16 UTF8String];
                    Byte byte = (Byte)strtol(str16char, NULL, 16);
                    bytes[i] = byte;
                }
                NSData *data = [[NSData alloc] initWithBytes:bytes length:16];
                NSString *secretKye = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
//                self.bluethTool = [BluetoothTool sharedManager];
                self.bluethTool.bluetoothType = blueLockInfo.BluetoothProtocol;
                self.bluethTool.secretString = secretKye;
                self.bluethTool.macAddress = macAddress;
                self.bluethTool.password = self.lockPassword;
                self.bluethTool.delegate = self;
                [self.bluethTool scanWithServices:@[]];
            } else {
                [self checkLaguageWithENAction:^{
                    [self showToast:@"wrong bluetooth secret key❌"];
                } CHAction:^{
                    [self showToast:@"蓝牙锁密钥错误❌"];
                }];
            }
            
            self.bluetoothType = blueLockInfo.BluetoothProtocol;
            [self loadDataWithType:blueLockInfo.BluetoothProtocol];
        }
        
    } fail:^(id failResponse) {
        NSLog(@"%@", failResponse);
    }];
}

- (NSMutableArray *)instructDataSourse {
    if (!_instructDataSourse) {
        _instructDataSourse = [NSMutableArray array];
    }
    return _instructDataSourse;
}

-(BluetoothTool *)bluethTool{
    if (!_bluethTool) {
        _bluethTool = [BluetoothTool sharedManager];
    }
    return _bluethTool;
}

@end

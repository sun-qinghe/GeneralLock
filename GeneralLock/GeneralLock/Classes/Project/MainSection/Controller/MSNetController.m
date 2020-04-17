//
//  MSNetController.m
//  GeneralLock
//
//  Created by 安中 on 2019/10/18.
//  Copyright © 2019 anda. All rights reserved.
//

#import "MSNetController.h"
#import "MSTipController.h"
#import "MSCmdModel.h"
#import "MSParameterModel.h"
#import "MSLogController.h"
#import "LogModel.h"

@interface MSNetController ()

@property (nonatomic, strong) NSString *imeiStr;

//客户端socket
@property (nonatomic, strong) GCDAsyncSocket *clinetSocket;
//心跳线程
@property (nonatomic, strong) NSThread *thread;
//定时器
@property (nonatomic, strong) NSTimer *reconnectTimer;

@property (nonatomic, strong) NSMutableArray *logArray;

@end

@implementation MSNetController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"网络操作";
    [self setRightBarButtonItemWithImage:UIImageNamed(@"消息")];
    
    self.clinetSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self setTableView];
    [self getLockInfoWithDeviceNo:self.deviceNo];
}

#pragma mark - 指令日志入口
-(void)rightBarButtonClick{
    MSLogController *vc = [[MSLogController alloc] init];
    vc.dataSource = (NSMutableArray *)[[self.logArray reverseObjectEnumerator] allObjects];
    [self pushViewController:vc animated:YES];
}

#pragma mark - tableView
-(void)setTableView{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(StatusBarAndNavigationBarHeight));
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(@(-SafeBottom));
    }];
    [self addRefreshHeader:YES footer:NO];
    
    //设置分割线左边距
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110 *kScaleW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    MSCmdModel *cmdModel = self.dataSource[indexPath.row];
    cell.imageView.image = UIImageNamed(cmdModel.name);
    cell.textLabel.text = [self.configuration.language isEqualToString:@"EN"] ? cmdModel.en_name : cmdModel.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MSCmdModel *cmdModel = self.dataSource[indexPath.row];
    NSArray *paraArray = [MSParameterModel mj_objectArrayWithKeyValuesArray:cmdModel.parameters];
    if (paraArray.count == 0) {
//        [self makeSureToSendMessageWithCmd:cmdModel.cmd];
        [self checkLaguageWithENAction:^{
            [self makeSureToSendMessageWithCmd:cmdModel.cmd TipTitle:@"warning" Message:@"send the command?" CancelTitle:@"Cancel" OKTitle:@"OK"];
        } CHAction:^{
            [self makeSureToSendMessageWithCmd:cmdModel.cmd TipTitle:@"提示" Message:@"是否确定发送该指令" CancelTitle:@"取消" OKTitle:@"确定"];
        }];
    } else {
        MSParameterModel *paraModel = paraArray[0];
        NSArray *optionArray = paraModel.option;
        if (paraArray.count == 1) {
            if ([paraModel.type isEqualToString:@"select"]) {
                [self showSelectTipWithCmd:cmdModel.cmd Options:optionArray];
            } else if ([paraModel.type isEqualToString:@"single"]) {
                NSString *title1 = optionArray[0];
                NSString *title2 = optionArray[1];
                [self checkLaguageWithENAction:^{
                    [self showActionSheetWithCmd:cmdModel.cmd TipTitle:@"warning" Message:@"Please choose the option" CancelTitle:@"Cancel" Title1:title1 Title2:title2];
                } CHAction:^{
                    [self showActionSheetWithCmd:cmdModel.cmd TipTitle:@"提示" Message:@"请选择开关" CancelTitle:@"取消" Title1:title1 Title2:title2];
                }];
            } else {
                [self checkLaguageWithENAction:^{
                    [self showSingleInputTipWithCmd:cmdModel.cmd TipTitle:@"warning" Message:@"Please enter the following" CancelTitle:@"Cancel" OKTitle:@"OK" Placeholder:paraModel.en_name];
                } CHAction:^{
                    [self showSingleInputTipWithCmd:cmdModel.cmd TipTitle:@"提示" Message:@"请输入以下内容" CancelTitle:@"取消" OKTitle:@"确定" Placeholder:paraModel.name];
                }];
            }
        } else if (paraArray.count == 2) {
            NSMutableArray *placeholders = [NSMutableArray array];
            NSMutableArray *types = [NSMutableArray array];
            for (MSParameterModel *paraModel in paraArray) {
                [types addObject:paraModel.type];
            }
            
            if ([types containsObject:@"select"]) {
                [self showSelectAndInputTipWithCmd:cmdModel.cmd Options:optionArray];
            } else {
                [self checkLaguageWithENAction:^{
                    for (MSParameterModel *paraModel in paraArray) {
                        [placeholders addObject:paraModel.en_name];
                    }
                    [self showDoubleInputTipWithCmd:cmdModel.cmd TipTitle:@"warning" Message:@"Please enter the followings" CancelTitle:@"Cancel" OKTitle:@"OK" Placeholders:placeholders];
                } CHAction:^{
                    for (MSParameterModel *paraModel in paraArray) {
                        [placeholders addObject:paraModel.name];
                    }
                    [self showDoubleInputTipWithCmd:cmdModel.cmd TipTitle:@"提示" Message:@"请分别输入以下内容" CancelTitle:@"取消" OKTitle:@"确定" Placeholders:placeholders];
                }];
            }
        }
    }
}

#pragma mark - 获取指令数据
- (void)loadNewData{
    //网络获取配置文件
//    NSString *url = @"https://gitee.com/lucky_jonas/GeneralLock/raw/master/cmd.json";
//    [[NetTool sharedManager] getWithUrl:url sign:nil parameters:nil success:^(id successResponse) {
//        NSLog(@">>>>>>>>>>%@",successResponse);
//        self.dataSource = [MSCmdModel mj_objectArrayWithKeyValuesArray:successResponse];
//        [self tableviewRefresh:YES];
//    } fail:^(id failResponse) {
//        NSLog(@">>>>>>>>>>%@",failResponse);
//    }];

    
    //本地获取配置文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cmd.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSLog(@"%lu",(unsigned long)dataArray.count);
    self.dataSource = [MSCmdModel mj_objectArrayWithKeyValuesArray:dataArray];
    if (error) {
        NSLog(@"%@",error);
    }
    [self tableviewRefresh:YES];
}

#pragma mark - 弹出是否确定发送的提示
-(void)makeSureToSendMessageWithCmd:(NSString *)cmd
                           TipTitle:(NSString *)tipStr
                            Message:(NSString *)message
                        CancelTitle:(NSString *)cancelTitle
                            OKTitle:(NSString *)okTitle
{
    [JXTAlertView showAlertViewWithTitle:tipStr message:message cancelButtonTitle:cancelTitle otherButtonTitle:okTitle cancelButtonBlock:^(NSInteger buttonIndex) {
    } otherButtonBlock:^(NSInteger buttonIndex) {
        [self sendMessageWithCmd:cmd Parameters:nil];
    }];
}

#pragma mark - 选择提示框
-(void)showSelectTipWithCmd:(NSString *)cmd
                    Options:(NSArray *)options{
    MSTipController *tipVC = [[MSTipController alloc] init];
    tipVC.options = options;
    tipVC.commitAction = ^(id parameter) {
        NSArray *parameters = [NSArray arrayWithObject:parameter];
        [self sendMessageWithCmd:cmd Parameters:parameters];
    };
    self.definesPresentationContext = YES;
    tipVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:tipVC animated:NO completion:^{
        UIColor *color = [UIColor blackColor];
        tipVC.view.backgroundColor = [color colorWithAlphaComponent:0.7];
    }];
}

#pragma mark - 一个选择提示框 一个输入框
-(void)showSelectAndInputTipWithCmd:(NSString *)cmd
                    Options:(NSArray *)options{
    MSTipController *tipVC = [[MSTipController alloc] init];
    tipVC.options = options;
    tipVC.commitAction = ^(id parameter) {
        NSArray *parameters = [NSArray arrayWithObject:parameter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showSingleInputTipWithCmd:cmd TipTitle:@"提示" Message:@"请输入以下内容" CancelTitle:@"取消" OKTitle:@"确定" Placeholder:@"IP地址"];
        });
    };
    self.definesPresentationContext = YES;
    tipVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:tipVC animated:NO completion:^{
        UIColor *color = [UIColor blackColor];
        tipVC.view.backgroundColor = [color colorWithAlphaComponent:0.7];
    }];
}

#pragma mark - 一个输入选项的提示框
-(void)showSingleInputTipWithCmd:(NSString *)cmd
                        TipTitle:(NSString *)tipStr
                         Message:(NSString *)message
                     CancelTitle:(NSString *)cancelTitle
                         OKTitle:(NSString *)okTitle
                     Placeholder:(NSString *)placeholder{
    [self jxt_showAlertWithTitle:tipStr message:message appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionDestructiveTitle(cancelTitle).
        addActionDestructiveTitle(okTitle);
        
        [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholder;
        }];
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 0) {
        }
        else if (buttonIndex == 1) {
            UITextField *textField = alertSelf.textFields.firstObject;
            NSArray *parameters = [NSArray arrayWithObject:textField.text];
            [self sendMessageWithCmd:cmd Parameters:parameters];
        }
    }];
}

#pragma mark - 两个输入选项的提示框
-(void)showDoubleInputTipWithCmd:(NSString *)cmd
                        TipTitle:(NSString *)tipStr
                         Message:(NSString *)message
                     CancelTitle:(NSString *)cancelTitle
                         OKTitle:(NSString *)okTitle
                     Placeholders:(NSMutableArray *)placeholders{
    [self jxt_showAlertWithTitle:tipStr message:message appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionDestructiveTitle(cancelTitle).
        addActionDestructiveTitle(okTitle);
        
        [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholders[0];
        }];
        [alertMaker addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholders[1];
        }];
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 0) {
        }
        else if (buttonIndex == 1) {
            UITextField *textField1 = alertSelf.textFields.firstObject;
            UITextField *textField2 = alertSelf.textFields.lastObject;
            NSArray *parameters = [NSArray arrayWithObjects:textField1.text, textField2.text, nil];
            [self sendMessageWithCmd:cmd Parameters:parameters];
        }
    }];
}

#pragma mark - ActionSheet
-(void)showActionSheetWithCmd:(NSString *)cmd
                     TipTitle:(NSString *)tipStr
                      Message:(NSString *)message
                  CancelTitle:(NSString *)cancelTitle
                       Title1:(NSString *)title1
                       Title2:(NSString *)title2{
    [self jxt_showActionSheetWithTitle:tipStr message:message appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionCancelTitle(cancelTitle).
        addActionDestructiveTitle(title1).
        addActionDefaultTitle(title2);
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if ([action.title isEqualToString:cancelTitle]) {
        }
        else if ([action.title isEqualToString:title1]) {
            NSInteger index = buttonIndex - 1;
            NSArray *parameters = [NSArray arrayWithObject:[NSString stringWithFormat:@"%ld",(long)index]];
            [self sendMessageWithCmd:cmd Parameters:parameters];
        }
        else if ([action.title isEqualToString:title2]) {
            NSInteger index = buttonIndex - 1;
            NSArray *parameters = [NSArray arrayWithObject:[NSString stringWithFormat:@"%ld",(long)index]];
            [self sendMessageWithCmd:cmd Parameters:parameters];
        }
    }];
}

#pragma mark - 发送指令
-(void)sendMessageWithCmd:(NSString *)cmd
               Parameters:(NSArray *)parameterArray
{
    NSString *dataString;
    if (parameterArray.count == 0) {
        dataString = [NSString stringWithFormat:@"@@%@,%@,123,%@&&",self.imeiStr, cmd, self.user.userId];
    } else if (parameterArray.count == 1) {
        NSString *paraStr = [NSString stringWithFormat:@"%@",parameterArray[0]];
        dataString = [NSString stringWithFormat:@"@@%@,%@,%@,123,%@&&",self.imeiStr, cmd, paraStr, self.user.userId];
    } else {
        NSString *paraStr1 = [NSString stringWithFormat:@"%@",parameterArray[0]];
        NSString *paraStr2 = [NSString stringWithFormat:@"%@",parameterArray[1]];
        dataString = [NSString stringWithFormat:@"@@%@,%@,%@,%@,123,%@&&",self.imeiStr, cmd, paraStr1, paraStr2, self.user.userId];
    }
    NSLog(@">>>>>>>>>>%@",dataString);
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [self.clinetSocket writeData:data withTimeout:-1 tag:0];
}

#pragma mark - 获取设备信息
-(void)getLockInfoWithDeviceNo:(NSString *)deviceNo{
    NSDictionary *parameters = @{@"deviceNo":deviceNo};
    [[NetTool sharedManager] getWithUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GetLockInfo] sign:nil parameters:parameters success:^(id successResponse) {
        if ([successResponse isSuccess]) {
            self.imeiStr = successResponse[@"Data"][0][@"EquipmentNo"];
            [self connectSocket];
        }
    } fail:^(id failResponse) {
        NSLog(@"失败");
    }];
}


#pragma mark - 开始连接 socket
-(void)connectSocket{
    [self.clinetSocket connectToHost:Tcp_Host onPort:Tcp_Port withTimeout:-1 error:nil];
}

#pragma mark -  GCDAsyncSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"链接socket服务器成功！");
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
    [self heartBeat];
    //开启线程发送心跳
    [self.thread start];
}

- (void)threadStart{
    @autoreleasepool {
        _reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)heartBeat{
    NSData *data = [[NSString stringWithFormat:@"@@%@,S000,123,%@&&",self.imeiStr,self.user.userId] dataUsingEncoding:NSUTF8StringEncoding];
    [self.clinetSocket writeData:data withTimeout:-1 tag:0];
}

- (NSThread*)thread{
    if (!_thread) {
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadStart) object:nil];
    }
    return _thread;
}


//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *sumText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"=====Socket接收到消息是:%@", sumText);
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
    if ([sumText containsString:@"【"] && [sumText containsString:@"】"]) {
        NSRange startRange = [sumText rangeOfString:@"【"];
        NSRange endRange = [sumText rangeOfString:@"】"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [sumText substringWithRange:range];
        [self showToast:result];
        
        //添加到数组
        NSArray *sumArray = [sumText componentsSeparatedByString:@"&&"];
        NSString *cmdStr = sumArray[0];
        NSString *timeStr = [SunDateTool getYYYYMMDDHHMMSSWithDate:[NSDate date]];
        NSLog(@">>>>>>>>>>%@",timeStr);
        LogModel *logModel = [[LogModel alloc] init];
        logModel.CmdTime = timeStr;
        logModel.Cmd = cmdStr;
        [self.logArray addObject:logModel];
    }
}


-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"断开连接 %@",err);
    [_thread cancel];
    _thread = nil;
    [_reconnectTimer invalidate];
    
    //可以再次重连
    if (err) {
        NSLog(@"非正常断开");
        [self.clinetSocket connectToHost:Tcp_Host onPort:Tcp_Port error:nil];
    }else{
        //正常断开
        NSLog(@"断开链接成功");
    }
}

-(void)disconnectSocket{
    [self.clinetSocket disconnect];
}

-(NSMutableArray *)logArray{
    if (!_logArray) {
        _logArray = [NSMutableArray array];
    }
    return _logArray;
}

@end

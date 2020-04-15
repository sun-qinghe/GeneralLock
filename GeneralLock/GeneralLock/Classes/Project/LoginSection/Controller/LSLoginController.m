//
//  LSLoginController.m
//  GeneralLock
//
//  Created by 安中 on 2019/10/16.
//  Copyright © 2019 anda. All rights reserved.
//

#import "LSLoginController.h"

@interface LSLoginController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, assign) int seconds;
@property (nonatomic, strong) NSTimer *countDownTimer;

@end

@implementation LSLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    [self setupUI];
}

#pragma mark - 设置UI
-(void)setupUI{
    UILabel *label = [[UILabel alloc] init];
    label.font = UIBoldFont(25);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(260 *kScaleW));
        make.centerX.equalTo(self.view);
    }];
    
    UITextField *accountTF = [[UITextField alloc] init];
    self.accountTF = accountTF;
    accountTF.delegate = self;
    accountTF.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:accountTF];
    [accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(60 *kScaleW);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(620 *kScaleW));
        make.height.equalTo(@(90 *kScaleW));
    }];
    
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeBtn = codeBtn;
//    codeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [codeBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(getVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(accountTF);
        make.right.equalTo(accountTF);
//        make.width.equalTo(@(200 *kScaleW));
        make.height.equalTo(@(60 *kScaleW));
    }];
    
    UITextField *passwordTF = [[UITextField alloc] init];
    self.passwordTF = passwordTF;
    passwordTF.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:passwordTF];
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountTF.mas_bottom).offset(30 *kScaleW);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(620 *kScaleW));
        make.height.equalTo(@(90 *kScaleW));
    }];
    
    for (int i = 0; i < 2; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = GrayLine;
        [self.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(accountTF.mas_bottom).offset((120 *i) *kScaleW);
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(620 *kScaleW));
            make.height.equalTo(@1);
        }];
    }
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn = loginBtn;
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordTF.mas_bottom).offset(110 *kScaleW);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(638 *kScaleW));
        make.height.equalTo(@(86 *kScaleW));
    }];
    
    [self checkLaguageWithENAction:^{
        label.text = @"Login";
        accountTF.placeholder = @"MobilePhone";
        [codeBtn setTitle:@"Send Code" forState:UIControlStateNormal];
        passwordTF.placeholder = @"Enter Code";
        [loginBtn setImage:UIImageNamed(@"login") forState:UIControlStateNormal];
    } CHAction:^{
        label.text = @"手机快捷登录/注册";
        accountTF.placeholder = @"手机号";
        [codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        passwordTF.placeholder = @"请输入验证码";
        [loginBtn setImage:UIImageNamed(@"进入锁具测试") forState:UIControlStateNormal];
    }];
}

#pragma mark - 获取验证码
-(void)getVerifyCode:(UIButton *)sender{
    if ([NSObject object_isNullOrNilWithObject:self.accountTF.text]) {
        [self checkLaguageWithENAction:^{
            jxt_showAlertTitle(@"Please enter mobile number");
        } CHAction:^{
            jxt_showAlertTitle(@"请输入手机号码");
        }];
    } else {
        NSDictionary *parameters = @{@"smssenduser":self.accountTF.text,
                                     @"smstype":@"1"
                                     };
        [[NetTool sharedManager] postWithUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GetVerifyCode] sign:nil parameters:parameters success:^(id successResponse) {
            NSString *message = [NSString stringWithFormat:@"%@",successResponse[@"Message"]];
            NSLog(@">>>>>>>>>>%@",message);
            if ([successResponse isSuccess]) {
                [self countDownAction];
            } else {
                jxt_showAlertTitle(message);
            }
            
        } fail:^(id failResponse) {
            NSLog(@"失败");
        }];
    }
}

#pragma mark - 倒计时
-(void)countDownAction{
    self.seconds = 60;//60秒倒计时
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

-(void)timeFireMethod{
    self.seconds--;
    if(self.seconds == 0){
        [self.countDownTimer invalidate];
        [self checkLaguageWithENAction:^{
            [self.codeBtn setTitle:@"Send Code" forState:UIControlStateNormal];
        } CHAction:^{
            [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }];
        [self.codeBtn setTitleColor:UIColorBlack forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = YES;
    } else {
        [self checkLaguageWithENAction:^{
            [self.codeBtn setTitle:[NSString stringWithFormat:@"Resend code(%.2ds)", self.seconds] forState:UIControlStateNormal];
        } CHAction:^{
            [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2ds)", self.seconds] forState:UIControlStateNormal];
        }];
        [self.codeBtn setTitleColor:GrayText forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - 登录
-(void)loginAction:(UIButton *)sender{
    NSDictionary *parameters = @{@"MobileTel":self.accountTF.text,
                                 @"Verifycode":self.passwordTF.text,
                                 @"SmsType":@"1",
                                 @"IsChangeMobile":@"0"
                                 };
    [[NetTool sharedManager] getWithUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_Login] sign:nil parameters:parameters success:^(id successResponse) {
        NSString *message = [NSString stringWithFormat:@"%@",successResponse[@"Message"]];
        NSLog(@">>>>>>>>>>%@",message);
        if ([successResponse isSuccess]) {
            User *user = [[User alloc] init];
            user.userId = self.accountTF.text;
            self.user = user;
            [self popViewController:YES];
        } else {
            jxt_showAlertTitle(message);
        }
        
    } fail:^(id failResponse) {
        NSLog(@"失败");
    }];
}

@end

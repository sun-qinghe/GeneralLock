//
//  MSMainController.m
//  GeneralLock
//
//  Created by 安中 on 2019/10/17.
//  Copyright © 2019 anda. All rights reserved.
//

#import "MSMainController.h"
#import "MSNetController.h"
#import "MSBLEController.h"
#import "LSLoginController.h"
#import "SWQRCode.h"
#import "BikeModel.h"
#import "BikeAnnotation.h"
#import "BikeAnnotationView.h"
#import "MSStatusController.h"

@interface MSMainController ()<MAMapViewDelegate,AMapLocationManagerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *deviceTF;
@property (nonatomic, strong) UIButton *netBtn;
@property (nonatomic, strong) UIButton *bleBtn;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
/** -- 设备数据 -- */
//@property (nonatomic, strong) NSMutableArray *deviceAnnotations;

@end

@implementation MSMainController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    if (self.user.userId) {
        [self setLeftBarButtonItemWithImage:UIImageNamed(@"logout")];
    }
//    [self getLockGpsInfoWithDeviceNo:@"860344045735447"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkLaguageWithENAction:^{
        self.title = @"GeneralLockTest";
        [self setRightBarButtonItemWithTitle:@"中" TitleColor:UIColorWhite];
    } CHAction:^{
        self.title = @"通用工厂测试";
        [self setRightBarButtonItemWithTitle:@"EN" TitleColor:UIColorWhite];
    }];
    
    [self initMapView];
    [self setupUI];
}

#pragma mark - 点击左按钮,退出登录
-(void)leftBarButtonClick{
    static NSString *tipStr;
    static NSString *message;
    static NSString *cancelTitle;
    static NSString *okTitle;
    
    [self checkLaguageWithENAction:^{
        tipStr = @"warning";
        message = @"sure to logout?";
        cancelTitle = @"Cancel";
        okTitle = @"OK";
    } CHAction:^{
        tipStr = @"提示";
        message = @"确定退出登录吗?";
        cancelTitle = @"取消";
        okTitle = @"确定";
    }];
    
    [JXTAlertView showAlertViewWithTitle:tipStr message:message cancelButtonTitle:cancelTitle otherButtonTitle:okTitle cancelButtonBlock:^(NSInteger buttonIndex) {
        NSLog(@"cancel");
    } otherButtonBlock:^(NSInteger buttonIndex) {
        kUserDefaultRemoveObjectForKey(@"userInfo")
        NSLog(@"退出成功");
        self.navigationItem.leftBarButtonItem = nil;
        LSLoginController *vc = [[LSLoginController alloc] init];
        [self pushViewController:vc animated:YES];
    }];
}

#pragma mark - 点击右按钮
-(void)rightBarButtonClick{
    Configuration *configuration = [[Configuration alloc] init];
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"中"]) {
        self.navigationItem.rightBarButtonItem.title = @"EN";
        self.title = @"通用工厂测试";
        configuration.language = @"中";
        self.deviceTF.placeholder = @"  设备编号";
        [self.netBtn setTitle:@"网络操作" forState:UIControlStateNormal];
        [self.bleBtn setTitle:@"蓝牙操作" forState:UIControlStateNormal];
    } else if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"EN"]) {
        self.navigationItem.rightBarButtonItem.title = @"中";
        self.title = @"GeneralLockTest";
        configuration.language = @"EN";
        self.deviceTF.placeholder = @"  Enter device number";
        [self.netBtn setTitle:@"NetOperation" forState:UIControlStateNormal];
        [self.bleBtn setTitle:@"BTOperation" forState:UIControlStateNormal];
    }
    self.configuration = configuration;
}

#pragma mark --设置地图
-(void)initMapView {
    if (self.mapView == nil) {
        MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        self.mapView = mapView;
        mapView.delegate = self;
        mapView.distanceFilter = 300.f;
        [self.view addSubview:mapView];
        
        mapView.showsUserLocation = YES;
        mapView.showsCompass = NO;
        mapView.showsScale = NO;
        mapView.userTrackingMode = MAUserTrackingModeFollow;
        [mapView setZoomLevel:15 atPivot:mapView.center animated:YES];
        
//        UIImageView *centerIcon = [[UIImageView alloc] init];
//        centerIcon.image = UIImageNamed(@"中心");
//        [self.view addSubview:centerIcon];
//        [centerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.view);
//            make.width.equalTo(@(42 *kScaleW));
//            make.height.equalTo(@(93 *kScaleW));
//        }];
    }
}

#pragma mark - 首页控件
-(void)setupUI{
    UITextField *deviceTF = [[UITextField alloc] init];
    self.deviceTF = deviceTF;
    deviceTF.backgroundColor = UIColorWhite;
    deviceTF.layer.borderColor = GrayLine.CGColor;
    deviceTF.layer.cornerRadius = 10 *kScaleW;
    [self setShadowToTargetView:deviceTF];
    deviceTF.delegate = self;
//    deviceTF.text = @"860344045735447";
//    deviceTF.text = @"008210180";
    deviceTF.text = @"020030001";
    deviceTF.keyboardType = UIKeyboardTypeWebSearch;
    [self.view addSubview:deviceTF];
    [deviceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(30 *kScaleW));
        make.left.equalTo(@(50 *kScaleW));
        make.width.equalTo(@(520 *kScaleW));
        make.height.equalTo(@(90 *kScaleW));
    }];
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setImage:UIImageNamed(@"首页扫码") forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-30 *kScaleW);
        make.width.height.equalTo(@(106 *kScaleW));
        make.centerY.equalTo(deviceTF);
    }];
    
    UIButton *netBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.netBtn = netBtn;
    netBtn.backgroundColor = UIColorWithRGB(0, 190, 255);
    netBtn.layer.cornerRadius = 15 *kScaleW;
    [self setShadowToTargetView:netBtn];
//    [netBtn setTitle:@"网络操作" forState:UIControlStateNormal];
    [netBtn addTarget:self action:@selector(netAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:netBtn];
    [netBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(40 *kScaleW));
        make.bottom.equalTo(self.view).offset(-(80 *kScaleW + SafeBottom));
        make.width.equalTo(@(310 *kScaleW));
        make.height.equalTo(@(90 *kScaleW));
    }];
    
    UIButton *bleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bleBtn = bleBtn;
    bleBtn.backgroundColor = UIColorWithRGB(0, 47, 84);
    bleBtn.layer.cornerRadius = 15 *kScaleW;
    [self setShadowToTargetView:bleBtn];
//    [bleBtn setTitle:@"蓝牙操作" forState:UIControlStateNormal];
    [bleBtn addTarget:self action:@selector(bleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bleBtn];
    [bleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(netBtn);
        make.right.equalTo(self.view).offset(-40 *kScaleW);
        make.width.equalTo(@(310 *kScaleW));
        make.height.equalTo(@(90 *kScaleW));
    }];
    
    UIButton *locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locBtn setImage:UIImageNamed(@"定位") forState:UIControlStateNormal];
    [locBtn addTarget:self action:@selector(locAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locBtn];
    [locBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bleBtn.mas_top).offset(- 40 *kScaleW);
        make.right.equalTo(self.view).offset(- 40 *kScaleW);
        make.width.height.equalTo(@(138 *kScaleW));
    }];
    
    [self checkLaguageWithENAction:^{
        deviceTF.placeholder = @"  Enter device number";
        [netBtn setTitle:@"NetOperation" forState:UIControlStateNormal];
        [bleBtn setTitle:@"BTOperation" forState:UIControlStateNormal];
    } CHAction:^{
        deviceTF.placeholder = @"  设备编号";
        [netBtn setTitle:@"网络操作" forState:UIControlStateNormal];
        [bleBtn setTitle:@"蓝牙操作" forState:UIControlStateNormal];
    }];
}

#pragma mark - 输入完成点击确定
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self getLockGpsInfoWithDeviceNo:textField.text];
    return YES;
}

#pragma mark - 扫码操作
-(void)scanAction:(UIButton *)sender{
    SWQRCodeConfig *config = [[SWQRCodeConfig alloc]init];
    config.scannerType = SWScannerTypeBoth;
    
    SWQRCodeViewController *qrcodeVC = [[SWQRCodeViewController alloc]init];
    qrcodeVC.codeConfig = config;
    [qrcodeVC.sendResult subscribeNext:^(id  _Nullable x) {
        NSString *deviceNo = [NSString stringWithFormat:@"%@",x];
        NSLog(@"%@",deviceNo);
        if ([deviceNo containsString:@"="]) {
            NSRange range = [deviceNo rangeOfString:@"="]; //现获取要截取的字符串位置
            deviceNo = [deviceNo substringFromIndex:range.location + 1]; //截取字符串
        }
        self.deviceTF.text = deviceNo;
        [self getLockGpsInfoWithDeviceNo:deviceNo];
    }];
    [self pushViewController:qrcodeVC animated:YES];
}

#pragma mark - 扫码/输入之后获取锁的位置信息
-(void)getLockGpsInfoWithDeviceNo:(NSString *)deviceNo{
    NSLog(@">>>>>>>>>>%@",deviceNo);
    NSDictionary *parameters = @{@"DeviceNo":deviceNo};
    [[NetTool sharedManager] getWithUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_GetLockGpsInfo] sign:nil parameters:parameters success:^(id successResponse) {
        if ([successResponse isSuccess]) {
            NSDictionary *dic = successResponse[@"Data"][0];
            BikeModel *bikeModel = [BikeModel mj_objectWithKeyValues:dic];
            BikeAnnotation *bikeAnnotation = [[BikeAnnotation alloc] init];
            bikeAnnotation.coordinate = CLLocationCoordinate2DMake(bikeModel.Latitude, bikeModel.Longitude);
            [self.mapView addAnnotation:bikeAnnotation];
            [self.mapView setCenterCoordinate:bikeAnnotation.coordinate];
        }
    } fail:^(id failResponse) {
        NSLog(@"失败");
    }];
}

#pragma mark - 检测用户是否可用
-(void)checkUserAvailableWithUserId:(NSString *)userId
                          Available:(void(^)(void))availableAction
{
    NSDictionary *parameters = @{@"UserName":userId};
    [[NetTool sharedManager] getWithUrl:[NSString stringWithFormat:@"%@%@",BASE_URL,URL_CheckUserAvailable] sign:nil parameters:parameters success:^(id successResponse) {
        NSString *message = [NSString stringWithFormat:@"%@",successResponse[@"Message"]];
        if ([successResponse isSuccess]) {
            if (availableAction) {
                availableAction();
            }
        } else {
            [self showToast:message];
        }
    } fail:^(id failResponse) {
        NSLog(@"失败");
    }];
}

#pragma mark - 网络操作点击事件
-(void)netAction:(UIButton *)sender{
    if ([NSObject object_isNullOrNilWithObject:self.user.userId]) {
        LSLoginController *vc = [[LSLoginController alloc] init];
        [self pushViewController:vc animated:YES];
    } else {
        [self checkUserAvailableWithUserId:self.user.userId Available:^{
            if ([NSObject object_isNullOrNilWithObject:self.deviceTF.text]) {
                jxt_showAlertTitle(@"请扫码或手动输入设备号");
            } else {
                MSNetController *vc = [[MSNetController alloc] init];
                vc.deviceNo = self.deviceTF.text;
                vc.title = self.deviceTF.text;
                [self pushViewController:vc animated:YES];
            }
        }];
    }
}

#pragma mark - 蓝牙操作点击事件
-(void)bleAction:(UIButton *)sender{
    if ([NSObject object_isNullOrNilWithObject:self.user.userId]) {
        LSLoginController *vc = [[LSLoginController alloc] init];
        [self pushViewController:vc animated:YES];
    } else {
        [self checkUserAvailableWithUserId:self.user.userId Available:^{
            if ([NSObject object_isNullOrNilWithObject:self.deviceTF.text]) {
                jxt_showAlertTitle(@"请扫码或手动输入设备号");
            } else {
                MSBLEController *vc = [[MSBLEController alloc] init];
                vc.deviceNo = self.deviceTF.text;
                vc.title = self.deviceTF.text;
                [self pushViewController:vc animated:YES];
            }
        }];
    }
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    if (updatingLocation){
        NSLog(@"userlocation :%@", userLocation.location);
        
        User *user = self.user;
        user.Lat = userLocation.location.coordinate.latitude;
        user.Lon = userLocation.location.coordinate.longitude;
        self.user = user;
    }
}

- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}

#pragma mark - 地图移动后执行的方法
-(void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
    
}

#pragma mark - 定位
-(void)locAction:(UIButton *)sender{
    self.mapView.showsUserLocation = YES;
    self.mapView.centerCoordinate = self.mapView.userLocation.coordinate;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

#pragma mark - 添加大头针
-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
}

#pragma mark - 加载大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[BikeAnnotation class]]){
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BikeAnnotationView *annotationView = (BikeAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BikeAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = UIImageNamed(@"车标");
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}

#pragma mark - 点击大头针
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if ([view isKindOfClass:[BikeAnnotationView class]]) {
        MSStatusController *vc = [[MSStatusController alloc] init];
        vc.deviceNo = self.deviceTF.text;
        [self pushViewController:vc animated:YES];
        [mapView deselectAnnotation:view.annotation animated:YES];
    }
}


//-(NSMutableArray *)deviceAnnotations{
//    if (!_deviceAnnotations) {
//        _deviceAnnotations = [NSMutableArray array];
//    }
//    return _deviceAnnotations;
//}

@end

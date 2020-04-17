//
//  BasicViewController.m
//  飞鸽运维
//
//  Created by anzhong on 2018/6/5.
//  Copyright © 2018年 anda. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)showToast:(NSString *)toast {
    [self.view makeToast:toast duration:2 position:CSToastPositionCenter];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.navigationController.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:viewController animated:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    ///这里设置白色
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)setLeftBarButtonItemWithTitle:(NSString *)title
                           TitleColor:(UIColor *)titleColor{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonClick)];
    [leftBarItem setTitleTextAttributes:@{NSFontAttributeName:UISystemFont(16), NSForegroundColorAttributeName:titleColor} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)setLeftBarButtonItemWithImage:(UIImage *)image{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonClick)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)setRightBarButtonItemWithTitle:(NSString *)title
                            TitleColor:(UIColor *)titleColor
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick)];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName:UISystemFont(16), NSForegroundColorAttributeName:titleColor} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)setRightBarButtonItemWithImage:(UIImage *)image{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)rightBarButtonClick{
    
}

-(void)upLoadLocationWithUserId:(NSString *)userId
                      Longitude:(float)longitude
                       Latitude:(float)latitude
{
    [[NetTool sharedManager] getWithUrl:[NSString stringWithFormat:@"%@/api/PerationMaintenance/UpLoadWorkPath?JobNumber=%@&Lon=%f&Lat=%f",BASE_URL,userId,longitude,latitude] sign:nil parameters:nil success:^(id successResponse) {
        
    } fail:^(id failResponse) {
        
    }];
}

-(NSString *)getStringFromObject:(id)object{
    if ([NSObject object_isNullOrNilWithObject:object]) {
        return @"";
    } else {
        return object;
    }
}

- (void)popViewController:(BOOL)animated {
    [self.navigationController popViewControllerAnimated:animated];
}

#pragma mark - 设置阴影
-(void)setShadowToTargetView:(UIView *)targetView{
    targetView.layer.shadowColor = UIColorFromRGB(0x999999).CGColor;
    targetView.layer.shadowOffset = CGSizeMake(0, 0);
    targetView.layer.shadowOpacity = 1;
    targetView.layer.shadowRadius = 5 *kScaleW;
}

//弹出提示框
-(void)showAlertWithMessage:(NSString *)message{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction*otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action) {
        
    }];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)checkLaguageWithENAction:(void (^)(void))ENAction CHAction:(void (^)(void))CHAction{
    if ([self.configuration.language isEqualToString:@"EN"]) {
        if (ENAction) {
            ENAction();
        }
    } else {
        if (CHAction) {
            CHAction();
        }
    }
}

- (void)showToastWithENToast:(NSString *)enToast CHToast:(NSString *)chToast{
    if ([self.configuration.language isEqualToString:@"EN"]) {
        [self.view makeToast:enToast duration:2 position:CSToastPositionCenter];
    } else {
        [self.view makeToast:chToast duration:2 position:CSToastPositionCenter];
    }
}

- (User *)user {
    return [User mj_objectWithKeyValues:kUserDefaultObjectForKey(@"userInfo")];
}
- (void)setUser:(User *)user {
    NSDictionary *dic = [user mj_keyValues];
    kUserDefaultSetObjectForKey(dic, @"userInfo");
}

-(Configuration *)configuration{
    return [Configuration mj_objectWithKeyValues:kUserDefaultObjectForKey(@"configuration")];
}

-(void)setConfiguration:(Configuration *)configuration{
    NSDictionary *dic = [configuration mj_keyValues];
    kUserDefaultSetObjectForKey(dic, @"configuration");
}

@end

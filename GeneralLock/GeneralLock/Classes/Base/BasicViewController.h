//
//  BasicViewController.h
//  飞鸽运维
//
//  Created by anzhong on 2018/6/5.
//  Copyright © 2018年 anda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Configuration.h"

@interface BasicViewController : UIViewController

/** -- 用户User对象 -- */
@property (nonatomic, strong) User *user;
/** -- configuration对象 -- */
@property (nonatomic, strong) Configuration *configuration;


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)popViewController:(BOOL)animated;

- (void)showToast:(NSString *)toast;

- (void)setLeftBarButtonItemWithTitle:(NSString *)title
                            TitleColor:(UIColor *)titleColor;

- (void)setRightBarButtonItemWithTitle:(NSString *)title
                            TitleColor:(UIColor *)titleColor;

- (void)setLeftBarButtonItemWithImage:(UIImage *)image;

- (void)setRightBarButtonItemWithImage:(UIImage *)image;

- (void)leftBarButtonClick;

- (void)rightBarButtonClick;

#pragma mark - 上传位置
-(void)upLoadLocationWithUserId:(NSString *)userId
                      Longitude:(float)longitude
                       Latitude:(float)latitude;

-(NSString *)getStringFromObject:(id)object;

-(void)setShadowToTargetView:(UIView *)targetView;

-(void)showAlertWithMessage:(NSString *)message;

#pragma mark - 检测中英文
-(void)checkLaguageWithENAction:(void (^)(void))ENAction CHAction:(void (^)(void))CHAction;

- (void)showToastWithENToast:(NSString *)enToast CHToast:(NSString *)chToast;

@end


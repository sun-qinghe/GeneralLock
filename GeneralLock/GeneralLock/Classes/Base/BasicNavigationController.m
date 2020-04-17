//
//  BasicNavigationController.m
//  飞鸽运维
//
//  Created by anzhong on 2018/6/5.
//  Copyright © 2018年 anda. All rights reserved.
//

#import "BasicNavigationController.h"

@interface BasicNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic, weak) id popDelegate;

@end

@implementation BasicNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    [self configNavigation];
}

- (void)configNavigation {
//    UINavigationBar *navBarAppearance = [UINavigationBar appearance];
//    [navBarAppearance setBackgroundImage:UIImageNamed(@"navBgImage") forBarMetrics:UIBarMetricsDefault];
//    [navBarAppearance setShadowImage:[UIImage new]];
//    navBarAppearance.translucent = NO;
//    [navBarAppearance setTitleTextAttributes:@{
//                                               NSForegroundColorAttributeName:[UIColor whiteColor],
//                                               NSFontAttributeName:UISystemFont(17)
//                                               }];
//
//    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
//    NSDictionary *dic = @{
//                          NSForegroundColorAttributeName:[UIColor whiteColor],
//                          NSFontAttributeName:UISystemFont(16)
//                          };
//    [barButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    self.navigationBar.barTintColor = kSchemeColor;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    if(@available(iOS 11,*)){
        self.navigationBar.prefersLargeTitles = NO;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark - 重写返回按钮
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count > 1) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImageNamed(@"导航栏箭头") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    }
}

-(void)popSelf {
    [self popViewControllerAnimated:YES];
}

-(UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

-(UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

@end

//
//  MSRouteController.m
//  GeneralLock
//
//  Created by 安中 on 2020/3/27.
//  Copyright © 2020 anda. All rights reserved.
//

#import "MSRouteController.h"

@interface MSRouteController ()

@end

@implementation MSRouteController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轨迹查询";
}

@end

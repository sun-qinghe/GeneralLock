//
//  MSStatusController.m
//  GeneralLock
//
//  Created by 安中 on 2019/10/25.
//  Copyright © 2019 anda. All rights reserved.
//

#import "MSStatusController.h"
#import "BikeStatusModel.h"
#import "StatusCell.h"
#import "MSRouteController.h"

@interface MSStatusController ()

@end

@implementation MSStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkLaguageWithENAction:^{
        self.title = @"Device Infomation";
    } CHAction:^{
        self.title = @"设备信息";
    }];
    [self setTableView];
    [self getLockStateInfoWithDeviceNo:self.deviceNo];
}

#pragma mark - tableView
-(void)setTableView{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(@(-SafeBottom));
    }];
    
    [self addRefreshHeader:NO footer:NO];
    
    //设置分割线左边距
//    self.tableView.separatorInset = UIEdgeInsetsZero;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupFooterView];
}

#pragma mark - 设置底部视图
-(void)setupFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300 *kScaleW)];
    
    UIButton *routeBtn = [[UIButton alloc] init];
    routeBtn.backgroundColor = kSchemeColor;
    routeBtn.layer.cornerRadius = 45 *kScaleW;
    [routeBtn setTitle:@"轨迹查询" forState:UIControlStateNormal];
    [routeBtn addTarget:self action:@selector(routeAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:routeBtn];
    [routeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(550 *kScaleW));
        make.height.equalTo(@(90 *kScaleW));
        make.center.equalTo(footerView);
    }];
    
    self.tableView.tableFooterView = footerView;
}

-(void)routeAction:(UIButton *)sender{
    MSRouteController *vc = [[MSRouteController alloc] init];
    NSString *url = [NSString stringWithFormat:@"HTML/MyTrip.html?DeviceNo=%@",self.deviceNo];
    vc.urlStr = kRequestUrl(url);
    [self pushViewController:vc animated:YES];
}

#pragma mark - 获取设备状态
-(void)getLockStateInfoWithDeviceNo:(NSString *)deviceNo{
    NSDictionary *parameters = @{@"deviceNo":deviceNo};
    [[NetTool sharedManager] getWithUrl:kRequestUrl(URL_GetLockStateInfo) sign:nil parameters:parameters success:^(id successResponse) {
        if ([successResponse isSuccess]) {
            self.dataSource = [BikeStatusModel mj_objectArrayWithKeyValuesArray:successResponse[@"Data"]];
            [self tableviewRefresh:YES];
        }
    } fail:^(id failResponse) {
        NSLog(@"失败");
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.statusModel = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

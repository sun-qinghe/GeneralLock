//
//  BasicTableViewController.m
//  飞鸽运维
//
//  Created by anzhong on 2018/6/5.
//  Copyright © 2018年 anda. All rights reserved.
//

#import "BasicTableViewController.h"

@interface BasicTableViewController ()

@end

@implementation BasicTableViewController {
    UITableViewStyle _style;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super init]) {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBasicTableView];
}

- (void)addRefreshHeader:(BOOL)header footer:(BOOL)footer {
    if (header) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadNewData];
        }];
    }
    if (footer) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreData];
        }];
    }
}
- (void)loadNewData {
    [self.tableView.mj_footer resetNoMoreData];
    
}
- (void)loadMoreData {
    
}

- (void)tableviewRefresh:(BOOL)refresh {
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    if (refresh) {
        [self.tableView reloadData];
    }
}

- (void)initBasicTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:_style];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(StatusBarAndNavigationBarHeight)).priorityHigh();
        make.top.left.right.equalTo(@(0));
        make.bottom.equalTo(@(-SafeBottom));
    }];
    
    UIImageView *noDataImg = [[UIImageView alloc] initWithImage:UIImageNamed(@"暂无数据")];
    self.noDataImg = noDataImg;
    noDataImg.hidden = YES;
    [tableView addSubview:noDataImg];
    [noDataImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(260 *kScaleW));
        make.top.equalTo(@(200 *kScaleW));
    }];
    
//    UILabel *hintLabel = [UILabel labelWithText:@"暂无数据" textColor:UIColorWithRGB(0, 187, 255) textSize:20];
//    self.hintLabel = hintLabel;
//    hintLabel.hidden = YES;
//    hintLabel.textAlignment = NSTextAlignmentCenter;
//    [tableView addSubview:hintLabel];
//    [hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(ScreenWidth));
//        make.top.equalTo(@(rateWidth(250)));
//    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1314;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

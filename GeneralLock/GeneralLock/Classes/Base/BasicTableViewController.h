//
//  BasicTableViewController.h
//  飞鸽运维
//
//  Created by anzhong on 2018/6/5.
//  Copyright © 2018年 anda. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicTableViewController : BasicViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIImageView *noDataImg;

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (void)addRefreshHeader:(BOOL)header footer:(BOOL)footer;

- (void)tableviewRefresh:(BOOL)refresh;

- (void)loadNewData;
- (void)loadMoreData;

@end

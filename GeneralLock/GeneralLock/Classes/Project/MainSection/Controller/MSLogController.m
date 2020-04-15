//
//  MSLogController.m
//  GeneralLock
//
//  Created by 安中 on 2019/10/24.
//  Copyright © 2019 anda. All rights reserved.
//

#import "MSLogController.h"
#import "LogCell.h"
#import "LogModel.h"

@interface MSLogController ()

@end

@implementation MSLogController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"指令日志";
    NSLog(@">>>>>>>>>>");
    self.view.backgroundColor = GrayBackground;
    [self setTableView];
    
    if (self.dataSource.count == 0) {
        self.noDataImg.hidden = NO;
    } else {
        self.noDataImg.hidden = YES;
    }
}

#pragma mark - tableView
-(void)setTableView{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(@(-SafeBottom));
    }];
    
    [self addRefreshHeader:NO footer:NO];
    
    //设置分割线左边距
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.logModel = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end

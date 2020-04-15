//
//  MSTipsController.m
//  GeneralLock
//
//  Created by 安中 on 2020/1/7.
//  Copyright © 2020 anda. All rights reserved.
//

#import "MSTipsController.h"
#import "EBDropdownListView.h"

@interface MSTipsController ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) NSString *selectedItem;

@end

@implementation MSTipsController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressInAlertViewGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.selectedItem = @"0";
    
    UIView *baseView = [[UIView alloc] init];
    self.baseView = baseView;
    baseView.backgroundColor = UIColorWhite;
    baseView.layer.cornerRadius = 20 *kScaleW;
    baseView.layer.masksToBounds = YES;
    [self.view addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(690 *kScaleW));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [baseView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(30 *kScaleW));
    }];
    
    NSMutableArray *dataSource = [NSMutableArray array];
    for (int i = 0; i < self.options.count; i++) {
        EBDropdownListItem *item = [[EBDropdownListItem alloc] initWithItem:self.options[i] itemName:self.options[i]];
        [dataSource addObject:item];
    }
    // 弹出框向上
    EBDropdownListView *dropdownListView = [[EBDropdownListView alloc] initWithDataSource:dataSource];
    dropdownListView.selectedIndex = 0;
    [dropdownListView setViewBorder:0.5 borderColor:[UIColor grayColor] cornerRadius:2];
    [baseView addSubview:dropdownListView];
    [dropdownListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(baseView);
        make.width.equalTo(@(300 *kScaleW));
        make.height.equalTo(@(60 *kScaleW));
        make.top.equalTo(label.mas_bottom).offset(30 *kScaleW);
    }];
    
    [dropdownListView setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
        NSString *msgString = [NSString stringWithFormat:
                               @"selected name:%@  id:%@  index:%ld"
                               , dropdownListView.selectedItem.itemName
                               , dropdownListView.selectedItem.itemId
                               , dropdownListView.selectedIndex];
        NSLog(@">>>>>>>>>>%@",msgString);
        self.selectedItem = dropdownListView.selectedItem.itemId;
    }];
    
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setTitleColor:kSchemeColor forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dropdownListView.mas_bottom).offset(50 *kScaleW);
        make.right.equalTo(baseView);
        make.width.equalTo(@(150 *kScaleW));
        make.height.equalTo(@(50 *kScaleW));
        make.bottom.equalTo(baseView).offset(-20 *kScaleW);;
    }];
    
    [self checkLaguageWithENAction:^{
        label.text = @"Help";
        [commitBtn setTitle:@"OK" forState:UIControlStateNormal];
    } CHAction:^{
        label.text = @"帮助";
        [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    }];
}

#pragma mark - 确定按钮
-(void)commitAction:(UIButton *)sender{
    if (self.commitAction) {
        self.commitAction(self.selectedItem);
    }
    [self closeTipView];
}

#pragma mark - 关闭页面
-(void)closeTipView{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 点击其他区域关闭弹窗
- (void)handletapPressInAlertViewGesture:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){
        [self closeTipView];
    }
}

@end

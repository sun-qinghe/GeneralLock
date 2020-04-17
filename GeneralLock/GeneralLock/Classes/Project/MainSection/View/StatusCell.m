//
//  StatusCell.m
//  GeneralLock
//
//  Created by 安中 on 2019/10/28.
//  Copyright © 2019 anda. All rights reserved.
//

#import "StatusCell.h"

@interface StatusCell ()

/** -- title -- */
@property (nonatomic, strong) UILabel *titleLabel;
/** -- detail -- */
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation StatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorWhite;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    titleLabel.font = UISystemFont(15);
    [self.contentView addSubview:titleLabel];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(@(30 *kScaleW));
        make.width.equalTo(@(210 *kScaleW));
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    self.detailLabel = detailLabel;
    detailLabel.numberOfLines = 0;
    detailLabel.textColor = UIColorWithRGB(165, 165, 165);
    detailLabel.font = UISystemFont(15);
    [self.contentView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.equalTo(titleLabel.mas_right).offset(30 * kScaleW);
        make.right.equalTo(self.contentView.mas_right).offset(-30 *kScaleW);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}

-(void)setStatusModel:(BikeStatusModel *)statusModel{
    _statusModel = statusModel;
    NSString *detailStr;
    if ([statusModel.Data containsString:@"T"]) {
        detailStr = [statusModel.Data stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    } else {
        detailStr = statusModel.Data;
    }
    self.detailLabel.text = detailStr;
    self.titleLabel.text = statusModel.Message;
}

@end

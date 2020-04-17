//
//  LogCell.m
//  飞鸽运维
//
//  Created by 安中 on 2019/10/9.
//  Copyright © 2019 anda. All rights reserved.
//

#import "LogCell.h"

@interface LogCell ()

/** -- 时间 -- */
@property (nonatomic, strong) UILabel *timeLabel;
/** -- 日志 -- */
@property (nonatomic, strong) UILabel *logLabel;

@end

@implementation LogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorWhite;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UIImageView *timeIcon = [[UIImageView alloc] init];
    timeIcon.image = UIImageNamed(@"更改GPS回报时间");
    [self.contentView addSubview:timeIcon];
    [timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(30 *kScaleW));
        make.width.height.equalTo(@(50 *kScaleW));
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
//    timeLabel.numberOfLines = 0;
    timeLabel.font = kScreenWidth == 320?UISystemFont(14):UISystemFont(15);
//    timeLabel.font = UISystemFont(15);
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeIcon.mas_right).offset(20 *kScaleW);
        make.centerY.equalTo(timeIcon);
        make.right.equalTo(self.contentView.mas_right).offset(-30 *kScaleW);
    }];
    
    UILabel *logLabel = [[UILabel alloc] init];
    self.logLabel = logLabel;
    logLabel.numberOfLines = 0;
    logLabel.font = kScreenWidth == 320?UISystemFont(14):UISystemFont(15);
//    logLabel.font = UISystemFont(15);
    [self.contentView addSubview:logLabel];
    [logLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(25 *kScaleW);
        make.left.equalTo(timeLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-30 *kScaleW);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30 *kScaleW);
    }];
    
    UIImageView *logIcon = [[UIImageView alloc] init];
    logIcon.image = UIImageNamed(@"下发扫描蓝牙桩指令");
    [self.contentView addSubview:logIcon];
    [logIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(timeIcon);
        make.centerY.equalTo(logLabel);
        make.width.height.equalTo(@(50 *kScaleW));
    }];
}

-(void)setLogModel:(LogModel *)logModel{
    _logModel = logModel;
    NSString *time = [logModel.CmdTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    self.timeLabel.text = time;
    self.logLabel.text = logModel.Cmd;
}

@end

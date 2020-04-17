//
//  LogCell.h
//  飞鸽运维
//
//  Created by 安中 on 2019/10/9.
//  Copyright © 2019 anda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogCell : UITableViewCell

@property (nonatomic, strong) LogModel *logModel;

@end

NS_ASSUME_NONNULL_END

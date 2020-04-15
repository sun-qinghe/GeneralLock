//
//  StatusCell.h
//  GeneralLock
//
//  Created by 安中 on 2019/10/28.
//  Copyright © 2019 anda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BikeStatusModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatusCell : UITableViewCell

@property (nonatomic, strong) BikeStatusModel *statusModel;

@end

NS_ASSUME_NONNULL_END

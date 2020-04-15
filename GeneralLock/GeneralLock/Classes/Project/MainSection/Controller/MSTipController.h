//
//  MSTipController.h
//  GeneralLock
//
//  Created by 安中 on 2019/10/18.
//  Copyright © 2019 anda. All rights reserved.
//

#import "BasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSTipController : BasicViewController

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, copy) MYActionArgument commitAction;

@end

NS_ASSUME_NONNULL_END

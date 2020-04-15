//
//  MSTipsController.h
//  GeneralLock
//
//  Created by 安中 on 2020/1/7.
//  Copyright © 2020 anda. All rights reserved.
//

#import "BasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSTipsController : BasicViewController

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, copy) MYActionArgument commitAction;

@end

NS_ASSUME_NONNULL_END

//
//  InstructDataModel.h
//  GeneralLock
//
//  Created by anzhong on 2019/10/18.
//  Copyright © 2019 anda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstructModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstructDataModel : NSObject

@property (nonatomic, strong) NSArray <InstructModel *> *data;

@end

NS_ASSUME_NONNULL_END

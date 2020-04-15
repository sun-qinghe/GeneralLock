//
//  BikeModel.m
//  GeneralLock
//
//  Created by 安中 on 2019/10/25.
//  Copyright © 2019 anda. All rights reserved.
//

#import "BikeModel.h"

@implementation BikeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.Id = value;
    }
}

@end

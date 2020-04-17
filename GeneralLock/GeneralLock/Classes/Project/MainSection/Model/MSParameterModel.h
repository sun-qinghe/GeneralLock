//
//  MSParameterModel.h
//  GeneralLock
//
//  Created by 安中 on 2019/10/18.
//  Copyright © 2019 anda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSParameterModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *en_name;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSArray *option;

@end

NS_ASSUME_NONNULL_END

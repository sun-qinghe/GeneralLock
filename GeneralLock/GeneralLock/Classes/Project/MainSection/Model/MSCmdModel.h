//
//  MSCmdModel.h
//  GeneralLock
//
//  Created by 安中 on 2019/10/18.
//  Copyright © 2019 anda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSCmdModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *en_name;

@property (nonatomic, copy) NSString *cmd;

@property (nonatomic, copy) NSArray *parameters;

@end

NS_ASSUME_NONNULL_END

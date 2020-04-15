//
//  LogModel.h
//  飞鸽运维
//
//  Created by 安中 on 2019/10/9.
//  Copyright © 2019 anda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogModel : NSObject

@property (nonatomic, strong) NSString *Cmd;
@property (nonatomic, strong) NSString *CmdTime;

@end

NS_ASSUME_NONNULL_END

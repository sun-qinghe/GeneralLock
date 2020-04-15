//
//  User.h
//  飞鸽运维
//
//  Created by anzhong on 2018/6/21.
//  Copyright © 2018年 anda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

/** --手机号 -- */
@property (nonatomic, strong) NSString *userId;
/** --经度 -- */
@property (nonatomic, assign) double Lon;
/** --纬度 -- */
@property (nonatomic, assign) double Lat;

@end

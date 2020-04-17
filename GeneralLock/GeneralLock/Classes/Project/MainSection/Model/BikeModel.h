//
//  BikeModel.h
//  GeneralLock
//
//  Created by 安中 on 2019/10/25.
//  Copyright © 2019 anda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BikeModel : NSObject

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, assign) double Latitude;

@property (nonatomic, copy) NSString *GpsTime;

@property (nonatomic, assign) NSInteger LockFlag;

@property (nonatomic, assign) double Longitude;

@property (nonatomic, copy) NSString *GpsStatus;

@property (nonatomic, copy) NSString *GpsAddress;

@property (nonatomic, copy) NSString *Power;

@property (nonatomic, copy) NSString *DeviceNo;

@end

NS_ASSUME_NONNULL_END

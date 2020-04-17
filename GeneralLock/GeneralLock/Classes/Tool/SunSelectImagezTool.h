//
//  SunSelectImagezTool.h
//  MyBike
//
//  Created by 孙兴祥 on 2017/12/6.
//  Copyright © 2017年 sunxingxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunSelectImagezTool : NSObject

+ (void)getImageWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate toVC:(UIViewController *)vc;

@end

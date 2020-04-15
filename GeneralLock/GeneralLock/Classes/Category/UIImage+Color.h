//
//  UIImage+Color.h
//  MyBike
//
//  Created by sun on 2017/11/26.
//  Copyright © 2017年 sunxingxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

//将图片转为一个颜色
- (UIImage *)imageWithColor:(UIColor *)color;
//获得灰白照片
- (UIImage *)getGrayImage;

@end

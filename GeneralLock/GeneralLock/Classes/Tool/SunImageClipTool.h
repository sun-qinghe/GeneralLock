//
//  SunImageVideoClipTool.h
//  SunTestInstagram
//
//  Created by 孙兴祥 on 2017/8/1.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunImageClipTool : NSObject

//剪裁中间方形区域
+ (UIImage *)getClipImage:(UIImage *)sourceImage;
//剪裁指定区域
+ (UIImage *)getClipImage:(UIImage *)sourceImage clipRect:(CGRect)clipRect;
//剪裁内切圆
+ (UIImage *)getCircleImage:(UIImage *)soucrceImage;
//将图片剪裁成指定大小
+ (UIImage *)changeImage:(UIImage *)image toTargetWidth:(CGFloat)width;

@end

//
//  SunImageVideoClipTool.m
//  SunTestInstagram
//
//  Created by 孙兴祥 on 2017/8/1.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "SunImageClipTool.h"

@implementation SunImageClipTool

+ (UIImage *)getClipImage:(UIImage *)sourceImage clipRect:(CGRect)clipRect {

    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };
    
    CGAffineTransform rectTransform;
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -sourceImage.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -sourceImage.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -sourceImage.size.width, -sourceImage.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, sourceImage.scale, sourceImage.scale);
    CGRect transformedCropSquare = CGRectApplyAffineTransform(clipRect, rectTransform);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(sourceImage.CGImage, transformedCropSquare);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:sourceImage.scale orientation:sourceImage.imageOrientation];
    sourceImage = nil;
    CGImageRelease(imageRef);
    return image;
}

+ (UIImage *)getClipImage:(UIImage *)sourceImage {
    
    CGPoint center = CGPointMake(sourceImage.size.width/2.0, sourceImage.size.height/2.0);
    CGFloat min = MIN(sourceImage.size.width, sourceImage.size.height);
    
    CGRect clipRect = CGRectMake(center.x-min/2.0, center.y-min/2.0, min, min);
    return [self getClipImage:sourceImage clipRect:clipRect];
}


+ (UIImage *)getCircleImage:(UIImage *)soucrceImage {

    UIGraphicsBeginImageContextWithOptions(soucrceImage.size, NO, soucrceImage.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, soucrceImage.size.width, soucrceImage.size.height));
    CGContextClip(ctx);
    
    [soucrceImage drawInRect:CGRectMake(0, 0, soucrceImage.size.width, soucrceImage.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)changeImage:(UIImage *)image toTargetWidth:(CGFloat)width {
    
    CGSize size = CGSizeMake(width, image.size.height/image.size.width*width);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = nil;
    return targetImage;
}

@end

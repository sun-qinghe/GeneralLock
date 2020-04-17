//
//  UIView+Global.h
//  飞鸽运维
//
//  Created by anzhong on 2018/6/5.
//  Copyright © 2018年 anda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Global)

@end

@interface UILabel (label)
+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)color textSize:(CGFloat)size;
@end

@interface UIButton (button)
+ (UIButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image selectImage:(UIImage *) selectImage textColor:(UIColor *)color fontSize:(CGFloat)size;
@end

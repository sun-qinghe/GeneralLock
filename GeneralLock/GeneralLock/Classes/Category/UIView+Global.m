//
//  UIView+Global.m
//  飞鸽运维
//
//  Created by anzhong on 2018/6/5.
//  Copyright © 2018年 anda. All rights reserved.
//

#import "UIView+Global.h"

@implementation UIView (Global)

@end

@implementation UILabel (label)
+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)color textSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = UISystemFont(size);
    label.text = text;
    return label;
}

@end

@implementation UIButton (button)

+ (UIButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image selectImage:(UIImage *) selectImage textColor:(UIColor *)color fontSize:(CGFloat)size {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = UISystemFont(size);
    return button;
}

@end

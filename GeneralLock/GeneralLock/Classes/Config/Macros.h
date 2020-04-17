//
//  Macros.h
//  haipai
//
//  Created by Tom Yin on 2016/12/8.
//  Copyright © 2016年 LW. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

// 颜色(RGB)
#define UIColorWithRGB(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define UIColorWithRGBA(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define UIColorFromRGB(rgb)           [UIColor colorWithRed:(((rgb & 0xFF0000) >> 16))/255.0 green:(((rgb &0xFF00) >>8))/255.0 blue:((rgb &0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBF(rgb, a)       [UIColor colorWithRed:(((rgb & 0xFF0000) >> 16))/255.0 green:(((rgb &0xFF00) >>8))/255.0 blue:((rgb &0xFF))/255.0 alpha:a]
#define UIColorWithSameRGB(s)         UIColorWithRGB(s, s, s)
#define UIColorWhite                  [UIColor whiteColor]
#define UIColorBlack                  [UIColor blackColor]
#define GrayBackground                UIColorWithRGB(245, 245, 245)
#define GrayLine                      UIColorWithRGB(210, 210, 210)
#define GrayText                      UIColorWithRGB(191, 191, 191)
#define kSchemeColor                  UIColorWithRGB(0, 180, 255)


//获得屏幕的宽高
#define ScreenBounds                  [UIScreen mainScreen].bounds
#define kScreenWidth                  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight                 ([UIScreen mainScreen].bounds.size.height)
#define kScaleH                       (kScreenHeight/1334.f)
#define kScaleW                       (kScreenWidth/750.f)

//适配全面屏
//iPhoneX / iPhoneXS
#define  isIphoneX_XS                 (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
//iPhoneXR / iPhoneXSMax
#define  isIphoneXR_XSMax             (kScreenWidth == 414.f && kScreenHeight == 896.f ? YES : NO)
//异性全面屏
#define   fullScreen                  (isIphoneX_XS || isIphoneXR_XSMax)
// Status bar height.
#define  StatusBarHeight              (fullScreen ? 44.f : 20.f)
// Navigation bar height.
#define  NavigationBarHeight          44.f
// Tabbar height.
#define  TabbarHeight                 (fullScreen ? (49.f+34.f) : 49.f)
// Tabbar safe bottom margin.
#define  SafeBottom                   (fullScreen ? 34.f : 0.f)
// Status bar & navigation bar height.
#define  StatusBarAndNavigationBarHeight  (fullScreen ? 88.f : 64.f)

//高德key
#define GaoDeKEY @"712cd6bd14880cee1fe2549ce22b14d0"
//极光推送
#define JPushKEY @"c96ad8d353d59d65e6788afe"

// 系统版本
#define IOS10 [[[UIDevice currentDevice] systemVersion] floatValue] > 10.0
#define IOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

// 屏幕尺寸
#define INCH_3_5 [UIScreen mainScreen].bounds.size.height == 480.0
#define INCH_4   [UIScreen mainScreen].bounds.size.height == 568.0
#define INCH_4_7 [UIScreen mainScreen].bounds.size.height == 667.0
#define INCH_5_5 [UIScreen mainScreen].bounds.size.height == 736.0
#define INCH_5_8 [UIScreen mainScreen].bounds.size.height == 812.0

// 屏幕比例
#define kScreenRatio ScreenWidth / ScreenHeight
#define ScreenScale [[UIScreen mainScreen] scale]

// 字体
#define UISystemFont(fontSize) [UIFont systemFontOfSize:fontSize]
#define UIBoldFont(fontSize) [UIFont boldSystemFontOfSize:fontSize]
#define TextColor UIColorWithRGB(11,20,27)


//本地化
#define kUserDefaults [NSUserDefaults standardUserDefaults]

//存储对象
#define kUserDefaultSetObjectForKey(__VALUE__,__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}
//获得存储的对象
#define kUserDefaultObjectForKey(__KEY__)  [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]

//删除对象
#define kUserDefaultRemoveObjectForKey(__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

// 图片
#define UIImageNamed(name) [UIImage imageNamed:name]
#define UIImageWithColor(color) [UIImage createImageWithColor:color]

//调试输出
//#ifdef __OBJC__
//#ifdef DEBUG
//#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#else
//#define NSLog(...)
//#endif
//#endif

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\n %s:%d   %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

//主屏幕
#define KeyWindow   [UIApplication sharedApplication].keyWindow

#define IS_NULL(obj) obj == nil ? YES : (obj == (id)[NSNull null] ? YES : NO)
#define IS_NOT_NULL(obj) obj != nil ? (obj != (id)[NSNull null] ? YES : NO) : NO

//字符串是否为空
#define kISNullString(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kISNullArray(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0 ||[array isEqual:[NSNull null]])
//字典是否为空
#define kISNullDict(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0 || [dic isEqual:[NSNull null]])
//是否是空对象
#define kISNullObject(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
//判断对象是否为空,为空则返回默认值
#define kGetNullDefaultObj(_value,_default) ([_value isKindOfClass:[NSNull class]] || !_value || _value == nil || [_value isEqualToString:@"(null)"] || [_value isEqualToString:@"<null>"] || [_value isEqualToString:@""] || [_value length] == 0)?_default:_value

// Block
typedef void(^MYActionArgument)(id parameter);
typedef void(^MYActionDoubleArgument)(id parameter1, id parameter2);
typedef void(^MYAction)(void);

#endif

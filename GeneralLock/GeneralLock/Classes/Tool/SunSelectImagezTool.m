//
//  SunSelectImagezTool.m
//  MyBike
//
//  Created by 孙兴祥 on 2017/12/6.
//  Copyright © 2017年 sunxingxiang. All rights reserved.
//

#import "SunSelectImagezTool.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation SunSelectImagezTool

+ (void)getImageWithDelegate:(id)delegate toVC:(UIViewController *)vc {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self getImageWithSoucceType:UIImagePickerControllerSourceTypeCamera delegate:delegate toVC:vc];
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self getImageWithSoucceType:UIImagePickerControllerSourceTypePhotoLibrary delegate:delegate toVC:vc];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cameraAction];
    [alertVC addAction:albumAction];
    [alertVC addAction:cancelAction];
    [vc presentViewController:alertVC animated:YES completion:NULL];
}

+ (void)getImageWithSoucceType:(UIImagePickerControllerSourceType)sourceType delegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate toVC:(UIViewController *)vc {
    
    UIImagePickerController *pickVc = [[UIImagePickerController alloc] init];
    pickVc.sourceType = sourceType;
    pickVc.mediaTypes = @[(NSString *)kUTTypeImage];
    pickVc.allowsEditing = YES;
    pickVc.delegate = delegate;
    [vc presentViewController:pickVc animated:pickVc completion:NULL];
}

@end

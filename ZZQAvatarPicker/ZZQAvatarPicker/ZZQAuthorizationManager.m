//
//  ZZQAuthorizationManager.m
//  ZZQAvatarPicker
//
//  Created by 郑志强 on 2018/11/1.
//  Copyright © 2018 郑志强. All rights reserved.
//

#import "ZZQAuthorizationManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

@implementation ZZQAuthorizationManager

+ (void)checkCameraAuthorization:(void (^)(BOOL))completion {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            //第一次提示用户授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                completion ? completion(granted) : nil;
            }];
        }
            break;
            
        case AVAuthorizationStatusAuthorized: {
            completion ? completion(YES) : nil;
        }
            break;
            
        case AVAuthorizationStatusRestricted: {
            completion ? completion(NO) : nil;
        }
            break;
            
        case AVAuthorizationStatusDenied: {
            completion ? completion(NO) : nil;
        }
            break;
    }
}


+ (void)requestCameraAuthorization {

    __weak typeof (self) weakSelf = self;
    [self checkCameraAuthorization:^(BOOL isPermission) {
        if (!isPermission) {
            [weakSelf showSettingAlertWithAuth:@"相机" settingName:@"相机"];
        }
    }];
}



+ (void)checkPhotoLibraryAuthorization:(void (^)(BOOL))completion {
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];

    switch (authStatus) {

        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                completion ? completion(status == PHAuthorizationStatusAuthorized) : nil;
            }];
        }
            break;
            
        case PHAuthorizationStatusRestricted: {
            completion ? completion(NO) : nil;
        }
            break;
            
        case PHAuthorizationStatusDenied: {
            completion ? completion(NO) : nil;
        }
            break;
            
        case PHAuthorizationStatusAuthorized: {
            completion ? completion(YES) : nil;
        }
            break;
    }
}


+ (void)requestPhotoLibraryAuthorization {
    
    __weak typeof (self) weakSelf = self;
    [self checkPhotoLibraryAuthorization:^(BOOL isPermission) {
        if (!isPermission) {
            [weakSelf showSettingAlertWithAuth:@"相册" settingName:@"照片"];
        }
    }];
}



+ (void)showSettingAlertWithAuth:(NSString *)auth settingName:(NSString *)settingName {
    
    NSString *title = [NSString stringWithFormat:@"无法使用%@",auth];
    NSString *message = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-%@”中允许访问相机", settingName];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIViewController *rootVC = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    __weak typeof(rootVC) weakRootVC = rootVC;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            [weakRootVC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:setAction];
 
    [rootVC presentViewController:alertController animated:YES completion:nil];
}



@end

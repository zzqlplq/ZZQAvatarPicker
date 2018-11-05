//
//  ZZQAvatarPicker.m
//  ZZQAvatarPicker
//
//  Created by 郑志强 on 2018/10/31.
//  Copyright © 2018 郑志强. All rights reserved.
//

#import "ZZQAvatarPicker.h"
#import "ZZQResourceSheetView.h"
#import "ZZQAuthorizationManager.h"

typedef void(^seletedImage)(UIImage *image);

@interface ZZQAvatarPicker ()<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
ZZQResouceSheetViewDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) ZZQResourceSheetView *toolView;

@property (nonatomic, copy) seletedImage selectedImage;

@end

@implementation ZZQAvatarPicker

+ (void)startSelected:(void(^)(UIImage *image))compleiton {
      [[self new] startSelected:^(UIImage * _Nonnull image) {
        compleiton(image);
    }];
}


- (void)startSelected:(void (^)(UIImage * _Nonnull))compleiton {
    [self.toolView show];
    self.selectedImage = compleiton;
}


#pragma mark - <ZZQResouceSheetViewDelegate>

- (void)ZZQResourceSheetView:(ZZQResourceSheetView *)sheetView seletedMode:(ResourceMode)resourceMode {
    
    if (resourceMode == ResourceModeNone) {
        self.selectedImage ? self.selectedImage(nil) : nil;
        [self clean];
        return;
    }
    
    if (resourceMode == ResourceModeAlbum) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        __weak typeof(self) weakSelf = self;
        [ZZQAuthorizationManager checkPhotoLibraryAuthorization:^(BOOL isPermission) {
            if (isPermission) {
                [weakSelf presentToImagePicker];
            } else {
                [ZZQAuthorizationManager requestPhotoLibraryAuthorization];
            }
        }];
  
    } else if (resourceMode == ResourceModeCamera) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        
        __weak typeof(self) weakSelf = self;
        [ZZQAuthorizationManager checkCameraAuthorization:^(BOOL isPermission) {
            if (isPermission) {
                [weakSelf presentToImagePicker];
            } else {
                [ZZQAuthorizationManager requestCameraAuthorization];
            }
        }];
    }
}


- (void)presentToImagePicker {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootVC = [[[UIApplication sharedApplication] delegate] window].rootViewController;
        [rootVC presentViewController:self.imagePicker animated:YES completion:nil];
    });
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {

    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.selectedImage ? self.selectedImage(image) : nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self clean];
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.selectedImage ? self.selectedImage(nil) : nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self clean];
    }];
}


- (void)clean {
    self.toolView.delegate = nil;
    self.toolView = nil;
}


#pragma mark - getter

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}


- (ZZQResourceSheetView *)toolView {
    if (!_toolView) {
        _toolView = [ZZQResourceSheetView new];
        _toolView.delegate = self;
    }
    return _toolView;
}


- (void)dealloc {
    NSLog(@"picker dealloc");
}

@end

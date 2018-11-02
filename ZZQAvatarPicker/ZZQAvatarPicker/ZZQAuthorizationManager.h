//
//  ZZQAuthorizationManager.h
//  ZZQAvatarPicker
//
//  Created by 郑志强 on 2018/11/1.
//  Copyright © 2018 郑志强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZQAuthorizationManager : NSObject

+ (void)checkCameraAuthorization:(void(^)(BOOL isPermission))completion;

+ (void)requestCameraAuthorization;

+ (void)checkPhotoLibraryAuthorization:(void(^)(BOOL isPermission))completion;

+ (void)requestPhotoLibraryAuthorization;

@end

NS_ASSUME_NONNULL_END

//
//  ZZQAuthorizationManager.h
//  ZZQAvatarPicker
//
//  Created by 郑志强 on 2018/11/1.
//  Copyright © 2018 郑志强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZZQAuthorizationType) {
    ZZQAuthorizationTypeCamera,
    ZZQAuthorizationTypePhotoLibrary,
    ZZQAuthorizationTypeMicrophone
};



@interface ZZQAuthorizationManager : NSObject

+ (void)checkAuthorization:(ZZQAuthorizationType)type
        firstRequestAccess:(void(^ __nullable)(void))requestAccess
                completion:(void(^)(BOOL isPermission))completion;


+ (void)requestAuthorization:(ZZQAuthorizationType)type;

@end

NS_ASSUME_NONNULL_END

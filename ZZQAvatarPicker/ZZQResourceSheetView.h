//
//  ZZQResourceSheetView.h
//  ZZQAvatarPicker
//
//  Created by 郑志强 on 2018/10/31.
//  Copyright © 2018 郑志强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ResourceMode) {
    ResourceModeNone   =  0,   // 取消选择
    ResourceModeCamera,
    ResourceModeAlbum
};

@class ZZQResourceSheetView;

@protocol ZZQResouceSheetViewDelegate<NSObject>

- (void)ZZQResourceSheetView:(ZZQResourceSheetView *)sheetView
                 seletedMode:(ResourceMode)resourceMode;
@end


@interface ZZQResourceSheetView : UIView

@property (nonatomic, weak) id<ZZQResouceSheetViewDelegate> delegate;

- (void)show;

@end

NS_ASSUME_NONNULL_END

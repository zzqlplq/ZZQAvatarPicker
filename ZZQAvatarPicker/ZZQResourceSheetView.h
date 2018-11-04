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

// 持有强引用，调用接收后，手动置为空，不然 ZZQAvatarPicker 会提前释放
@property (nonatomic, strong, nullable) id<ZZQResouceSheetViewDelegate> delegate;

- (void)show;

@end

NS_ASSUME_NONNULL_END

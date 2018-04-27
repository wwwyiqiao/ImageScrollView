//
//  WDSNBannerView.h
//  WDSPublic_Common
//
//  Created by WangYiqiao on 2018/4/27.
//  Copyright © 2018年 smallsao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDSNBannerView;

@protocol WDSNBannerViewDelegate <NSObject>

- (void)bannerView:(WDSNBannerView *)bannerView tappedAtIndex:(NSInteger)index;

@end


typedef void(^WDSNBannerBlock)(NSInteger index);

@interface WDSNBannerView : UIView

// 自动滚动时间间隔 默认5s
@property (nonatomic, assign) NSTimeInterval autoScrollInterval;

// 是否自动滚动 默认YES
@property (nonatomic, assign) BOOL autoScroll;

// 是否开启循环模式 默认YES
@property (nonatomic, assign) BOOL enableLoop;

// 单页时是否隐藏page control 默认YES
@property (nonatomic, assign) BOOL hidesForSinglePage;

// 默认aspectFill
@property (nonatomic, assign) BOOL imageContentMode;

@property (nonatomic, copy) WDSNBannerBlock bannerBlock;

@property (nonatomic, weak) id<WDSNBannerViewDelegate> delegate;

- (void)updateImages:(NSArray<UIImage *> *)images;

- (void)updateImageUrls:(NSArray<NSString *> *)imageUrls;

@end

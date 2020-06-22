//
//  QHWCycleScrollView.h
//  MyProject
//
//  Created by xiaobu on 2019/4/2.
//  Copyright © 2019年 xiaobu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "QHWPageControl.h"

@class QHWCycleScrollView;
@protocol QHWCycleScrollViewDelegate <NSObject>
/** 点击图片回调 */
@optional
- (void)cycleScrollView:(QHWCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
- (void)cycleScrollView:(QHWCycleScrollView *)cycleScrollView scrollToIndex:(NSInteger)index;
@end

@interface QHWCycleScrollView : UIView


@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *imgArray;//图片数组
/** 是否无线循环，默认yes */
@property (nonatomic,assign) BOOL infiniteLoop;
/** 是否自动滑动，默认yes */
@property (nonatomic,assign) BOOL autoScroll;
/** 是否缩放，默认不缩放 */
@property (nonatomic,assign) BOOL isZoom;
/** 自动滚动间隔时间，默认2s */
@property (nonatomic,assign) CGFloat autoScrollTimeInterval;
//cell宽度
@property (nonatomic,assign) CGFloat itemWidth;//建议不要使用

/** cell间距 */
@property (nonatomic,assign) CGFloat itemSpace;

/** cell两边距离两边屏幕的间距 */
@property (nonatomic,assign) CGFloat betweenGap;
/** imagView圆角，默认为0 */
@property (nonatomic,assign) CGFloat imgCornerRadius;

//代理方法
@property (nonatomic,weak) id<QHWCycleScrollViewDelegate> delegate;


@property (nonatomic,assign) NSInteger selectIndex;
///pagecontrol样式  默认no 
@property (nonatomic,assign) BOOL pageControlLabel;

//初始化方法
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageGroups:(NSArray<NSString *> *)imageGroups;
- (void)adjustWhenControllerViewWillAppear;
- (NSInteger)currentIndex;
- (NSInteger)getCurrentAbsoluteIndex;
- (void)setupTimer;
- (void)invalidateTimer;

@end

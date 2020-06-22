//
//  QHWRefreshManager.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/16.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHWItemPageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QHWRefreshManager : NSObject

+ (instancetype)sharedInstance;

/**
 普通下拉刷新

 @param scrollView scrollview
 @param refreshBlock 回调
 */
- (void)normalHeaderWithScrollView:(UIScrollView *)scrollView RefreshBlock:(void(^)(void))refreshBlock;

/**
 普通上拉加载

 @param scrollView scrollView
 @param refreshBlock 回调
 */
- (void)normalFooterWithScrollView:(UIScrollView *)scrollView RefreshBlock:(void(^)(void))refreshBlock;

/**
 结束加载方法

 @param scrollView scrollView
 @param pageModel 根据pageModel判断
 */
- (void)endRefreshWithScrollView:(UIScrollView *)scrollView PageModel:(QHWItemPageModel *)pageModel;

@end

NS_ASSUME_NONNULL_END

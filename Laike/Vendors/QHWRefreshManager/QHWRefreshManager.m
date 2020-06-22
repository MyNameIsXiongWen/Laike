//
//  QHWRefreshManager.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/16.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWRefreshManager.h"
#import <MJRefresh.h>
#import "UIImage+GIF.h"

@interface QHWRefreshManager ()

@end

@implementation QHWRefreshManager

+ (instancetype)sharedInstance {
    static QHWRefreshManager *refresh = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        refresh = [[QHWRefreshManager alloc] init];
    });
    return refresh;
}

- (void)normalHeaderWithScrollView:(UIScrollView *)scrollView RefreshBlock:(void (^)(void))refreshBlock {
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshBlock];
    scrollView.mj_header = refreshHeader;
}

- (void)normalFooterWithScrollView:(UIScrollView *)scrollView RefreshBlock:(void (^)(void))refreshBlock {
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshBlock];
    [refreshFooter setTitle:@"--我是有底线的--" forState:MJRefreshStateNoMoreData];
    refreshFooter.stateLabel.font = kFontTheme13;
    refreshFooter.stateLabel.textColor = kColorThemea4abb3;
    scrollView.mj_footer = refreshFooter;
}

- (void)endRefreshWithScrollView:(UIScrollView *)scrollView PageModel:(QHWItemPageModel *)pageModel {
    if (pageModel.pagination.currentPage*pageModel.pagination.pageSize >= pageModel.pagination.total) {
        [scrollView.mj_footer endRefreshingWithNoMoreData];
        MJRefreshAutoGifFooter *refreshFooter = (MJRefreshAutoGifFooter *)scrollView.mj_footer;
        refreshFooter.stateLabel.hidden = pageModel.pagination.total == 0;
    } else {
        [scrollView.mj_footer endRefreshing];
    }
}

@end

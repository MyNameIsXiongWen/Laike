//
//  GalleryViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryScrollContentViewController.h"
#import "GalleryGenerateScrollContentViewController.h"
#import "QHWTabScrollView.h"
#import "QHWPageContentView.h"

@interface GalleryViewController () <QHWPageContentViewDelegate>

@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) QHWPageContentView *pageContentView;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"霸屏海报";
    [self.view addSubview:self.tabScrollView];
    [self.view addSubview:self.pageContentView];
}

#pragma mark ------------QHWPageContentViewDelegate-------------
- (void)QHWContentViewWillBeginDragging:(QHWPageContentView *)contentView {
    
}

- (void)QHWContentViewDidEndDecelerating:(QHWPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    [self.tabScrollView scrollToIndex:endIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 48)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixed;
        _tabScrollView.itemSelectedColor = kColorTheme21a8ff;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.dataArray = @[@"霸屏海报", @"专属海报"];
        WEAKSELF
        _tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.pageContentView.contentViewCurrentIndex = index;
        };
    }
    return _tabScrollView;
}

- (QHWPageContentView *)pageContentView {
    if (!_pageContentView) {
        NSMutableArray *contentVCs = [NSMutableArray array];
        GalleryScrollContentViewController *vc1 = GalleryScrollContentViewController.new;
        [contentVCs addObject:vc1];
        GalleryGenerateScrollContentViewController *vc2 = GalleryGenerateScrollContentViewController.new;
        [contentVCs addObject:vc2];
        _pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, kScreenH-self.tabScrollView.bottom) childVCs:contentVCs parentVC:self delegate:self];
    }
    return _pageContentView;
}

@end

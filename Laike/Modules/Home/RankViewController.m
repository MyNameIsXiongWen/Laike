//
//  RankViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RankViewController.h"
#import "RankScrollContentViewController.h"
#import "QHWPageContentView.h"
#import "QHWTabScrollView.h"

@interface RankViewController () <QHWPageContentViewDelegate>

@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) QHWPageContentView *pageContentView;

@end

@implementation RankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"排行榜";
    self.kNavigationView.titleLabel.textColor = kColorThemefff;
    [self.kNavigationView.leftBtn setImage:kImageMake(@"global_back_white") forState:0];
    self.kNavigationView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.topImgView];
    [self.view addSubview:self.tabScrollView];
    [self.view addSubview:self.pageContentView];
    [self.view addSubview:UIView.viewFrame(CGRectMake(0, self.tabScrollView.bottom-0.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
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

- (UIImageView *)topImgView {
    if (!_topImgView) {
        _topImgView = UIImageView.ivFrame(CGRectMake(0, 0, kScreenW, 180)).ivBkgColor(kColorFromHexString(@"bdb5b5")).ivImage(kImageMake(@"rank_bkg"));
        UILabel *label1 = UILabel.labelFrame(CGRectMake(40, kTopBarHeight + 20, kScreenW-80, 25)).labelText(@"人气排行榜").labelTitleColor(kColorThemefff).labelFont(kFontTheme22);
        UILabel *label2 = UILabel.labelFrame(CGRectMake(40, label1.bottom + 5, kScreenW-80, 20)).labelText(@"继续努力，你也会成为榜单第1人！").labelTitleColor(kColorThemefff).labelFont(kFontTheme14);
        [_topImgView addSubview:label1];
        [_topImgView addSubview:label2];
    }
    return _topImgView;
}

- (QHWTabScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, self.topImgView.bottom, kScreenW, 48)];
        _tabScrollView.itemWidthType = ItemWidthTypeFixed;
        _tabScrollView.hideIndicatorView = NO;
        _tabScrollView.tagIndicatorColor = kColorTheme21a8ff;
        _tabScrollView.itemSelectedColor = kColorTheme21a8ff;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.dataArray = @[@"顾问榜", @"公司榜"];
        WEAKSELF
        _tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.pageContentView.contentViewCurrentIndex = index;
        };
        [self.view addSubview:_tabScrollView];
    }
    return _tabScrollView;
}

- (QHWPageContentView *)pageContentView {
    if (!_pageContentView) {
        NSMutableArray *contentVCs = [NSMutableArray array];
        NSArray *statusArray = @[@(1), @(2)];
        for (int i=0; i<statusArray.count; i++) {
            RankScrollContentViewController *vc = [[RankScrollContentViewController alloc] init];
            vc.rankType = [statusArray[i] integerValue];
            [contentVCs addObject:vc];
        }
        _pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, kScreenH-self.tabScrollView.bottom) childVCs:contentVCs parentVC:self delegate:self];
        [self.view addSubview:_pageContentView];
    }
    return _pageContentView;
}

@end

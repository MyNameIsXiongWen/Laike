//
//  DistributionClientViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DistributionClientViewController.h"
#import "DistributionClientScrollContentViewController.h"
#import "DistributionService.h"
#import "QHWTabScrollView.h"
#import "QHWPageContentView.h"

@interface DistributionClientViewController () <QHWPageContentViewDelegate>

@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) QHWPageContentView *pageContentView;
@property (nonatomic, strong) DistributionService *distributionService;

@end

@implementation DistributionClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"客户进度";
    self.kNavigationView.rightBtn.btnTitle(@"+").btnFont([UIFont systemFontOfSize:30 weight:UIFontWeightThin]);
//    [self.kNavigationView.rightAnotherBtn setImage:kImageMake(@"global_search") forState:0];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    [self.getCurrentMethodCallerVC.navigationController pushViewController:NSClassFromString(@"BookAppointmentViewController").new animated:YES];
}

- (void)rightAnthorNavBtnAction:(UIButton *)sender {
    
}

- (void)getMainData {
    [self.distributionService getClientFilterDataRequestWithComplete:^{
        self.tabScrollView.dataArray = [self.distributionService.followStatusArray convertToTitleArrayWithKeyName:@"name"];
        NSMutableArray *contentVCs = [NSMutableArray array];
        for (FilterCellModel *cellModel in self.distributionService.followStatusArray) {
            DistributionClientScrollContentViewController *vc = [[DistributionClientScrollContentViewController alloc] init];
            vc.followStatusCode = cellModel.code;
            [contentVCs addObject:vc];
        }
        self.pageContentView = [[QHWPageContentView alloc] initWithFrame:CGRectMake(0, self.tabScrollView.bottom, kScreenW, kScreenH-self.tabScrollView.bottom) childVCs:contentVCs parentVC:self delegate:self];
        [self.view addSubview:self.pageContentView];
    }];
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
        _tabScrollView.hideIndicatorView = NO;
        _tabScrollView.tagIndicatorColor = kColorTheme21a8ff;
        _tabScrollView.itemWidthType = ItemWidthTypeAdaptive;
        _tabScrollView.itemSelectedColor = kColorTheme21a8ff;
        _tabScrollView.itemUnselectedColor = kColorTheme2a303c;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        _tabScrollView.textFont = kFontTheme16;
        WEAKSELF
        _tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.pageContentView.contentViewCurrentIndex = index;
        };
        [self.view addSubview:_tabScrollView];
        [self.view addSubview:UIView.viewFrame(CGRectMake(0, kTopBarHeight+47.5, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return _tabScrollView;
}

- (DistributionService *)distributionService {
    if (!_distributionService) {
        _distributionService = DistributionService.new;
    }
    return _distributionService;
}

@end

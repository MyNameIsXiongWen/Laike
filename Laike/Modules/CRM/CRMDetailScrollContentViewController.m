//
//  CRMDetailScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMDetailScrollContentViewController.h"

@interface CRMDetailScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CRMDetailScrollContentViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationAddTrackSuccess object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getMainData) name:kNotificationAddTrackSuccess object:nil];
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-48-kBottomDangerHeight-75) Style:UITableViewStylePlain Object:self];
    [self.tableView registerClass:CRMTrackCell.class forCellReuseIdentifier:NSStringFromClass(CRMTrackCell.class)];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.crmService.itemPageModel.pagination.currentPage++;
        [self getMainData];
    }];
    [self.view addSubview:self.tableView];
}

- (void)getMainData {
    [self.crmService getCRMTrackListDataRequestWithComplete:^{
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
        [self.tableView showNodataView:self.crmService.trackArray.count == 0 offsetY:0 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.crmService.itemPageModel];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crmService.trackArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMTrackModel *model = self.crmService.trackArray[indexPath.row];
    return model.trackHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMTrackModel *model = self.crmService.trackArray[indexPath.row];
    CRMTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CRMTrackCell.class)];
    cell.titleLabel.text = kFormat(@"%@ - %@", model.followName, self.crmService.crmModel.realName);
    cell.timeLabel.text = model.createTime;
    cell.contentLabel.text = model.content;
    return cell;
}

#pragma mark ------------UIScrollView-------------
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"接触屏幕");
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"离开屏幕");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    NSLog(@"subScroll======%f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CRMDetailSwipeLeaveTop" object:nil];//到顶通知父视图改变状态
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation CRMTrackCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40);
            make.top.mas_equalTo(10);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(10);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kFontTheme13).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.labelInit().labelFont(kFontTheme13).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentRight);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end

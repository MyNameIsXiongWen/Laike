//
//  QSchoolScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/27.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QSchoolScrollContentViewController.h"
#import "QSchoolService.h"
#import "CTMediator+ViewController.h"

@interface QSchoolScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) QSchoolService *schoolService;

@end

@implementation QSchoolScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-48) Style:UITableViewStylePlain Object:self];
    self.tableView.rowHeight = 110;
    [self.tableView registerClass:QSchoolTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QSchoolTableViewCell.class)];
    UIView *headerView = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 35));
    [headerView addSubview:UILabel.labelFrame(CGRectMake(10, 10, kScreenW-20, 25)).labelText(@"热门精选").labelTitleColor(kColorTheme2a303c).labelFont(kMediumFontTheme12)];
    self.tableView.tableHeaderView = headerView;
    [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:self.tableView RefreshBlock:^{
        self.schoolService.itemPageModel.pagination.currentPage = 1;
        [self getMainData];
    }];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.schoolService.itemPageModel.pagination.currentPage++;
        [self getMainData];
    }];
    [self.view addSubview:self.tableView];
}

- (void)getMainData {
    [self.schoolService getSchoolDataWithLearnType:self.schoolType Complete:^{
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
        [self.tableView showNodataView:self.schoolService.tableViewDataArray.count == 0 offsetY:0 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.schoolService.itemPageModel];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.schoolService.tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWSchoolModel *model = (QHWSchoolModel *)self.schoolService.tableViewDataArray[indexPath.row];
    QSchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QSchoolTableViewCell.class)];
    [cell.bkgImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.coverPath)]];
    cell.titleLabel.text = model.title;
    cell.countLabel.text = kFormat(@"%ld人观看", model.browseCount);
    cell.playImageView.hidden = model.fileType == 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWSchoolModel *model = (QHWSchoolModel *)self.schoolService.tableViewDataArray[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForQSchoolDetailWithSchoolId:model.id];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (QSchoolService *)schoolService {
    if (!_schoolService) {
        _schoolService = QSchoolService.new;
    }
    return _schoolService;
}

@end

@implementation QSchoolTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.bkgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(160);
        }];
        [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.center.mas_equalTo(self.bkgImgView);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bkgImgView.mas_right).offset(10);
            make.right.mas_equalTo(-10);
            make.top.equalTo(self.bkgImgView.mas_top).offset(2);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(-10);
            make.bottom.equalTo(self.bkgImgView.mas_bottom).offset(-2);
        }];
    }
    return self;
}

#pragma mark ------------UI-------------
- (UIImageView *)bkgImgView {
    if (!_bkgImgView) {
        _bkgImgView = UIImageView.ivInit().ivBkgColor(kColorThemeeee).ivCornerRadius(5);
        [self.contentView addSubview:_bkgImgView];
    }
    return _bkgImgView;
}

- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = UIImageView.ivInit().ivImage(kImageMake(@"video_play"));
        _playImageView.hidden = YES;
        [self.bkgImgView addSubview:_playImageView];
    }
    return _playImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelFont(kMediumFontTheme14).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(3);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorThemea4abb3);
        [self.contentView addSubview:_countLabel];
    }
    return _countLabel;
}

@end

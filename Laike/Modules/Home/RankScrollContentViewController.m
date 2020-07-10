//
//  RankScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RankScrollContentViewController.h"
#import "QHWSystemService.h"
#import "UserModel.h"

@interface RankScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) QHWSystemService *systemService;
@property (nonatomic, strong) RankTableHeaderView *rankTableHeaderView;

@end

@implementation RankScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-180-48) Style:UITableViewStylePlain Object:self];
    self.tableView.rowHeight = 70;
    [self.tableView registerClass:RankTableViewCell.class forCellReuseIdentifier:NSStringFromClass(RankTableViewCell.class)];
    if (self.rankType == 1) {
        self.tableView.tableHeaderView = self.rankTableHeaderView;
        UserModel *user = UserModel.shareUser;
        self.rankTableHeaderView.rankValueLabel.text = kFormat(@"%ld", self.systemService.myRanking);
        [self.rankTableHeaderView.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(user.headPath)]];
        self.rankTableHeaderView.nameLabel.text = user.realName;
        self.rankTableHeaderView.likeLabel.text = kFormat(@"%ld", user.likeCount);
    }
    [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:self.tableView RefreshBlock:^{
        self.systemService.itemPageModel.pagination.currentPage = 1;
        [self getMainData];
    }];
//    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
//        self.systemService.itemPageModel.pagination.currentPage++;
//        [self getMainData];
//    }];
    [self.view addSubview:self.tableView];
}

- (void)getMainData {
    [self.systemService getLikeRankRequestWithSubjectType:self.rankType Complete: ^{
        [self.tableView reloadData];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.systemService.itemPageModel];
        [self.tableView showNodataView:self.systemService.consultantArray.count == 0 offsetY:228 button:nil];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.systemService.consultantArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(RankTableViewCell.class)];
    QHWConsultantModel *model = self.systemService.consultantArray[indexPath.row];
    cell.rankLabel.hidden = indexPath.row < 3;
    cell.rankImgView.hidden = indexPath.row >= 3;
    cell.rankLabel.text = kFormat(@"%ld", indexPath.row+1);
    cell.rankImgView.image = kImageMake(kFormat(@"rank_%ld", indexPath.row+1));
    [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)]];
    cell.nameLabel.text = model.name;
    cell.sloganLabel.text = model.slogan ?: @"暂无";
    cell.likeLabel.text = kFormat(@"%ld", model.likeCount);
    return cell;
}

- (RankTableHeaderView *)rankTableHeaderView {
    if (!_rankTableHeaderView) {
        _rankTableHeaderView = [[RankTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    }
    return _rankTableHeaderView;
}

- (QHWSystemService *)systemService {
    if (!_systemService) {
        _systemService = QHWSystemService.new;
    }
    return _systemService;
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

@implementation RankTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.rankKeyLabel = UILabel.labelFrame(CGRectMake(0, 25, (self.width-100)/2.0, 20)).labelText(@"排名").labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentCenter);
        [self addSubview:self.rankKeyLabel];
        self.rankValueLabel = UILabel.labelFrame(CGRectMake(0, self.rankKeyLabel.bottom+5, self.rankKeyLabel.width, 25)).labelFont(kMediumFontTheme18).labelTitleColor(kColorThemeff7919).labelTextAlignment(NSTextAlignmentCenter);
        [self addSubview:self.rankValueLabel];
        
        
        _avatarImgView = UIImageView.ivFrame(CGRectMake(self.rankKeyLabel.right + 30, 20, 40, 40)).ivCornerRadius(20).ivBorderColor(kColorThemeeee);
        [self addSubview:_avatarImgView];
        _nameLabel = UILabel.labelFrame(CGRectMake(self.rankKeyLabel.right, _avatarImgView.bottom+5, 100, 20)).labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentCenter);
        [self addSubview:_nameLabel];
        
        self.likeNameLabel = UILabel.labelFrame(CGRectMake(self.avatarImgView.right+30, self.rankKeyLabel.y, self.rankKeyLabel.width, 20)).labelText(@"人气").labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentCenter);
        [self addSubview:self.likeNameLabel];
        self.likeLabel = UILabel.labelFrame(CGRectMake(self.likeNameLabel.left, self.rankValueLabel.y, self.rankKeyLabel.width, 25)).labelFont(kMediumFontTheme18).labelTitleColor(kColorThemeff7919).labelTextAlignment(NSTextAlignmentCenter);
        [self addSubview:self.likeLabel];
    }
    return self;
}

@end

@implementation RankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.rankImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rankImgView.mas_right).offset(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [self.likeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.contentView);
        }];
        [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.likeNameLabel.mas_left);
            make.centerY.equalTo(self.contentView);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarImgView.mas_right).offset(15);
            make.top.equalTo(self.avatarImgView.mas_top).offset(5);
            make.right.equalTo(self.likeLabel.mas_left).offset(5);
        }];
        [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
            make.right.equalTo(self.likeLabel.mas_left).offset(-5);
        }];
    }
    return self;
}

#pragma mark ------------UI-------------
- (UIImageView *)rankImgView {
    if (!_rankImgView) {
        _rankImgView = UIImageView.ivInit();
        [self.contentView addSubview:_rankImgView];
    }
    return _rankImgView;
}

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = UIImageView.ivInit().ivCornerRadius(25).ivBorderColor(kColorThemeeee);
        [self.contentView addSubview:_avatarImgView];
    }
    return _avatarImgView;
}

- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme21a8ff).labelBkgColor(kColorFromHexString(@"bee6ff")).labelTextAlignment(NSTextAlignmentCenter).labelCornerRadius(12.5);
        [self.contentView addSubview:_rankLabel];
    }
    return _rankLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorTheme21a8ff);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)sloganLabel {
    if (!_sloganLabel) {
        _sloganLabel = UILabel.labelInit().labelFont(kFontTheme12).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(2);
        [self.contentView addSubview:_sloganLabel];
    }
    return _sloganLabel;
}

- (UILabel *)likeNameLabel {
    if (!_likeNameLabel) {
        _likeNameLabel = UILabel.labelInit().labelFont(kFontTheme12).labelText(@"人气").labelTitleColor(kColorThemea4abb3);
        [_likeNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:_likeNameLabel];
    }
    return _likeNameLabel;
}

- (UILabel *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = UILabel.labelInit().labelFont(kMediumFontTheme18).labelTitleColor(kColorThemeff7919).labelTextAlignment(NSTextAlignmentRight);
        [self.contentView addSubview:_likeLabel];
    }
    return _likeLabel;
}

@end

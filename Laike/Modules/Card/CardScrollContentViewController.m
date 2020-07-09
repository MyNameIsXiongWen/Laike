//
//  CardScrollContentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CardScrollContentViewController.h"
#import "QHWGeneralTableViewCell.h"
#import "RelatedToMeTableViewCell.h"
#import "QHWBaseCellProtocol.h"
#import "QHWBaseModel.h"
#import "CardService.h"
#import "VisitorDetailViewController.h"
#import "CTMediator+ViewController.h"

@interface CardScrollContentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CardService *cardService;

@end

@implementation CardScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addTableView {
    self.tableView = [UICreateView initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopBarHeight-90-48) Style:UITableViewStylePlain Object:self];
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:QHWGeneralTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QHWGeneralTableViewCell.class)];
    [self.tableView registerClass:VisitorTableViewCell.class forCellReuseIdentifier:NSStringFromClass(VisitorTableViewCell.class)];
    [self.tableView registerClass:RelatedToMeTableViewCell.class forCellReuseIdentifier:NSStringFromClass(RelatedToMeTableViewCell.class)];
    [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:self.tableView RefreshBlock:^{
        self.cardService.itemPageModel.pagination.currentPage = 1;
        [self getMainData];
    }];
    [QHWRefreshManager.sharedInstance normalFooterWithScrollView:self.tableView RefreshBlock:^{
        self.cardService.itemPageModel.pagination.currentPage++;
        [self getMainData];
    }];
    [self.view addSubview:self.tableView];
}

- (void)getMainData {
    [self.cardService getCardListDataRequestWithComplete:^{
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
        [self.tableView showNodataView:self.cardService.tableViewDataArray.count == 0 offsetY:0 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.cardService.itemPageModel];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardService.tableViewDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.cardService.tableViewDataArray[indexPath.row];
    UITableViewCell <QHWBaseCellProtocol>*cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    [cell configCellData:model.data];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cardType == 1) {
        CardModel *model = (CardModel *)self.cardService.tableViewDataArray[indexPath.row].data;
        VisitorDetailViewController *vc = VisitorDetailViewController.new;
        vc.userId = model.id;
        [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
    } else if (self.cardType == 2) {
        CardModel *model = (CardModel *)self.cardService.tableViewDataArray[indexPath.row].data;
        [CTMediator.sharedInstance CTMediator_viewControllerForCommunityDetailWithCommunityId:model.businessId CommunityType:2];
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

- (CardService *)cardService {
    if (!_cardService) {
        _cardService = CardService.new;
        _cardService.cardType = self.cardType;
    }
    return _cardService;
}

@end

@implementation VisitorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerY.equalTo(self);
        }];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerY.equalTo(self);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftImageView.mas_right).offset(10);
            make.top.equalTo(self.leftImageView.mas_top).offset(5);
        }];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.equalTo(self.titleLabel.mas_top);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.right.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)configCellData:(id)data {
    CardModel *model = (CardModel *)data;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)]];
    self.titleLabel.text = model.nickname;
    if (model.cardType == 1) {
        self.subTitleLabel.text = model.lastTime;
        NSString *browse = kFormat(@"访问%ld次", model.browseCount);
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:browse];
        [attr addAttributes:@{NSForegroundColorAttributeName: kColorThemefb4d56} range:[browse rangeOfString:kFormat(@"%ld", model.browseCount)]];
        self.detailLabel.attributedText = attr;
    } else {
        self.subTitleLabel.text = model.modifyTime;
        self.rightImageView.hidden = NO;
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.coverPath)]];
    }
}

#pragma mark ------------UI-------------
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = UIImageView.ivInit().ivImage(kImageMake(@"arrow_right_gray"));
        [self.contentView addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = UIImageView.ivInit().ivCornerRadius(25);
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = UIImageView.ivInit();
        _rightImageView.hidden = YES;
        [self.contentView addSubview:_rightImageView];
    }
    return _rightImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelInit().labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme14);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme12);
        [self.contentView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = UILabel.labelInit().labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme14);
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewInit().bkgColor(kColorThemeeee);
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end

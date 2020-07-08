//
//  VisitorDetailViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/4.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "VisitorDetailViewController.h"
#import "VistorDetailHeaderView.h"
#import "CardService.h"
#import "CRMTrackCell.h"

@interface VisitorDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VistorDetailHeaderView *tableHeaderView;
@property (nonatomic, strong) VisitorDetailBottomView *btmView;
@property (nonatomic, strong) CardService *cardService;

@end

@implementation VisitorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"访客足迹";
    [self.view addSubview:self.btmView];
}

- (void)getMainData {
    [self.cardService getCardDetailInfoRequestWithComplete:^{
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        self.tableHeaderView.cardModel = self.cardService.cardDetailModel;
        [self.tableView reloadData];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.cardService.itemPageModel];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardService.tableViewDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardModel *model = (CardModel *)self.cardService.tableViewDataArray[indexPath.row];
    return model.businessHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardModel *model = (CardModel *)self.cardService.tableViewDataArray[indexPath.row];
    CRMTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CRMTrackCell.class)];
    cell.titleLabel.text = kFormat(@"访问了你的%@", model.businessName);
    cell.timeLabel.text = model.createTime;
    cell.contentLabel.text = model.title;
    cell.topLine.hidden = indexPath.row == 0;
    cell.showArrowImgView = YES;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight-kBottomDangerHeight-75) Style:UITableViewStylePlain Object:self];
        _tableView.tableHeaderView = self.tableHeaderView;
        [_tableView registerClass:CRMTrackCell.class forCellReuseIdentifier:NSStringFromClass(CRMTrackCell.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            self.cardService.itemPageModel.pagination.currentPage = 1;
            [self getMainData];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            self.cardService.itemPageModel.pagination.currentPage++;
            [self getMainData];
        }];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
    }
    return _tableView;
}

- (VistorDetailHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[VistorDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 180)];
    }
    return _tableHeaderView;
}

- (VisitorDetailBottomView *)btmView {
    if (!_btmView) {
        _btmView = [[VisitorDetailBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kBottomDangerHeight-75, kScreenW, 75)];
        
    }
    return _btmView;
}

- (CardService *)cardService {
    if (!_cardService) {
        _cardService = CardService.new;
        _cardService.userId = self.userId;
    }
    return _cardService;
}

@end

@implementation VisitorDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contactBtn = UIButton.btnFrame(CGRectMake(15, 15, kScreenW-30, 45)).btnTitle(@"微聊客户").btnFont(kFontTheme18).btnTitleColor(kColorThemefff).btnBkgColor(kColorTheme21a8ff).btnCornerRadius(5).btnAction(self, @selector(clickContactBtn));
        [self addSubview:self.contactBtn];
        
        [self addSubview:UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return self;
}

- (void)clickContactBtn {
    
}

@end

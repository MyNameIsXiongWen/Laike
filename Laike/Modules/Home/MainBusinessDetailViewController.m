//
//  MainBusinessDetailViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/26.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MainBusinessDetailViewController.h"
#import "MainBusinessDetailTableHeaderView.h"
#import "MainBusinessDetailBottomView.h"
#import "QHWTabScrollView.h"
#import "MainBusinessDetailService.h"
#import "QHWBaseCellProtocol.h"
#import "CTMediator+ViewController.h"
#import "QHWHouseModel.h"
#import "QHWStudyModel.h"
#import "QHWMigrationModel.h"
#import "QHWStudentModel.h"
#import "QHWConsultantModel.h"
#import "QHWShareView.h"
#import "UserModel.h"

@interface MainBusinessDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QHWTabScrollView *tabScrollView;
@property (nonatomic, strong) MainBusinessDetailTableHeaderView *tableHeaderView;
@property (nonatomic, strong) MainBusinessDetailBottomView *bottomView;

@property (nonatomic, assign) BOOL clickTagScroll;
@property (nonatomic, strong) MainBusinessDetailService *detailService;

@end

@implementation MainBusinessDetailViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationReloadRichText object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    switch (self.businessType) {
        case 1:
            self.kNavigationView.title = @"海外房产";
            break;
        case 2:
            self.kNavigationView.title = @"海外游学";
            break;
        case 3:
            self.kNavigationView.title = @"海外移民";
            break;
        case 4:
            self.kNavigationView.title = @"海外留学";
            break;
        case 102001:
            self.kNavigationView.title = @"海外医疗";
            break;
            
        default:
            break;
    }
    [self.kNavigationView.rightBtn setImage:kImageMake(@"global_share") forState:0];
    [self.view addSubview:self.bottomView];
    [self getDetailInfoRequest];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadRichTextCellNotification:) name:kNotificationReloadRichText object:nil];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    QHWShareView *shareView = [[QHWShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 220) dict:@{@"detailModel": self.detailService.detailModel, @"shareType": @(ShareTypeMainBusiness)}];
    [shareView show];
}

- (void)getDetailInfoRequest {
    [self.detailService getMainBusinessDetailInfoRequest:^(BOOL status) {
        if (status) {
            self.tableHeaderView.businessType = self.businessType;
            self.tableHeaderView.detailModel = self.detailService.detailModel;
            self.tableHeaderView.height = self.detailService.headerViewHeight;
            [self.tableView reloadData];
            self.tabScrollView.dataArray = self.detailService.tabDataArray;
        }
    }];
}

#pragma mark ------------Notification-------------
- (void)reloadRichTextCellNotification:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    NSString *identifier = dic[@"identifier"];
    [self.detailService.tableViewDataArray enumerateObjectsUsingBlock:^(QHWBaseModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = (NSArray *)model.data;
        for (int i=0; i<array.count; i++) {
            id object = array[i];
            if ([object isKindOfClass:QHWBaseModel.class]) {
                QHWBaseModel *subBaseModel = (QHWBaseModel *)object;
                if ([identifier isEqualToString:subBaseModel.identifier]) {
                    subBaseModel.height = [dic[@"height"] floatValue];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:idx]] withRowAnimation:UITableViewRowAnimationNone];
                    *stop = YES;
                }
            } else if ([object isKindOfClass:NSDictionary.class]) {
                NSDictionary *subDic = (NSDictionary *)object;
                if ([identifier isEqualToString:subDic[@"identifier"]]) {
                    model.height = [dic[@"height"] floatValue];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:idx]] withRowAnimation:UITableViewRowAnimationNone];
                    *stop = YES;
                }
            }
        }
    }];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.detailService.detailModel) {
        CGFloat offsizeY = scrollView.contentOffset.y;
        CGFloat paramY = [self getSectionHeaderYWith:0];//第一section的纵坐标
        self.tabScrollView.hidden = offsizeY < paramY;
        if (offsizeY >= paramY && !self.clickTagScroll) {
            for (int i=0; i<self.detailService.tableViewDataArray.count; i++) {
                CGFloat currentSectionY = [self getSectionHeaderYWith:i];
                CGFloat nextSectionY = [self getSectionHeaderYWith:i+1];
                if (offsizeY >= currentSectionY && offsizeY < nextSectionY) {
                    [self.tabScrollView scrollToIndex:i];
                    break;
                }
            }
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.clickTagScroll = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.clickTagScroll = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.clickTagScroll = NO;
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.detailService.tableViewDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QHWBaseModel *baseModel = self.detailService.tableViewDataArray[section];
    NSArray *array = (NSArray *)baseModel.data;
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *baseModel = self.detailService.tableViewDataArray[indexPath.section];
    id object = baseModel.data[indexPath.row];
    if ([object isKindOfClass:QHWBaseModel.class]) {
        QHWBaseModel *subBaseModel = (QHWBaseModel *)object;
        return subBaseModel.height;
    }
    return baseModel.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *model = self.detailService.tableViewDataArray[indexPath.section];
    UITableViewCell<QHWBaseCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:model.identifier];
    [cell configCellData:model.data[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    QHWBaseModel *baseModel = self.detailService.tableViewDataArray[section];
//    return baseModel.footerTitle ? 90 : CGFLOAT_MIN;
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    __block QHWBaseModel *baseModel = self.detailService.tableViewDataArray[section];
    MainBusinessDetailSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(MainBusinessDetailSectionHeaderView.class)];
    headerView.titleLabel.text = baseModel.headerTitle;
    headerView.moreBtn.hidden = !baseModel.showMoreBtn;
    headerView.clickMoreBtnBlock = ^{
        if ([baseModel.identifier isEqualToString:@"ActivityTableViewCell"]) {
//            [CTMediator.sharedInstance CTMediator_viewControllerForActivityListWithMerchantId:self.detailService.detailModel.merchantId];
        }
    };
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    QHWBaseModel *baseModel = self.detailService.tableViewDataArray[section];
//    if (baseModel.footerTitle) {
//        MainBusinessDetailSectionFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(MainBusinessDetailSectionFooterView.class)];
//        [footerView.btn setTitle:baseModel.footerTitle forState:0];
//        WEAKSELF
//        footerView.clickBtnBlock = ^{
//            [QHWSystemService showLabelAlertViewWithTitle:@"预约咨询" Img:@"" MerchantId:self.detailService.detailModel.merchantId IndustryId:weakSelf.businessType BusinessId:weakSelf.businessId DescribeCode:6 PositionCode:5];
//        };
//        return footerView;
//    }
    return UIView.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWBaseModel *baseModel = self.detailService.tableViewDataArray[indexPath.section];
    NSArray *array = (NSArray *)baseModel.data;
    if (indexPath.row < array.count) {
        [CTMediator.sharedInstance performTarget:self action:[NSString stringWithFormat:@"click%@:", baseModel.identifier] params:@{@"indexPath": indexPath}];
    }
}

- (void)clickConsultantTableCell:(NSDictionary *)params {
    NSIndexPath *indexPath = params[@"indexPath"];
    QHWBaseModel *baseModel = self.detailService.tableViewDataArray[indexPath.section];
    NSArray *array = (NSArray *)baseModel.data;
    QHWConsultantModel *model = array[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:model.id UserType:2 BusinessType:self.businessType];
}

- (void)clickQHWHouseTableViewCell:(NSDictionary *)params {
    NSIndexPath *indexPath = params[@"indexPath"];
    QHWBaseModel *baseModel = self.detailService.tableViewDataArray[indexPath.section];
    NSArray *array = (NSArray *)baseModel.data;
    QHWHouseModel *model = array[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForMainBusinessDetailWithBusinessType:1 BusinessId:model.id IsDistribution:self.isDistribution];
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
        _tabScrollView = [[QHWTabScrollView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 44)];
        _tabScrollView.backgroundColor = kColorThemefff;
        _tabScrollView.hidden = YES;
        _tabScrollView.itemWidthType = ItemWidthTypeAdaptive;
        _tabScrollView.hideIndicatorView = NO;
        _tabScrollView.itemSelectedColor = kColorTheme000;
        _tabScrollView.itemUnselectedColor = kColorThemea4abb3;
        _tabScrollView.itemSelectedBackgroundColor = kColorThemefff;
        _tabScrollView.itemUnselectedBackgroundColor = kColorThemefff;
        WEAKSELF
        _tabScrollView.clickTagBlock = ^(NSInteger index) {
            weakSelf.clickTagScroll = YES;
            CGFloat y = [weakSelf getSectionHeaderYWith:index];
            [weakSelf.tableView setContentOffset:CGPointMake(0, y) animated:YES];
        };
        [self.view addSubview:_tabScrollView];
    }
    return _tabScrollView;
}

- (CGFloat)getSectionHeaderYWith:(NSInteger)section {
    if (section < self.tableView.numberOfSections) {
        return [self.tableView rectForHeaderInSection:section].origin.y - 44;
    }
    return self.tableView.contentSize.height-self.tableView.height;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH - kTopBarHeight - kBottomDangerHeight - self.bottomView.height) Style:UITableViewStyleGrouped Object:self];
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.tableHeaderView = self.tableHeaderView;
        for (NSString *identifier in self.detailService.tableViewCellArray) {
            [_tableView registerClass:NSClassFromString(identifier) forCellReuseIdentifier:identifier];
        }
        [_tableView registerClass:MainBusinessDetailSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(MainBusinessDetailSectionHeaderView.class)];
        [_tableView registerClass:MainBusinessDetailSectionFooterView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(MainBusinessDetailSectionFooterView.class)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (MainBusinessDetailTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MainBusinessDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 600)];
    }
    return _tableHeaderView;
}

- (MainBusinessDetailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[MainBusinessDetailBottomView alloc] initWithFrame:CGRectMake(0, kScreenH-kBottomDangerHeight-75, kScreenW, 75)];
        _bottomView.rightAnotherOperationButton.hidden = !self.isDistribution;
        _bottomView.rightOperationButton.width = self.isDistribution ? 100 : 210;
        _bottomView.rightOperationButton.btnTitle(self.isDistribution ? @"开单助理" : @"微信推广获客").btnFont(self.isDistribution ? kFontTheme14 : kFontTheme18);
        WEAKSELF
        _bottomView.rightOperationBlock = ^{
            if (weakSelf.isDistribution) {
                kCallTel(weakSelf.detailService.detailModel.serviceHotline);
            } else {
                [weakSelf rightNavBtnAction:nil];
            }
        };
        _bottomView.rightAnotherOperationBlock = ^{
            if (UserModel.shareUser.bindStatus == 2) {
                [CTMediator.sharedInstance CTMediator_viewControllerForBindCompany];
                return;
            }
            [CTMediator.sharedInstance CTMediator_viewControllerForBookAppointmentWithBusinessId:weakSelf.businessId BusinessName:weakSelf.detailService.detailModel.name BusinessType:weakSelf.businessType];
        };
    }
    return _bottomView;
}

- (MainBusinessDetailService *)detailService {
    if (!_detailService) {
        _detailService = MainBusinessDetailService.new;
        _detailService.businessType = self.businessType;
        _detailService.businessId = self.businessId;
        _detailService.isDistribution = self.isDistribution;
    }
    return _detailService;
}

@end

@implementation MainBusinessDetailSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *boldLine = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 10)).bkgColor(kColorThemef5f5f5);
        [self.contentView addSubview:boldLine];
        
        UIView *redView = UIView.viewFrame(CGRectMake(15, 23, 3, 19)).bkgColor(kColorThemefb4d56);
        [self.contentView addSubview:redView];
        
        self.titleLabel = UILabel.labelFrame(CGRectMake(redView.right+10, 10, 200, 45)).labelFont([UIFont systemFontOfSize:18 weight:UIFontWeightMedium]).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:self.titleLabel];
        
        self.moreBtn = UIButton.btnFrame(CGRectMake(kScreenW-100, 10, 100, 45)).btnTitle(@"查看更多").btnFont(kFontTheme13).btnTitleColor(kColorTheme9399a5).btnAction(self, @selector(clickMoreBtn));
        self.moreBtn.hidden = YES;
        [self.contentView addSubview:self.moreBtn];
        
        UIImageView *arrow = UIImageView.ivFrame(CGRectMake(100-22, 16, 7, 12)).ivImage(kImageMake(@"arrow_right_gray"));
        [self.moreBtn addSubview:arrow];
        
        UIView *thinLine = UIView.viewFrame(CGRectMake(0, 54.5, kScreenW, 0.5)).bkgColor(kColorThemeeee);
        [self.contentView addSubview:thinLine];
    }
    return self;
}

- (void)clickMoreBtn {
    if (self.clickMoreBtnBlock) {
        self.clickMoreBtnBlock();
    }
}

@end

@implementation MainBusinessDetailSectionFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        self.btn = UIButton.btnFrame(CGRectMake(15, 20, kScreenW-30, 50)).btnTitleColor(kColorThemeed2530).btnBkgColor(kColor(251.0, 77.0, 86.0, 0.5)).btnFont([UIFont systemFontOfSize:16 weight:UIFontWeightMedium]).btnCornerRadius(5).btnAction(self, @selector(clickBtn));
        [self.contentView addSubview:self.btn];
    }
    return self;
}

- (void)clickBtn {
    if (self.clickBtnBlock) {
        self.clickBtnBlock();
    }
}

@end

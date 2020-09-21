//
//  DistributionSearchViewController.m
//  Laike
//
//  Created by xiaobu on 2020/9/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "DistributionSearchViewController.h"
#import "SearchTopView.h"
#import "QHWSystemService.h"
#import "CTMediator+ViewController.h"

@interface DistributionSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *searchContentTableView;
@property (nonatomic, strong) SearchTopView *searchTopView;
@property (nonatomic, strong) QHWSystemService *service;
@property (nonatomic, assign) NSInteger businessType;
@property (nonatomic, strong) NSMutableArray *historyArray;

@end

@implementation DistributionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.hidden = YES;
    self.businessType = 1;
    [self.view addSubview:self.searchTopView];
    [self unarchiveSearchHistoryData];
//    [self getHotSearchDataRequest];
}

- (void)unarchiveSearchHistoryData {
    self.historyArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getHistoryPath]];
    [self.tableView reloadData];
}

- (void)archiveSearchHistoryData {
    BOOL success = [NSKeyedArchiver archiveRootObject:self.historyArray toFile:[self getHistoryPath]];
    NSLog(@"archiveObject====%d", success);
}

- (NSString *)getHistoryPath {
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    switch (self.businessType) {
        case 1:
            return [docPath.firstObject stringByAppendingPathComponent:@"house.plist"];
            break;
            
        case 2:
            return [docPath.firstObject stringByAppendingPathComponent:@"study.plist"];
            break;
            
        case 3:
            return [docPath.firstObject stringByAppendingPathComponent:@"migration.plist"];
            break;
 
        case 4:
            return [docPath.firstObject stringByAppendingPathComponent:@"student.plist"];
            break;
            
        default:
            return [docPath.firstObject stringByAppendingPathComponent:@"treatment.plist"];
            break;
    }
}

- (void)getHotSearchDataRequest {
    [self.service getHotSearchDataRequestWithBusinessPage:self.businessType Complete:^{
        [self.tableView reloadData];
    }];
}

- (void)getSearchResultDataRequestWith:(NSString *)content {
    if (content.length == 0) {
        self.service.searchResultArray = NSArray.array;
        self.searchContentTableView.hidden = YES;
        return;
    }
    [self.service getSearchContentDataRequestWithBusinessPage:self.businessType Content:content Complete:^{
        [self.searchContentTableView reloadData];
        if (self.searchTopView.searchTextField.text.length == 0) {
            self.searchContentTableView.hidden = YES;
        } else {
            self.searchContentTableView.hidden = self.service.searchResultArray.count == 0;
        }
    }];
}

#pragma mark ------------UITableView Delegate-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 111) {
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 111) {
//        if (section == 0) {
//            return self.service.hotSearchArray.count;
//        }
        return self.historyArray.count;
    }
    return self.service.searchResultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchContentModel *model;
    if (tableView.tag == 111) {
//        if (indexPath.section == 0) {
//            model = self.service.hotSearchArray[indexPath.row];
//        } else {
            model = self.historyArray[indexPath.row];
//        }
    } else {
        model = self.service.searchResultArray[indexPath.row];
    }
    return model.contentHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(SearchContentCell.class)];
    SearchContentModel *model;
    if (tableView.tag == 111) {
//        if (indexPath.section == 0) {
//            model = self.service.hotSearchArray[indexPath.row];
//            cell.bkgView.backgroundColor = kColorThemefff;
//        } else {
            model = self.historyArray[indexPath.row];
            cell.bkgView.backgroundColor = kColorThemef5f5f5;
//        }
    } else {
        model = self.service.searchResultArray[indexPath.row];
        cell.bkgView.backgroundColor = kColorThemef5f5f5;
    }
    cell.contentLabel.text = model.name;
    [cell updateContentLabelConstraintsWidth:model.contentWidth];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 111) {
        SearchHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(SearchHeaderView.class)];
//        headerView.titleLabel.text = @[@"热门搜索", @"历史记录"][section];
        headerView.titleLabel.text = @"历史记录";
        WEAKSELF
        headerView.clickDeleteBlock = ^{
            [weakSelf.historyArray removeAllObjects];
            [weakSelf archiveSearchHistoryData];
        };
        return headerView;
    }
    return UIView.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchContentModel *model;
    if (tableView.tag == 111) {
//        if (indexPath.section == 0) {
//            model = self.service.hotSearchArray[indexPath.row];
//        } else {
            model = self.historyArray[indexPath.row];
//        }
    } else {
        model = self.service.searchResultArray[indexPath.row];
    }
    [self.historyArray enumerateObjectsUsingBlock:^(SearchContentModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.id isEqualToString:model.id]) {
            [self.historyArray removeObject:obj];
            *stop = YES;
        }
    }];
    [self.historyArray insertObject:model atIndex:0];
    [self archiveSearchHistoryData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [CTMediator.sharedInstance CTMediator_viewControllerForMainBusinessDetailWithBusinessType:self.businessType BusinessId:model.id];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (SearchTopView *)searchTopView {
    if (!_searchTopView) {
        _searchTopView = [[SearchTopView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, 44)];
        WEAKSELF
        _searchTopView.clickProductTypeBlock = ^(NSInteger businessType) {
            if (weakSelf.businessType != businessType) {
                weakSelf.businessType = businessType;
                [weakSelf unarchiveSearchHistoryData];
//                [weakSelf getHotSearchDataRequest];
            }
        };
        _searchTopView.textFieldValueChangedBlock = ^(NSString * _Nonnull content) {
            [weakSelf getSearchResultDataRequestWith:content];
        };
    }
    return _searchTopView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.tag = 111;
        _tableView.sectionHeaderHeight = 60;
        _tableView.backgroundColor = kColorThemef5f5f5;
        [_tableView registerClass:SearchContentCell.class forCellReuseIdentifier:NSStringFromClass(SearchContentCell.class)];
        [_tableView registerClass:SearchHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(SearchHeaderView.class)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UITableView *)searchContentTableView {
    if (!_searchContentTableView) {
        _searchContentTableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _searchContentTableView.tag = 222;
        _searchContentTableView.backgroundColor = kColorThemef5f5f5;
        [_searchContentTableView registerClass:SearchContentCell.class forCellReuseIdentifier:NSStringFromClass(SearchContentCell.class)];
        [self.view addSubview:_searchContentTableView];
    }
    return _searchContentTableView;
}

- (QHWSystemService *)service {
    if (!_service) {
        _service = QHWSystemService.new;
    }
    return _service;
}

- (NSMutableArray *)historyArray {
    if (!_historyArray) {
        _historyArray = NSMutableArray.array;
    }
    return _historyArray;
}

@end

@implementation SearchHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kColorThemef5f5f5;
        self.titleLabel = UILabel.labelFrame(CGRectMake(15, 20, kScreenW-70, 20)).labelFont(kMediumFontTheme15).labelTitleColor(kColorTheme2a303c);
        [self.contentView addSubview:self.titleLabel];
        self.deleteBtn = UIButton.btnFrame(CGRectMake(kScreenW-55, 0, 55, 60)).btnAction(self, @selector(clickDeleteBtn));
        [self.contentView addSubview:self.deleteBtn];
    }
    return self;
}

- (void)clickDeleteBtn {
    if (self.clickDeleteBlock) {
        self.clickDeleteBlock();
    }
}

@end

@implementation SearchContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kColorThemef5f5f5;
        self.bkgView = UIView.viewInit().bkgColor(kColorThemefff).cornerRadius(10);
        [self.contentView addSubview:self.bkgView];
        self.contentLabel = UILabel.labelInit().labelFont(kFontTheme14).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(0);
        [self.bkgView addSubview:self.contentLabel];
        [self.bkgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(kScreenW-30);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.centerY.equalTo(self.bkgView.mas_centerY);
        }];
    }
    return self;
}

- (void)updateContentLabelConstraintsWidth:(CGFloat)width {
    [self.bkgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width+20);
    }];
}
@end

//
//  CRMSearchViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/7.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMSearchViewController.h"
#import "CRMTableViewCell.h"
#import "CRMService.h"
#import "CTMediator+ViewController.h"

@interface CRMSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MessageSearchTopView *searchTopView;
@property (nonatomic, strong) CRMService *crmService;
@property (nonatomic, strong) NSMutableDictionary *conditionDic;

@end

@implementation CRMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.hidden = YES;
    [self.view addSubview:self.searchTopView];
}

- (void)getCRMListRequest {
    [self.crmService getCRMListDataRequestWithCondition:self.conditionDic Complete:^{
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
        [self.tableView showNodataView:self.crmService.crmArray.count == 0 offsetY:0 button:nil];
        [QHWRefreshManager.sharedInstance endRefreshWithScrollView:self.tableView PageModel:self.crmService.itemPageModel];
    }];
}

#pragma mark ------------UITableViewDelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.crmService.crmArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CRMTableViewCell.class)];
    CRMModel *model = self.crmService.crmArray[indexPath.row];
    if (model.headPath.length > 0) {
        [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)]];
    } else {
        cell.avatarImgView.image = [UIImage imageWithColor:kColorThemefff size:CGSizeMake(50, 50) text:model.realName textAttributes:@{NSForegroundColorAttributeName: kColorTheme21a8ff, NSFontAttributeName: kMediumFontTheme18} circular:YES];
    }
    cell.nameLabel.text = model.realName;
    if (model.industryNameArray.count == 0) {
        [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.avatarImgView.mas_top).offset(15);
        }];
    }
    [cell.tagView setTagWithTagArray:model.industryNameArray];
    [cell.convertBtn setTitle:@"写跟进" forState:0];
    cell.clickContactBlock = ^{
        kCallTel(model.mobileNumber);
    };
    cell.clickConvertBlock = ^{
        [CTMediator.sharedInstance CTMediator_viewControllerForAddTrackWithCustomerId:model.id];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMModel *model = self.crmService.crmArray[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForCRMDetailWithCustomerId:model.id];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (MessageSearchTopView *)searchTopView {
    if (!_searchTopView) {
        _searchTopView = [[MessageSearchTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kTopBarHeight)];
        _searchTopView.backgroundColor = kColorThemefff;
        _searchTopView.cancelBtn.backgroundColor = kColorThemefff;
        [_searchTopView.cancelBtn setTitleColor:kColorTheme21a8ff forState:0];
        _searchTopView.bkgView.backgroundColor = kColorThemef5f5f5;
        _searchTopView.searchTextField.placeholder = @"客户姓名、电话";
        [_searchTopView.searchTextField becomeFirstResponder];
        WEAKSELF
        _searchTopView.textFieldValueChangedBlock = ^(NSString * _Nonnull content) {
//            weakSelf.conditionDic[@"keyword"] = content;
//            weakSelf.crmService.itemPageModel.pagination.currentPage = 1;
//            [weakSelf getCRMListRequest];
        };
        _searchTopView.textFieldEndBlock = ^(NSString * _Nonnull content) {
            weakSelf.conditionDic[@"keyword"] = content;
            weakSelf.crmService.itemPageModel.pagination.currentPage = 1;
            [weakSelf getCRMListRequest];
        };
    }
    return _searchTopView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.rowHeight = 120;
        [_tableView registerClass:CRMTableViewCell.class forCellReuseIdentifier:NSStringFromClass(CRMTableViewCell.class)];
        [QHWRefreshManager.sharedInstance normalHeaderWithScrollView:_tableView RefreshBlock:^{
            self.crmService.itemPageModel.pagination.currentPage = 1;
            [self getMainData];
        }];
        [QHWRefreshManager.sharedInstance normalFooterWithScrollView:_tableView RefreshBlock:^{
            self.crmService.itemPageModel.pagination.currentPage++;
            [self getMainData];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (CRMService *)crmService {
    if (!_crmService) {
        _crmService = CRMService.new;
    }
    return _crmService;
}

- (NSMutableDictionary *)conditionDic {
    if (!_conditionDic) {
        _conditionDic = NSMutableDictionary.dictionary;
    }
    return _conditionDic;
}

@end

@implementation MessageSearchTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = kColorTheme21a8ff;
        self.bkgView = UIView.viewFrame(CGRectMake(15, kStatusBarHeight+6, kScreenW-80, 32)).bkgColor(kColorThemefff).cornerRadius(16);
        [self.bkgView addSubview:self.searchImgView];
        [self.bkgView addSubview:self.searchTextField];
        [self addSubview:self.bkgView];
        [self addSubview:self.cancelBtn];
    }
    return self;
}

- (void)clickCancelBtn {
    [self.getCurrentMethodCallerVC.navigationController popViewControllerAnimated:YES];
}

- (void)tfEditingChanged:(UITextField *)textField {
    if (self.textFieldValueChangedBlock) {
        self.textFieldValueChangedBlock(self.searchTextField.text);
    }
}

- (void)tfEditingEnd:(UITextField *)textField {
    if (self.textFieldEndBlock) {
        self.textFieldEndBlock(self.searchTextField.text);
    }
}

- (UIImageView *)searchImgView {
    if (!_searchImgView) {
        _searchImgView = UIImageView.ivFrame(CGRectMake(10, 8, 16, 16)).ivImage(kImageMake(@"global_search"));
    }
    return _searchImgView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = UIButton.btnFrame(CGRectMake(kScreenW-65, kStatusBarHeight+6, 65, 32)).btnTitle(@"取消").btnFont(kFontTheme14).btnTitleColor(kColorThemefff).btnBkgColor(kColorTheme21a8ff).btnAction(self, @selector(clickCancelBtn));
    }
    return _cancelBtn;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = UITextField.tfFrame(CGRectMake(self.searchImgView.right+10, 0, kScreenW-130, 32)).tfPlaceholder(@"试试搜索顾问名称、手机号、公司名称").tfFont(kFontTheme13);
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        [_searchTextField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [_searchTextField addTarget:self action:@selector(tfEditingEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    return _searchTextField;
}

@end

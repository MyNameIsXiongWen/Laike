//
//  MessageSearchViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/3.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MessageSearchViewController.h"
#import "CTMediator+ViewController.h"
#import "MessageTableViewCell.h"
#import "QHWConsultantModel.h"

@interface MessageSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MessageSearchTopView *searchTopView;
@property (nonatomic, strong) MessageSearchHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MessageSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.hidden = YES;
    [self.view addSubview:self.searchTopView];
}

- (void)getSearchResultDataRequestWith:(NSString *)content {
    if (content.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入搜索内容"];
        return;
    }
    [QHWHttpLoading show];
    [QHWHttpManager.sharedInstance QHW_POST:kConsultantList parameters:@{@"name": content} success:^(id responseObject) {
        self.dataArray = [NSArray yy_modelArrayWithClass:QHWConsultantModel.class json:responseObject[@"data"][@"list"]].mutableCopy;
        [self.tableView reloadData];
        [self.tableView showNodataView:self.dataArray.count == 0 offsetY:0 button:nil];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ------------UITableView Delegate-------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MessageTableViewCell.class)];
    QHWConsultantModel *model = self.dataArray[indexPath.row];
    [cell.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(model.headPath)]];
    cell.nameLabel.text = kFormat(@"%@  %@", model.name, model.mobileNumber);
    cell.contentLabel.text = model.companyName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QHWConsultantModel *model = self.dataArray[indexPath.row];
    [CTMediator.sharedInstance CTMediator_viewControllerForUserDetailWithUserId:model.id UserType:2 BusinessType:0];
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
        [_searchTopView.searchTextField becomeFirstResponder];
        WEAKSELF
        _searchTopView.textFieldValueChangedBlock = ^(NSString * _Nonnull content) {
            NSString *contentString = kFormat(@"搜索 %@", content);
            weakSelf.headerView.contentLabel.text = contentString;
            weakSelf.headerView.height = MAX(40, [contentString getHeightWithFont:kFontTheme16 constrainedToSize:CGSizeMake(kScreenW-105, CGFLOAT_MAX)])+50;
            if (content.length == 0) {
                weakSelf.tableView.tableHeaderView = nil;
            } else {
                weakSelf.tableView.tableHeaderView = weakSelf.headerView;
            }
        };
        _searchTopView.textFieldEndBlock = ^(NSString * _Nonnull content) {
            [weakSelf getSearchResultDataRequestWith:content];
        };
    }
    return _searchTopView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, kScreenH-kTopBarHeight) Style:UITableViewStylePlain Object:self];
        _tableView.rowHeight = 80;
        [_tableView registerClass:MessageTableViewCell.class forCellReuseIdentifier:NSStringFromClass(MessageTableViewCell.class)];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (MessageSearchHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MessageSearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 90)];
        WEAKSELF
        _headerView.tapSearchBlock = ^(NSString * _Nonnull content) {
            [weakSelf getSearchResultDataRequestWith:content];
        };
    }
    return _headerView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = NSMutableArray.array;
    }
    return _dataArray;
}

@end

@implementation MessageSearchTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = kColorThemefb4d56;
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
        _cancelBtn = UIButton.btnFrame(CGRectMake(kScreenW-65, kStatusBarHeight+6, 65, 32)).btnTitle(@"取消").btnFont(kFontTheme14).btnTitleColor(kColorThemefff).btnBkgColor(kColorThemefb4d56).btnAction(self, @selector(clickCancelBtn));
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

@implementation MessageSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelf)]];
        self.searchImgView = UIImageView.ivInit().ivImage(kImageMake(@"global_search")).ivBkgColor(kColorFromHexString(@"ffbf3b")).ivCornerRadius(25);
        self.searchImgView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.searchImgView];
        self.contentLabel = UILabel.labelInit().labelText(@"搜索 ").labelFont(kFontTheme16).labelTitleColor(kColorThemea4abb3).labelNumberOfLines(0);
        [self addSubview:self.contentLabel];
        UIView *line = UIView.viewInit().bkgColor(kColorThemef5f5f5);
        [self addSubview:line];
        [self.searchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.height.mas_equalTo(50);
            make.centerY.equalTo(self).offset(-5);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchImgView.mas_right).offset(15);
            make.right.mas_equalTo(-20);
            make.centerY.equalTo(self.searchImgView);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
    }
    return self;
}

- (void)clickSelf {
    if (self.tapSearchBlock) {
        self.tapSearchBlock([self.contentLabel.text substringFromIndex:3]);
    }
}

- (UIImageView *)searchImgView {
    if (!_searchImgView) {
        _searchImgView = UIImageView.ivFrame(CGRectMake(10, 8, 16, 16)).ivImage(kImageMake(@"global_search"));
    }
    return _searchImgView;
}

@end

//
//  SearchTopView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/1.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "SearchTopView.h"

@implementation SearchTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        UIView *bkgView = UIView.viewFrame(CGRectMake(15, 6, kScreenW-80, 32)).bkgColor(kColorThemeeee).cornerRadius(16);
        [bkgView addSubview:self.productBtn];
        [bkgView addSubview:self.searchTextField];
        [self addSubview:bkgView];
        [self addSubview:self.cancelBtn];
        self.businessType = 1;
    }
    return self;
}

- (void)clickProductBtn {
    BusinessTypeView *typeView = [[BusinessTypeView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 100)];
//    if (self.businessType == 102001) {
//        typeView.selectedIndex = 4;
//    } else {
//        typeView.selectedIndex = self.businessType-1;
//    }
    if (self.businessType == 3) {
        typeView.selectedIndex = 1;
    } else {
        typeView.selectedIndex = 0;
    }
    WEAKSELF
    typeView.didSelectItemBlock = ^(NSInteger index, NSString *title) {
//        if (index == 4) {
//            weakSelf.businessType = 102001;
//        } else {
//            weakSelf.businessType = index+1;
//        }
        if (index == 1) {
            weakSelf.businessType = 3;
        } else {
            weakSelf.businessType = 1;
        }
        if (weakSelf.clickProductTypeBlock) {
            weakSelf.clickProductTypeBlock(weakSelf.businessType);
        }
        [weakSelf.productBtn setTitle:title forState:0];
    };
    [typeView show];
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
    if (textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入搜索内容"];
    }
    [self tfEditingChanged:textField];
}

- (UIButton *)productBtn {
    if (!_productBtn) {
        _productBtn = UIButton.btnFrame(CGRectMake(0, 0, 65, 32)).btnTitle(@"房产").btnTitleColor(kColorThemea4abb3).btnFont(kFontTheme14).btnImage(kImageMake(@"global_down")).btnBkgColor(kColorThemee4e4e4).btnAction(self, @selector(clickProductBtn));
        _productBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        _productBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, -30);
    }
    return _productBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = UIButton.btnFrame(CGRectMake(kScreenW-65, 6, 65, 32)).btnTitle(@"取消").btnFont(kFontTheme14).btnTitleColor(kColorThemea4abb3).btnAction(self, @selector(clickCancelBtn));
    }
    return _cancelBtn;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = UITextField.tfFrame(CGRectMake(self.productBtn.right+10, 0, kScreenW-155, 32)).tfPlaceholder(@"输入搜索内容").tfFont(kFontTheme14);
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_searchTextField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [_searchTextField addTarget:self action:@selector(tfEditingEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    return _searchTextField;
}

@end


@interface BusinessTypeView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomBlackView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation BusinessTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.popType = PopTypeTop;
        self.backgroundView.backgroundColor = UIColor.clearColor;
        [[UIApplication sharedApplication].delegate.window addSubview:self.bottomBlackView];
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomBlackView.alpha = 0.3;
        }];
        [self addSubview:self.tableView];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = kFontTheme14;
    cell.textLabel.textColor = indexPath.row == self.selectedIndex ? kColorThemefb4d56 : kColorThemea4abb3;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(indexPath.row, self.dataArray[indexPath.row]);
    }
    [self clickBottomBlackView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UICreateView initWithFrame:CGRectMake(0, 0, self.width, self.height) Style:UITableViewStylePlain Object:self];
        _tableView.rowHeight = 50;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

- (UIView *)bottomBlackView {
    if (!_bottomBlackView) {
        _bottomBlackView = UIView.viewFrame(CGRectMake(0, self.bottom, kScreenW, kScreenH-self.bottom)).bkgColor(kColorTheme000);
        _bottomBlackView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBottomBlackView)];
        [_bottomBlackView addGestureRecognizer:tap];
    }
    return _bottomBlackView;
}

- (void)clickBottomBlackView {
    [self dismiss];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomBlackView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bottomBlackView removeFromSuperview];
    }];
}

- (void)popView_cancel {
    [self clickBottomBlackView];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
//        _dataArray = @[@"房产", @"游学", @"移民", @"留学", @"医疗"];
        _dataArray = @[@"房产", @"移民"];
    }
    return _dataArray;
}

@end

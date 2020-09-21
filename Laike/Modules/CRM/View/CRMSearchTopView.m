//
//  CRMSearchTopView.m
//  Laike
//
//  Created by xiaobu on 2020/9/16.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMSearchTopView.h"

@implementation CRMSearchTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

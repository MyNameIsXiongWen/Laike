//
//  MineUpdateNameViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/18.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MineUpdateNameViewController.h"
#import "UserModel.h"
#import "MineService.h"

@interface MineUpdateNameViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) MineService *service;

@end

@implementation MineUpdateNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = self.placeholder;
    [self.kNavigationView.rightBtn setTitle:@"保存" forState:0];
    [self.kNavigationView.rightBtn setTitleColor:kColorThemefb4d56 forState:0];
    if ([self.identifier isEqualToString:@"slogan"]) {
        [self.view addSubview:self.bkgView];
        self.textView.text = self.content;
    } else {
        [self.view addSubview:self.textField];
        self.textField.text = self.content;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = kColorThemef5f5f5;
}

- (void)rightNavBtnAction:(UIButton *)sender {
    NSString *contentString;
    if ([self.identifier isEqualToString:@"slogan"]) {
        contentString = self.textView.text;
    } else {
        contentString = self.textField.text;
    }
    if (contentString.length == 0) {
        [SVProgressHUD showInfoWithStatus:self.placeholder];
        return;
    }
    [self updateUserInfoWithKey:self.identifier Value:contentString];
}

//更新信息
- (void)updateUserInfoWithKey:(NSString *)key Value:(NSString *)value {
    [self.service updateMineInfoRequestWithParam:@{key: value} Complete:^{
        UserModel *userModel = UserModel.shareUser;
        if ([self.identifier isEqualToString:@"realName"]) {
            userModel.realName = value;
        } else if ([self.identifier isEqualToString:@"slogan"]) {
            userModel.slogan = value;
        }
        if (self.updateNameBlock) {
            self.updateNameBlock(value);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITextField *)textField {
    if (!_textField) {
        _textField = UITextField.tfFrame(CGRectMake(0, kTopBarHeight+10, kScreenW, 50)).tfTextColor(kColorTheme2a303c).tfFont(kFontTheme14).tfPlaceholder(kFormat(@"请输入%@", self.placeholder));
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.leftView = UIView.viewFrame(CGRectMake(0, 0, 10, _textField.height));
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.backgroundColor = kColorThemefff;
    }
    return _textField;
}

- (UIView *)bkgView {
    if (!_bkgView) {
        _bkgView = UIView.viewFrame(CGRectMake(0, kTopBarHeight+10, kScreenW, 120)).bkgColor(kColorThemefff);
        [_bkgView addSubview:self.textView];
    }
    return _bkgView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = UITextView.tvFrame(CGRectMake(10, 10, self.bkgView.width-20, self.bkgView.height-20)).tvPlaceholder(@"请输入签名").tvFont(kFontTheme14).tvTextColor(kColorTheme2a303c);
    }
    return _textView;
}

- (MineService *)service {
    if (!_service) {
        _service = MineService.new;
    }
    return _service;
}

@end

//
//  CRMAddCustomerViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/1.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMAddCustomerViewController.h"
#import "QHWActionSheetView.h"
#import "CRMService.h"
#import "CRMTextFieldView.h"

@interface CRMAddCustomerViewController () <QHWActionSheetViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) CRMTextFieldView *nameTextFieldView;
@property (nonatomic, strong) CRMTextFieldView *phoneTextFieldView;
@property (nonatomic, strong) CRMTextFieldView *sourceTextFieldView;
@property (nonatomic, strong) UITextView *remarkTextView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation CRMAddCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"新增客户";
    self.kNavigationView.rightBtn.btnTitle(@"保存").btnFont(kMediumFontTheme16).btnTitleColor(kColorTheme21a8ff);
    [self.view addSubview:self.nameTextFieldView];
    [self.view addSubview:self.phoneTextFieldView];
    [self.view addSubview:self.sourceTextFieldView];
    [self.view addSubview:self.remarkTextView];
}

- (void)rightNavBtnAction:(UIButton *)sender {
    if (self.nameTextFieldView.textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入客户姓名"];
        return;
    }
    if (self.phoneTextFieldView.textField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入客户手机号"];
        return;
    }
    if (self.selectedIndex == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择客户来源"];
        return;
    }
    [CRMService.new CRMAddCustomerRequestWithName:self.nameTextFieldView.textField.text Phone:self.phoneTextFieldView.textField.text Source:self.selectedIndex Remark:self.remarkTextView.text Complete:^{
        
    }];
}

- (void)tapSourceView {
    [self.view endEditing:YES];
    QHWActionSheetView *sheetView = [[QHWActionSheetView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 44*MIN(5, (self.dataArray.count+1))+7) title:@""];
    sheetView.dataArray = self.dataArray;
    sheetView.sheetDelegate = self;
    [sheetView show];
}

- (void)actionSheetViewSelectedIndex:(NSInteger)index WithActionSheetView:(QHWActionSheetView *)actionsheetView {
    self.selectedIndex = index + 1;
    self.sourceTextFieldView.rightLabel.text = self.dataArray[index];
    self.sourceTextFieldView.textField.placeholder = @"";
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
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

- (CRMTextFieldView *)nameTextFieldView {
    if (!_nameTextFieldView) {
        _nameTextFieldView = [[CRMTextFieldView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 60)];
        _nameTextFieldView.title = @"* 姓名";
        _nameTextFieldView.textField.placeholder = @"请输入客户姓名";
    }
    return _nameTextFieldView;
}

- (CRMTextFieldView *)phoneTextFieldView {
    if (!_phoneTextFieldView) {
        _phoneTextFieldView = [[CRMTextFieldView alloc] initWithFrame:CGRectMake(0, self.nameTextFieldView.bottom, kScreenW, 60)];
        _phoneTextFieldView.title = @"* 手机";
        _phoneTextFieldView.textField.placeholder = @"请输入客户手机号";
    }
    return _phoneTextFieldView;
}

- (CRMTextFieldView *)sourceTextFieldView {
    if (!_sourceTextFieldView) {
        _sourceTextFieldView = [[CRMTextFieldView alloc] initWithFrame:CGRectMake(0, self.phoneTextFieldView.bottom, kScreenW, 60)];
        _sourceTextFieldView.title = @"* 来源";
        _sourceTextFieldView.textField.placeholder = @"请选择客户来源";
        _sourceTextFieldView.textField.userInteractionEnabled = NO;
        _sourceTextFieldView.rightLabel.hidden = _sourceTextFieldView.arrowImgView.hidden = NO;
        WEAKSELF
        _sourceTextFieldView.clickTFViewBlock = ^{
            [weakSelf tapSourceView];
        };
    }
    return _sourceTextFieldView;
}

- (UITextView *)remarkTextView {
    if (!_remarkTextView) {
        UILabel *label = UILabel.labelFrame(CGRectMake(20, self.sourceTextFieldView.bottom+10, kScreenW-40, 25)).labelText(@"客户备注").labelFont(kFontTheme16);
        [self.view addSubview:label];
        _remarkTextView = UITextView.tvFrame(CGRectMake(20, self.sourceTextFieldView.bottom+40, kScreenW-40, 110)).tvFont(kFontTheme16).tvPlaceholder(@"如果有其他信息需要备注，请在此补充。（100字）");
        _remarkTextView.delegate = self;
        [self.view addSubview:UIView.viewFrame(CGRectMake(0, _remarkTextView.bottom, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return _remarkTextView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"网络客", @"自拓客", @"渠道客", @"其他"];
    }
    return _dataArray;
}

@end

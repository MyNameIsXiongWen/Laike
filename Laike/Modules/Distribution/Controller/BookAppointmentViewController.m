//
//  BookAppointmentViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "BookAppointmentViewController.h"
#import "CRMTextFieldView.h"
#import "QHWActionSheetView.h"

@interface BookAppointmentViewController () <QHWActionSheetViewDelegate>

@property (nonatomic, strong) CRMTextFieldView *businessTextFieldView;
@property (nonatomic, strong) CRMTextFieldView *productTextFieldView;
@property (nonatomic, strong) CRMTextFieldView *nameTextFieldView;
@property (nonatomic, strong) CRMTextFieldView *phoneTextFieldView;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation BookAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"预约签单";
    [self.view addSubview:self.businessTextFieldView];
    [self.view addSubview:self.productTextFieldView];
    [self.view addSubview:self.nameTextFieldView];
    [self.view addSubview:self.phoneTextFieldView];
    [self.view addSubview:self.submitBtn];
}

- (void)clickBusinessTFView {
    NSArray *array = @[@"房产", @"移民", @"留学", @"游学", @"医疗"];
    QHWActionSheetView *sheetView = [[QHWActionSheetView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 44*MIN(5, (array.count+1))+7) title:@""];
    sheetView.dataArray = array;
    sheetView.sheetDelegate = self;
    [sheetView show];
}

- (void)actionSheetViewSelectedIndex:(NSInteger)index WithActionSheetView:(QHWActionSheetView *)actionsheetView {
    self.businessTextFieldView.textField.placeholder = @"";
    self.businessTextFieldView.rightLabel.text = actionsheetView.dataArray[index];
}

- (void)clickProductTFView {
    [self.navigationController pushViewController:NSClassFromString(@"RelateProductViewController").new animated:YES];
}

- (void)clickSubmitBtn {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CRMTextFieldView *)businessTextFieldView {
    if (!_businessTextFieldView) {
        _businessTextFieldView = [[CRMTextFieldView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 60)];
        _businessTextFieldView.title = @"预约业务";
        _businessTextFieldView.textField.placeholder = @"请选择预约业务";
        _businessTextFieldView.textField.userInteractionEnabled = NO;
        _businessTextFieldView.rightLabel.hidden = _businessTextFieldView.arrowImgView.hidden = NO;
        WEAKSELF
        _businessTextFieldView.clickTFViewBlock = ^{
            [weakSelf clickBusinessTFView];
        };
    }
    return _businessTextFieldView;
}

- (CRMTextFieldView *)productTextFieldView {
    if (!_productTextFieldView) {
        _productTextFieldView = [[CRMTextFieldView alloc] initWithFrame:CGRectMake(0, self.businessTextFieldView.bottom, kScreenW, 60)];
        _productTextFieldView.title = @"预约产品";
        _productTextFieldView.textField.placeholder = @"请选择预约产品";
        _productTextFieldView.textField.userInteractionEnabled = NO;
        _productTextFieldView.rightLabel.hidden = _productTextFieldView.arrowImgView.hidden = NO;
        WEAKSELF
        _productTextFieldView.clickTFViewBlock = ^{
            [weakSelf clickProductTFView];
        };
    }
    return _productTextFieldView;
}

- (CRMTextFieldView *)nameTextFieldView {
    if (!_nameTextFieldView) {
        _nameTextFieldView = [[CRMTextFieldView alloc] initWithFrame:CGRectMake(0, self.productTextFieldView.bottom, kScreenW, 60)];
        _nameTextFieldView.title = @"客户姓名";
        _nameTextFieldView.textField.placeholder = @"请输入客户姓名";
    }
    return _nameTextFieldView;
}

- (CRMTextFieldView *)phoneTextFieldView {
    if (!_phoneTextFieldView) {
        _phoneTextFieldView = [[CRMTextFieldView alloc] initWithFrame:CGRectMake(0, self.nameTextFieldView.bottom, kScreenW, 60)];
        _phoneTextFieldView.title = @"手机号";
        _phoneTextFieldView.textField.placeholder = @"请输入客户手机号";
    }
    return _phoneTextFieldView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = UIButton.btnFrame(CGRectMake(15, self.phoneTextFieldView.bottom+15, kScreenW-30, 45)).btnTitle(@"提交").btnFont(kFontTheme20).btnTitleColor(kColorTheme21a8ff).btnBorderColor(kColorTheme21a8ff).btnCornerRadius(8).btnAction(self, @selector(clickSubmitBtn));
    }
    return _submitBtn;
}

@end

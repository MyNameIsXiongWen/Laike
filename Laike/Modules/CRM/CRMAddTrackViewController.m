//
//  CRMAddTrackViewController.m
//  Laike
//
//  Created by xiaobu on 2020/7/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CRMAddTrackViewController.h"
#import "CRMTextFieldView.h"
#import "QHWActionSheetView.h"
#import "CRMService.h"
#import "QHWFilterModel.h"

@interface CRMAddTrackViewController () <QHWActionSheetViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) CRMTextFieldView *typeTFView;
@property (nonatomic, strong) UITextView *remarkTextView;
@property (nonatomic, strong) CRMService *crmService;
@property (nonatomic, strong) NSArray <FilterCellModel *>*typeArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation CRMAddTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"跟进记录";
    self.kNavigationView.rightBtn.btnTitle(@"完成").btnTitleColor(kColorTheme21a8ff).btnFont(kMediumFontTheme16);
    [self.view addSubview:self.typeTFView];
    [self.view addSubview:self.remarkTextView];
    self.selectedIndex = 999;
}

- (void)rightNavBtnAction:(UIButton *)sender {
    if (self.selectedIndex == 999) {
        [SVProgressHUD showInfoWithStatus:@"请选择跟进类型"];
        return;
    }
    if (self.remarkTextView.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入跟进说明"];
        return;
    }
    [self.crmService CRMAddTrackRequestWithCustomerId:self.customerId FollowStatusCode:self.typeArray[self.selectedIndex].code.integerValue Remark:self.remarkTextView.text Complete:^{
        
    }];
}

- (void)getMainData {
    [self.crmService getCRMFilterDataRequestWithComplete:^(id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:NSDictionary.class]) {
            self.typeArray = [NSArray yy_modelArrayWithClass:FilterCellModel.class json:responseObject[@"followStatusList"]];
        }
    }];
}

- (void)tapTypeView {
    [self.view endEditing:YES];
    QHWActionSheetView *sheetView = [[QHWActionSheetView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 44*MIN(5, (self.typeArray.count+1))+7) title:@""];
    sheetView.dataArray = [self.typeArray convertToTitleArrayWithKeyName:@"name"];
    sheetView.sheetDelegate = self;
    [sheetView show];
}

- (void)actionSheetViewSelectedIndex:(NSInteger)index WithActionSheetView:(QHWActionSheetView *)actionsheetView {
    self.selectedIndex = index;
    self.typeTFView.rightLabel.text = self.typeArray[index].name;
    self.typeTFView.textField.placeholder = @"";
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

- (CRMTextFieldView *)typeTFView {
    if (!_typeTFView) {
        _typeTFView = [[CRMTextFieldView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, kScreenW, 60)];
        _typeTFView.title = @"* 跟进类型";
        _typeTFView.textField.placeholder = @"请选择跟进类型";
        _typeTFView.textField.userInteractionEnabled = NO;
        _typeTFView.rightLabel.hidden = _typeTFView.arrowImgView.hidden = NO;
        _typeTFView.rightLabel.textColor = kColorTheme21a8ff;
        WEAKSELF
        _typeTFView.clickTFViewBlock = ^{
            [weakSelf tapTypeView];
        };
    }
    return _typeTFView;
}

- (UITextView *)remarkTextView {
    if (!_remarkTextView) {
        UILabel *label = UILabel.labelFrame(CGRectMake(20, self.typeTFView.bottom+10, kScreenW-40, 25)).labelFont(kFontTheme16);
        NSString *title = @"* 跟进说明";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
        [attr addAttributes:@{NSForegroundColorAttributeName: UIColor.redColor} range:[title rangeOfString:@"*"]];
        label.attributedText = attr;
        [self.view addSubview:label];
        _remarkTextView = UITextView.tvFrame(CGRectMake(20, self.typeTFView.bottom+40, kScreenW-40, 220)).tvFont(kFontTheme16).tvPlaceholder(@"如果有其他信息需要备注，请在此补充。（100字）");
        _remarkTextView.delegate = self;
        [self.view addSubview:UIView.viewFrame(CGRectMake(0, _remarkTextView.bottom, kScreenW, 0.5)).bkgColor(kColorThemeeee)];
    }
    return _remarkTextView;
}

- (CRMService *)crmService {
    if (!_crmService) {
        _crmService = CRMService.new;
    }
    return _crmService;
}

@end

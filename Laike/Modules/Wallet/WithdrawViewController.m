//
//  WithdrawViewController.m
//  Laike
//
//  Created by xiaobu on 2020/11/3.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "WithdrawViewController.h"
#import "WithdrawAccountViewController.h"
#import "WalletService.h"

@interface WithdrawViewController ()

@property (weak, nonatomic) IBOutlet UILabel *alipayLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
@property (nonatomic, strong) WalletService *service;

@property (nonatomic, strong) NSDictionary *alipayData;
@property (nonatomic, copy) NSString *balance;

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.kNavigationView.title = @"我的钱包";
    self.moneyTextField.leftView = UILabel.labelFrame(CGRectMake(0, 0, 30, 40)).labelText(@"¥  ").labelTitleColor(kColorTheme000).labelFont(kMediumFontTheme18);
    self.moneyTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.alipayLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAliLabel)]];
}

- (void)getMainData {
    [self.service getWalletInfoRequestWithComplete:^(NSDictionary * _Nullable dataDic) {
        if (dataDic) {
            self.balance = dataDic[@"balance"];
            self.alipayData = dataDic[@"alipayData"];
            self.alipayLabel.text = [self.alipayData[@"name"] length] > 0 ? self.alipayData[@"name"] : @"未设置";
        }
    }];
}

- (void)clickAliLabel {
    WithdrawAccountViewController *vc = WithdrawAccountViewController.new;
    vc.account = self.alipayData[@"account"];
    vc.name = self.alipayData[@"name"];
    WEAKSELF
    vc.bindSuccessBlock = ^(NSString * _Nonnull name) {
        weakSelf.alipayLabel.text = name;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickWithdrawBtn:(id)sender {
    if (self.balance.floatValue/100.0 < 50.0) {
        [SVProgressHUD showInfoWithStatus:@"满50元才能提现"];
        return;
    }
    if (self.moneyTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入提现金额"];
        return;
    }
    if (self.moneyTextField.text.integerValue == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入提现金额"];
        return;
    }
    if (self.moneyTextField.text.integerValue%50 != 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入50的整数倍金额"];
        return;
    }
    [self.service withdrawRequestWithMoney:self.moneyTextField.text Complete:^(NSInteger status) {
        if (status == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if (status == 201001) {
            [self clickAliLabel];
        }
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

- (WalletService *)service {
    if (!_service) {
        _service = WalletService.new;
    }
    return _service;
}

@end

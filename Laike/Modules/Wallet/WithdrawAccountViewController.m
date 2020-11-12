//
//  WithdrawAccountViewController.m
//  Laike
//
//  Created by xiaobu on 2020/11/3.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "WithdrawAccountViewController.h"
#import "WalletService.h"

@interface WithdrawAccountViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;

@end

@implementation WithdrawAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.kNavigationView.title = @"我的钱包";
    self.accountTextField.text = self.account;
    self.nameTextField.text = self.name;
}

- (IBAction)clickWithdrawBtn:(id)sender {
    if (self.accountTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入支付宝账号"];
        return;
    }
    if (self.nameTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入实名认证姓名"];
        return;
    }
    WalletService *service = WalletService.new;
    [service bindAlipayRequestWithAccount:self.accountTextField.text Name:self.nameTextField.text Complete:^{
        if (self.bindSuccessBlock) {
            self.bindSuccessBlock(self.nameTextField.text);
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

@end

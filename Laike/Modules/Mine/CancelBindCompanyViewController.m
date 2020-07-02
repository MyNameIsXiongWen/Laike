//
//  CancelBindCompanyViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/24.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CancelBindCompanyViewController.h"

@interface CancelBindCompanyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation CancelBindCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.kNavigationView.title = @"已绑定公司";
    self.cancelBtn.btnCornerRadius(8).btnBorderColor(kColorTheme21a8ff);
    self.nameLabel.text = self.companyName;
}

- (IBAction)clickCancelBtn:(id)sender {
    [QHWHttpManager.sharedInstance QHW_POST:kMerchantBind parameters:@{@"bindStatus": @"2"} success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"解绑成功"];
        [self.navigationController popViewControllerAnimated:YES];
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationBindSuccess object:nil];
    } failure:^(NSError *error) {
        
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

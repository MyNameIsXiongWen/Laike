//
//  BindCompanyViewController.m
//  Laike
//
//  Created by xiaobu on 2020/6/24.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "BindCompanyViewController.h"

static NSString *const ServiceHotLine = @"400-877-1008";
@interface BindCompanyViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@end

@implementation BindCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.kNavigationView.title = @"绑定公司";
    self.confirmBtn.btnCornerRadius(8);
    NSString *remindString = kFormat(@"所属公司未与去海外平台合作？\n致电%@咨询", ServiceHotLine);
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:remindString];
    [attr addAttributes:@{NSForegroundColorAttributeName: kColorTheme21a8ff} range:[remindString rangeOfString:ServiceHotLine]];
    self.remindLabel.attributedText = attr;
    [self.remindLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:ServiceHotLine action:@selector(clickServiceHotLine)]];
    
    self.nameTextField.text = @"2002180000";
}

- (void)clickServiceHotLine {
    kCallTel(ServiceHotLine);
}

- (IBAction)clickConfirmBtn:(id)sender {
    [QHWHttpManager.sharedInstance QHW_POST:kMerchantBind parameters:@{@"bindStatus": @"1", @"merchantNumber": self.nameTextField.text} success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"绑定成功"];
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

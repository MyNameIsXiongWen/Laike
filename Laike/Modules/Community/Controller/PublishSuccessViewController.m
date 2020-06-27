//
//  PublishSuccessViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/21.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "PublishSuccessViewController.h"

@interface PublishSuccessViewController ()

@end

@implementation PublishSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"发布成功";
    UIImageView *imgView = UIImageView.ivFrame(CGRectMake((kScreenW-80)/2, kTopBarHeight+70, 80, 80)).ivImage(kImageMake(@"publish_success"));
    [self.view addSubview:imgView];
    UILabel *label = UILabel.labelFrame(CGRectMake(15, imgView.bottom+30, kScreenW-30, 30)).labelTitleColor(kColorTheme2a303c).labelText(@"发布成功").labelFont(kMediumFontTheme18).labelTextAlignment(NSTextAlignmentCenter);
    [self.view addSubview:label];
    UIButton *backBtn = UIButton.btnFrame(CGRectMake(15, label.bottom+50, kScreenW-30, 50)).btnTitle(@"返回").btnTitleColor(kColorThemefff).btnBkgColor(kColorThemefb4d56).btnFont(kMediumFontTheme18).btnCornerRadius(5).btnAction(self, @selector(leftNavBtnAction:));
    [self.view addSubview:backBtn];
}

- (void)leftNavBtnAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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

//
//  MyServiceViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MyServiceViewController.h"
#import "UserModel.h"

@interface MyServiceViewController ()

@property (nonatomic, strong) UILabel *tipLabel1;
@property (nonatomic, strong) UILabel *tipLabel2;
@property (nonatomic, strong) UILabel *wechatLabel;
@property (nonatomic, strong) UIImageView *qrcodeImgView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *coopyBtn;

@end

@implementation MyServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"我的客服";
    
    self.tipLabel1 = UILabel.labelFrame(CGRectMake(0, kTopBarHeight+60, kScreenW, 20)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelText(@"请联系客服反馈您所遇到的问题").labelTextAlignment(NSTextAlignmentCenter);
    [self.view addSubview:self.tipLabel1];
    
    self.qrcodeImgView = UIImageView.ivFrame(CGRectMake((kScreenW-150)/2, self.tipLabel1.bottom+30, 150, 150)).ivImage(kImageMake(@"global_service"));
    [self.view addSubview:self.qrcodeImgView];
    
    self.saveBtn = UIButton.btnFrame(CGRectMake((kScreenW-150)/2, self.qrcodeImgView.bottom+20, 150, 40)).btnTitle(@"保存到相册").btnTitleColor(kColorThemefff).btnFont(kFontTheme13).btnBkgColor(kColorTheme21a8ff).btnCornerRadius(20).btnAction(self, @selector(clickSaveBtn));
    [self.view addSubview:self.saveBtn];
    
    self.tipLabel2 = UILabel.labelFrame(CGRectMake(0, self.saveBtn.bottom+100, kScreenW, 20)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelText(@"或者添加客服微信号").labelTextAlignment(NSTextAlignmentCenter);
    [self.view addSubview:self.tipLabel2];
    
    self.wechatLabel = UILabel.labelFrame(CGRectMake(0, self.tipLabel2.bottom+20, kScreenW, 20)).labelFont(kFontTheme13).labelTitleColor(kColorThemea4abb3).labelText(@"Qhiwi2018").labelTextAlignment(NSTextAlignmentCenter);
    [self.view addSubview:self.wechatLabel];
    
    self.coopyBtn = UIButton.btnFrame(CGRectMake((kScreenW-150)/2, self.wechatLabel.bottom+20, 150, 40)).btnTitle(@"复制微信号").btnTitleColor(kColorTheme21a8ff).btnFont(kFontTheme13).btnBkgColor(kColorThemefff).btnBorderColor(kColorTheme21a8ff).btnCornerRadius(20).btnAction(self, @selector(clickCopyBtn));
    [self.view addSubview:self.coopyBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = kColorThemef5f5f5;
}

- (void)clickSaveBtn {
    UIImageWriteToSavedPhotosAlbum(self.qrcodeImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"图片保存失败，请稍后重试"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }
}

- (void)clickCopyBtn {
    UIPasteboard.generalPasteboard.string = self.wechatLabel.text;
    [SVProgressHUD showSuccessWithStatus:@"已复制到粘贴板"];
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

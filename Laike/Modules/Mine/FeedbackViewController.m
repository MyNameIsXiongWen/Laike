//
//  FeedbackViewController.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/2.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UserModel.h"

@interface FeedbackViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *bkgView;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kNavigationView.title = @"问题反馈";
    [self.kNavigationView.leftBtn setTitle:@"取消" forState:0];
    [self.kNavigationView.leftBtn setTitleColor:kColorThemea4abb3 forState:0];
    [self.kNavigationView.leftBtn setImage:UIImage.new forState:0];
    [self.kNavigationView.rightBtn setTitle:@"提交" forState:0];
    [self.kNavigationView.rightBtn setTitleColor:kColorThemefb4d56 forState:0];
    [self.view addSubview:self.bkgView];
    [self.view addSubview:self.numberLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = kColorThemef5f5f5;
}

- (void)rightNavBtnAction:(UIButton *)sender {
    NSString *word = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (word.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"内容不能为空"];
        return;
    }
    [QHWHttpLoading showWithMaskTypeBlack];
    NSMutableDictionary *requestParams = @{@"content": self.textView.text,
                                           @"subject": @(1),
                                           @"subjectId": UserModel.shareUser.id,
                                           @"contentType": @(0),
                                           @"communicationType": @(3),
                                           @"imgsList": @[]}.mutableCopy;
    [QHWHttpManager.sharedInstance QHW_POST:kFeedback parameters:requestParams success:^(id responseObject) {
        [SVProgressHUD showInfoWithStatus:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ------------UITextViewDelegate-------------
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 500) {
        textView.text = [textView.text substringToIndex:500];
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)textView.text.length];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIView *)bkgView {
    if (!_bkgView) {
        _bkgView = UIView.viewFrame(CGRectMake(0, kTopBarHeight+10, kScreenW, 220)).bkgColor(kColorThemefff);
        [_bkgView addSubview:self.textView];
    }
    return _bkgView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = UITextView.tvFrame(CGRectMake(10, 10, self.bkgView.width-20, self.bkgView.height-20)).tvPlaceholder(@"最多500字").tvFont(kFontTheme14).tvTextColor(kColorTheme2a303c);
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        UILabel *label = UILabel.labelFrame(CGRectMake(kScreenW-55, self.bkgView.bottom, 40, 30)).labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme16).labelText(@"/500");
        [self.view addSubview:label];
        _numberLabel = UILabel.labelFrame(CGRectMake(label.left-100, self.bkgView.bottom, 100, 30)).labelTextAlignment(NSTextAlignmentRight).labelTitleColor(kColorTheme21a8ff).labelFont(kFontTheme16).labelText(@"0");
        
    }
    return _numberLabel;
}

@end

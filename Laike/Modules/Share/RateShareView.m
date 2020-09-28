//
//  RateShareView.m
//  Laike
//
//  Created by xiaobu on 2020/7/7.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "RateShareView.h"
#import "MainBusinessShareView.h"
#import "UserModel.h"
#import "RateModel.h"

@interface RateShareView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UIImageView *miniCodeImgView;
@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *sloganLabel;

@property (nonatomic, strong) ShareBottomView *bottomView;

@end

@implementation RateShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        self.popType = PopTypeBottom;
        [self configUI];
        self.viewAction(self, @selector(dismiss));
    }
    return self;
}

- (void)configUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW, MIN(kScreenH-120-kStatusBarHeight, 170+450+110))];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, 170+450+110);
    [self addSubview:self.scrollView];
    
    self.bkgView = UIView.viewFrame(CGRectMake(40, 0, kScreenW-80, self.scrollView.contentSize.height)).bkgColor(kColorThemefb4d56).viewAction(self, @selector(dismiss));
    [self.bkgView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBkgView:)]];
    [self.scrollView addSubview:self.bkgView];
    
    UserModel *userModel = UserModel.shareUser;
    self.avatarImgView = UIImageView.ivFrame(CGRectMake(30, 20, 60, 60)).ivCornerRadius(30);
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.headPath)]];
    self.nameLabel = UILabel.labelFrame(CGRectMake(self.avatarImgView.right+20, self.avatarImgView.top, self.bkgView.width-130, self.avatarImgView.height)).labelFont(kMediumFontTheme20).labelTitleColor(kColorThemefff).labelText(userModel.realName);
//    self.phoneLabel = UILabel.labelFrame(CGRectMake(self.nameLabel.left, self.nameLabel.bottom+10, self.nameLabel.width, 17)).labelFont(kFontTheme12).labelTitleColor(kColorTheme2a303c).labelText(userModel.mobileNumber);
    [self.bkgView addSubview:self.avatarImgView];
    [self.bkgView addSubview:self.nameLabel];
//    [self.bkgView addSubview:self.phoneLabel];
    
    
    UILabel *label1 = UILabel.labelFrame(CGRectMake(self.avatarImgView.left, self.avatarImgView.bottom+20, self.bkgView.width-60, 23)).labelText(@"EXCHANGE RATE").labelTitleColor(kColorThemefff).labelFont([UIFont fontWithName:@"Arial-BoldItalicMT" size:20]);
    [self.bkgView addSubview:label1];
    NSString *time = kFormat(@"今 日 汇 率 %@", [NSString getCurrentTime]);
    UILabel *label2 = UILabel.labelFrame(CGRectMake(self.avatarImgView.left, label1.bottom, label1.width, 23)).labelText(time).labelTitleColor(kColorThemefff).labelFont([UIFont italicSystemFontOfSize:16]);
    [self.bkgView addSubview:label2];
    
    UIView *line = UIView.viewFrame(CGRectMake(self.avatarImgView.left, label2.bottom+25+450+10, 20, 5)).bkgColor(kColorThemefff);
    self.sloganLabel = UILabel.labelFrame(CGRectMake(self.avatarImgView.left, line.bottom+7, self.bkgView.width-20, 20)).labelFont(kFontTheme13).labelTitleColor(kColorThemefff).labelText(@"参考中国银行现钞卖出价格");
    [self.bkgView addSubview:line];
    [self.bkgView addSubview:self.sloganLabel];
    
    self.miniCodeImgView = UIImageView.ivFrame(CGRectMake(self.bkgView.width-95, self.sloganLabel.y, 70, 70)).ivCornerRadius(35).ivBkgColor(kColorThemefff);
    [self.miniCodeImgView sd_setImageWithURL:[NSURL URLWithString:kMiniCodePath(userModel.qrCode)]];
    [self.bkgView addSubview:self.miniCodeImgView];
    self.logoImgView = UIImageView.ivFrame(CGRectMake(19, 19, 32, 32)).ivBkgColor(kColorThemefff).ivCornerRadius(16);
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.headPath)]];
    [self.miniCodeImgView addSubview:self.logoImgView];
    
    self.bottomView = [[ShareBottomView alloc] initWithFrame:CGRectMake(0, self.height-100, kScreenW, 100)];
    WEAKSELF
    self.bottomView.clickBtnBlock = ^(NSInteger index) {
        if ([weakSelf.delegate respondsToSelector:@selector(ShareBottomView_clickBottomBtnWithIndex:Image:TargetView:)]) {
            [weakSelf.delegate ShareBottomView_clickBottomBtnWithIndex:index Image:[weakSelf screenShot] TargetView:weakSelf];
        }
    };
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        [self addSubview:self.bottomView];
    }
}

- (void)setRateArray:(NSArray *)rateArray {
    _rateArray = rateArray;
    CGFloat width = (kScreenW-80-80)/2.0;
    __block NSArray *imgArray = @[@"country_meiguo", @"country_riben", @"country_aozhou", @"country_yingguo", @"country_xinxilan", @"country_taiguo", @"country_oumeng", @"country_jianada"];
    UIView *tempView = UIView.viewFrame(CGRectMake(0, 170, kScreenW-80, 450)).bkgColor(kColorThemefff);
    [self.bkgView addSubview:tempView];
    [rateArray enumerateObjectsUsingBlock:^(RateModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0 && idx < 9) {
            UIView *countryView = UIView.viewFrame(CGRectMake((idx-1) % 2 == 0 ? 40 : (40+width), 10 + (idx-1) / 2 * 110, width, 110));
            UIImageView *imgView = UIImageView.ivFrame(CGRectMake((width-50)/2, 0, 50, 50)).ivImage(kImageMake(imgArray[idx-1])).ivCornerRadius(25).ivBkgColor(kColorThemef5f5f5).ivBorderColor(kColorThemeeee);
            UILabel *nameLabel = UILabel.labelFrame(CGRectMake(0, imgView.bottom, width, 25)).labelText(obj.currencyName).labelFont(kFontTheme13).labelTitleColor(kColorTheme2a303c).labelTextAlignment(NSTextAlignmentCenter);
            NSString *rateStr = [NSString formatterWithValue:1.0/obj.rate.doubleValue];
            UILabel *rateLabel = UILabel.labelFrame(CGRectMake(0, nameLabel.bottom, width, 20)).labelText(rateStr).labelFont(kMediumFontTheme14).labelTitleColor(kColorThemefb4d56).labelTextAlignment(NSTextAlignmentCenter);
            [countryView addSubview:imgView];
            [countryView addSubview:nameLabel];
            [countryView addSubview:rateLabel];
            [tempView addSubview:countryView];
        }
    }];
}

- (void)longPressBkgView:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UIImageWriteToSavedPhotosAlbum([self screenShot], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"图片保存失败，请稍后重试"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }
}

- (UIImage *)screenShot {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bkgView.width, self.bkgView.height), NO, UIScreen.mainScreen.scale);
    [self.bkgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotImage;
}

@end

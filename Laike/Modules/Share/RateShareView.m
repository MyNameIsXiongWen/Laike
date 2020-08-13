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
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    }
    return self;
}

- (void)configUI {
    self.bkgView = UIView.viewFrame(CGRectMake(40, 0, kScreenW-80, 530)).bkgColor(kColorThemefff);
    self.bkgView.userInteractionEnabled = YES;
    [self.bkgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [self.bkgView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBkgView:)]];
    [self addSubview:self.bkgView];
        
    CGFloat rateViewHeight = 410;
    
    NSString *time = kFormat(@"%@ 今日汇率", [NSString getCurrentTime]);
    UILabel *label = UILabel.labelFrame(CGRectMake(10, rateViewHeight, self.bkgView.width-20, 17)).labelText(time).labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme12).labelTextAlignment(NSTextAlignmentRight);
    [self.bkgView addSubview:label];
    
    UserModel *userModel = UserModel.shareUser;
    self.avatarImgView = UIImageView.ivFrame(CGRectMake(10, rateViewHeight+25, 40, 40)).ivCornerRadius(20);
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.headPath)]];
    self.nameLabel = UILabel.labelFrame(CGRectMake(self.avatarImgView.right+10, self.avatarImgView.top, self.bkgView.width-20-140, 20)).labelFont(kMediumFontTheme18).labelTitleColor(kColorTheme2a303c).labelText(userModel.realName);
    self.phoneLabel = UILabel.labelFrame(CGRectMake(self.nameLabel.left, self.nameLabel.bottom+10, self.nameLabel.width, 17)).labelFont(kFontTheme12).labelTitleColor(kColorTheme2a303c).labelText(userModel.mobileNumber);
    self.sloganLabel = UILabel.labelFrame(CGRectMake(10, self.avatarImgView.bottom+20, self.bkgView.width-20, 15)).labelFont(kFontTheme13).labelTitleColor(kColorThemea4abb3).labelText(kFormat(@"去海外全球美好生活找%@", userModel.realName));
    [self.bkgView addSubview:self.avatarImgView];
    [self.bkgView addSubview:self.nameLabel];
    [self.bkgView addSubview:self.phoneLabel];
    [self.bkgView addSubview:self.sloganLabel];
    
    self.miniCodeImgView = UIImageView.ivFrame(CGRectMake(self.bkgView.width-80, self.avatarImgView.y, 70, 70)).ivCornerRadius(35);
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
    [rateArray enumerateObjectsUsingBlock:^(RateModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0 && idx < 9) {
            UIView *countryView = UIView.viewFrame(CGRectMake((idx-1) % 2 == 0 ? 40 : (40+width), 10 + (idx-1) / 2 * 100, width, 100));
            UIImageView *imgView = UIImageView.ivFrame(CGRectMake((width-50)/2, 0, 50, 50)).ivImage(kImageMake(imgArray[idx-1])).ivCornerRadius(25).ivBkgColor(kColorThemef5f5f5).ivBorderColor(kColorThemeeee);
            UILabel *nameLabel = UILabel.labelFrame(CGRectMake(0, imgView.bottom, width, 25)).labelText(obj.currencyName).labelFont(kFontTheme13).labelTitleColor(kColorThemea4abb3).labelTextAlignment(NSTextAlignmentCenter);
            NSString *rateStr = [NSString formatterWithValue:1.0/obj.rate.doubleValue];
            UILabel *rateLabel = UILabel.labelFrame(CGRectMake(0, nameLabel.bottom, width, 20)).labelText(rateStr).labelFont(kMediumFontTheme14).labelTitleColor(kColorThemefb4d56).labelTextAlignment(NSTextAlignmentCenter);
            [countryView addSubview:imgView];
            [countryView addSubview:nameLabel];
            [countryView addSubview:rateLabel];
            [self.bkgView addSubview:countryView];
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

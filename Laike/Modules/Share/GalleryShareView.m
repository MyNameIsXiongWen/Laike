//
//  GalleryShareView.m
//  Laike
//
//  Created by xiaobu on 2020/7/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "GalleryShareView.h"
#import "MainBusinessShareView.h"
#import "UserModel.h"

@interface GalleryShareView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UIImageView *miniCodeImgView;
@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *sloganLabel;

@property (nonatomic, strong) ShareBottomView *bottomView;

@end

@implementation GalleryShareView

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
        self.viewAction(self, @selector(dismiss));
    }
    return self;
}

- (void)configUI {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 0, kScreenW-80, MIN(kScreenH-120, self.imgHeight+120))];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.imgHeight+120);
    [self addSubview:self.scrollView];
    
    self.bkgView = UIView.viewFrame(CGRectMake(0, 0, self.scrollView.width, self.imgHeight+120)).bkgColor(kColorThemefff).viewAction(self, @selector(dismiss));
    [self.bkgView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBkgView:)]];
    [self.scrollView addSubview:self.bkgView];
    
    self.coverImgView = UIImageView.ivFrame(CGRectMake(0, 0, self.bkgView.width, self.bkgView.height-120));
    [self.bkgView addSubview:self.coverImgView];
    
    UserModel *userModel = UserModel.shareUser;
    self.avatarImgView = UIImageView.ivFrame(CGRectMake(10, self.coverImgView.bottom+25, 40, 40)).ivCornerRadius(20);
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.headPath)]];
    self.nameLabel = UILabel.labelFrame(CGRectMake(self.avatarImgView.right+10, self.avatarImgView.top, self.coverImgView.width-140, 20)).labelFont(kMediumFontTheme18).labelTitleColor(kColorTheme2a303c).labelText(userModel.realName);
    self.phoneLabel = UILabel.labelFrame(CGRectMake(self.nameLabel.left, self.nameLabel.bottom+10, self.nameLabel.width, 17)).labelFont(kFontTheme12).labelTitleColor(kColorTheme2a303c).labelText(userModel.mobileNumber);
    self.sloganLabel = UILabel.labelFrame(CGRectMake(10, self.avatarImgView.bottom+20, self.coverImgView.width, 15)).labelFont(kFontTheme13).labelTitleColor(kColorThemea4abb3).labelText(kFormat(@"去海外全球美好生活找%@", userModel.realName));
    [self.bkgView addSubview:self.avatarImgView];
    [self.bkgView addSubview:self.nameLabel];
    [self.bkgView addSubview:self.phoneLabel];
    [self.bkgView addSubview:self.sloganLabel];
    
    self.miniCodeImgView = UIImageView.ivFrame(CGRectMake(self.bkgView.width-80, self.coverImgView.bottom+10, 70, 70)).ivCornerRadius(35);
    [self.miniCodeImgView sd_setImageWithURL:[NSURL URLWithString:kMiniCodePath(userModel.qrCode)]];
    [self.bkgView addSubview:self.miniCodeImgView];
    self.logoImgView = UIImageView.ivFrame(CGRectMake(19, 19, 32, 32)).ivBkgColor(kColorThemefff).ivCornerRadius(16);
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.headPath)]];
    [self.miniCodeImgView addSubview:self.logoImgView];
    
    self.bottomView = [[ShareBottomView alloc] initWithFrame:CGRectMake(0, self.height-100, kScreenW, 100)];
    WEAKSELF
    self.bottomView.clickBtnBlock = ^(NSInteger index) {
        if ([weakSelf.delegate respondsToSelector:@selector(ShareBottomView_clickBottomBtnWithIndex:Image:)]) {
            [weakSelf.delegate ShareBottomView_clickBottomBtnWithIndex:index Image:[weakSelf screenShot]];
        }
        [weakSelf dismiss];
    };
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        [self addSubview:self.bottomView];
    }
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

- (void)setGalleryImg:(id)galleryImg {
    _galleryImg = galleryImg;
    [self configUI];
    if ([galleryImg isKindOfClass:NSString.class]) {
        [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath((NSString *)galleryImg)]];
    } else if ([galleryImg isKindOfClass:UIImage.class]) {
        self.coverImgView.image = (UIImage *)galleryImg;
    }
}

@end

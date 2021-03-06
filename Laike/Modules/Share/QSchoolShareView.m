//
//  QSchoolShareView.m
//  Laike
//
//  Created by xiaobu on 2020/7/9.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QSchoolShareView.h"
#import "MainBusinessShareView.h"
#import "QHWQRCode.h"
#import "UserModel.h"

@interface QSchoolShareView ()

@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UIImageView *nameImgView;
@property (nonatomic, strong) UIImageView *miniCodeImgView;
@property (nonatomic, strong) UIImageView *logoImgView;

@property (nonatomic, strong) UIView *contentBkgView;
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *teacherLabel;
@property (nonatomic, strong) UILabel *courseKeyLabel;
@property (nonatomic, strong) UILabel *courseVlueLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *sloganLabel;

@property (nonatomic, strong) ShareBottomView *bottomView;

@end

@implementation QSchoolShareView

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
    self.bkgView = UIView.viewFrame(CGRectMake(10, 0, kScreenW-20, 530)).bkgColor(kColorThemefff).viewAction(self, @selector(dismiss));
    [self.bkgView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBkgView:)]];
    [self addSubview:self.bkgView];
    
    UserModel *user = UserModel.shareUser;
    self.avatarImgView = UIImageView.ivFrame(CGRectMake(15, 15, 50, 50)).ivCornerRadius(25).ivBorderColor(kColorTheme2a303c);
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(user.headPath)]];
    self.nameImgView = UIImageView.ivFrame(CGRectMake(self.avatarImgView.right-15, 25, 200, 30)).ivImage(kImageMake(@"share_school"));
    [self.bkgView addSubview:self.avatarImgView];
    [self.bkgView addSubview:self.nameImgView];
    
    self.contentBkgView = UIView.viewFrame(CGRectMake(20, self.avatarImgView.bottom+15, self.bkgView.width-40, 360)).bkgColor(kColorThemefff).cornerRadius(5);
    [self.contentBkgView addShadowWithRadius:5 Opacity:0.1];
    [self.bkgView addSubview:self.contentBkgView];
    
    self.coverImgView = UIImageView.ivFrame(CGRectMake(15, 15, self.contentBkgView.width-30, 180));
    self.titleLabel = UILabel.labelFrame(CGRectMake(15, self.coverImgView.bottom+10, self.contentBkgView.width-30, 40)).labelFont(kFontTheme16).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(2);
    [self.contentBkgView addSubview:self.coverImgView];
    [self.contentBkgView addSubview:self.titleLabel];
    
    self.teacherLabel = UILabel.labelFrame(CGRectMake(15, self.titleLabel.bottom + 10, self.contentBkgView.width-30, 20)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c);
    self.courseKeyLabel = UILabel.labelFrame(CGRectMake(15, self.teacherLabel.bottom+5, 75, 17)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelText(@"课程要点：");
    self.courseVlueLabel = UILabel.labelFrame(CGRectMake(self.courseKeyLabel.right, self.courseKeyLabel.y, self.contentBkgView.width-30-self.courseKeyLabel.width, 35)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(2);
    self.typeLabel = UILabel.labelFrame(CGRectMake(self.contentBkgView.width-70, self.courseVlueLabel.bottom+10, 70, 20)).labelFont(kFontTheme14).labelTitleColor(kColorTheme666).labelBkgColor(kColorThemee4e4e4).labelCornerRadius(3);
    [self.contentBkgView addSubview:self.teacherLabel];
    [self.contentBkgView addSubview:self.courseKeyLabel];
    [self.contentBkgView addSubview:self.courseVlueLabel];
    [self.contentBkgView addSubview:self.typeLabel];
    
    self.miniCodeImgView = UIImageView.ivFrame(CGRectMake(self.bkgView.width-75, self.contentBkgView.bottom+15, 60, 60));
    self.miniCodeImgView.image = [QHWQRCode initQRCodeWithString:kAppDownloadURL];
    [self.bkgView addSubview:self.miniCodeImgView];
//    self.logoImgView = UIImageView.ivFrame(CGRectMake(19, 19, 32, 32)).ivCornerRadius(16);
    self.sloganLabel = UILabel.labelFrame(CGRectMake(15, self.miniCodeImgView.bottom-35, self.contentBkgView.width-70, 35)).labelFont(kFontTheme14).labelTitleColor(kColorTheme666).labelText(@"下载去海外来客APP\n开启全球服务之旅").labelNumberOfLines(2).labelTextAlignment(NSTextAlignmentRight);
    [self.bkgView addSubview:self.sloganLabel];

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
    if (!self.schoolModel.snapShotImage) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bkgView.width, self.bkgView.height), NO, UIScreen.mainScreen.scale);
        [self.bkgView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.schoolModel.snapShotImage = screenShotImage;
    }
    return self.schoolModel.snapShotImage;
}

- (void)setSchoolModel:(QHWSchoolModel *)schoolModel {
    _schoolModel = schoolModel;
//    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(schoolModel.headPath)]];
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(schoolModel.coverPath)]];
    self.titleLabel.text = schoolModel.title;
    self.teacherLabel.text = kFormat(@"主讲导师：%@", schoolModel.name);
    self.courseVlueLabel.text = schoolModel.slogan;
    self.typeLabel.text = kFormat(@" %@ ", schoolModel.industryName);
    [self.titleLabel sizeToFit];
    [self.courseVlueLabel sizeToFit];
    [self.typeLabel sizeToFit];
    self.typeLabel.height = 20;
    self.typeLabel.x = self.contentBkgView.width - 15 - self.typeLabel.width;
}

- (void)setMiniCodePath:(NSString *)miniCodePath {
    [self.miniCodeImgView sd_setImageWithURL:[NSURL URLWithString:kMiniCodePath(miniCodePath)]];
}

@end

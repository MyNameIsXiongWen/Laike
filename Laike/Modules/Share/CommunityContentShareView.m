//
//  CommunityContentShareView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/5.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityContentShareView.h"
#import "MainBusinessShareView.h"
#import "UserModel.h"

@interface CommunityContentShareView ()

@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UIImageView *miniCodeImgView;
@property (nonatomic, strong) UIImageView *logoImgView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *sloganLabel;

@property (nonatomic, strong) ShareBottomView *bottomView;

@end

@implementation CommunityContentShareView

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
    self.bkgView = UIView.viewFrame(CGRectMake(10, 0, kScreenW-20, 530)).bkgColor(kColorThemefff);
    self.bkgView.userInteractionEnabled = YES;
    [self.bkgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [self.bkgView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBkgView:)]];
    [self addSubview:self.bkgView];
    
    self.coverImgView = UIImageView.ivFrame(CGRectMake(15, 25, self.bkgView.width-30, self.bkgView.height-105-25));
    [self.bkgView addSubview:self.coverImgView];
    UIView *titleOpacityView = UIView.viewFrame(CGRectMake(0, self.coverImgView.height-40, self.coverImgView.width, 40)).bkgColor([UIColor colorWithWhite:0 alpha:0.3]);
    [self.coverImgView addSubview:titleOpacityView];
    self.titleLabel = UILabel.labelFrame(CGRectMake(0, 0, titleOpacityView.width, 40)).labelFont(kMediumFontTheme15).labelTitleColor(kColorThemefff).labelNumberOfLines(0);
    [titleOpacityView addSubview:self.titleLabel];
    
    UserModel *user = UserModel.shareUser;
    self.avatarImgView = UIImageView.ivFrame(CGRectMake(15, self.bkgView.height-90, 50, 50)).ivCornerRadius(25).ivBorderColor(kColorTheme2a303c);
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(user.headPath)]];
    self.nameLabel = UILabel.labelFrame(CGRectMake(self.avatarImgView.right + 10, self.avatarImgView.y+5, self.bkgView.width-170, 18)).labelFont(kMediumFontTheme15).labelTitleColor(kColorTheme2a303c).labelText(user.realName);
    self.phoneLabel = UILabel.labelFrame(CGRectMake(self.nameLabel.left, self.avatarImgView.bottom-22, self.nameLabel.width, 17)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelText(user.mobileNumber);
    [self.bkgView addSubview:self.avatarImgView];
    [self.bkgView addSubview:self.nameLabel];
    [self.bkgView addSubview:self.phoneLabel];
    
    self.miniCodeImgView = UIImageView.ivFrame(CGRectMake(self.bkgView.width-85, self.bkgView.height-90, 70, 70)).ivCornerRadius(35);
    [self.bkgView addSubview:self.miniCodeImgView];
    self.logoImgView = UIImageView.ivFrame(CGRectMake(19, 19, 32, 32)).ivBkgColor(kColorThemefff).ivCornerRadius(16);
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(user.headPath)]];
    [self.miniCodeImgView addSubview:self.logoImgView];
        
    self.sloganLabel = UILabel.labelFrame(CGRectMake(15, self.avatarImgView.bottom, self.bkgView.width-30, 40)).labelFont(kFontTheme12).labelTitleColor(kColorTheme2a303c).labelText(kFormat(@"去海外全球美好生活找%@", user.realName));
    [self.bkgView addSubview:self.sloganLabel];
    
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
    if (!self.detailModel.snapShotImage) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bkgView.width, self.bkgView.height), NO, UIScreen.mainScreen.scale);
        [self.bkgView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.detailModel.snapShotImage = screenShotImage;
    }
    return self.detailModel.snapShotImage;
}

- (void)setDetailModel:(CommunityDetailModel *)detailModel {
    _detailModel = detailModel;
    if (detailModel.fileType == 1 && detailModel.filePathList.count > 0) {
        if (detailModel.coverPath.length > 0) {
            [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(detailModel.coverPath)]];
        } else {
            self.coverImgView.image = detailModel.videoImg;
        }
    } else if (detailModel.fileType == 2) {
        if (detailModel.filePathList.count > 0) {
            id file = detailModel.filePathList.firstObject;
            NSString *filePath = @"";
            if ([file isKindOfClass:NSDictionary.class]) {
                NSDictionary *fileDic = (NSDictionary *)file;
                filePath = fileDic[@"path"];
            } else if ([file isKindOfClass:NSString.class]) {
                filePath = (NSString *)file;
            }
            [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(filePath)]];
        }
    }
    self.titleLabel.text = detailModel.title ?: detailModel.content;
}

- (void)setMiniCodePath:(NSString *)miniCodePath {
    [self.miniCodeImgView sd_setImageWithURL:[NSURL URLWithString:kMiniCodePath(miniCodePath)]];
}

@end

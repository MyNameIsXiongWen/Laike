//
//  CommunityArticleShareView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/5.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CommunityArticleShareView.h"
#import "MainBusinessShareView.h"
#import "UserModel.h"

@interface CommunityArticleShareView ()

@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UIImageView *nameImgView;
@property (nonatomic, strong) UIImageView *miniCodeImgView;
@property (nonatomic, strong) UIImageView *sloganImgView;
@property (nonatomic, strong) UIImageView *logoImgView;

@property (nonatomic, strong) UIView *contentBkgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) ShareBottomView *bottomView;

@end

@implementation CommunityArticleShareView

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
    self.nameImgView = UIImageView.ivFrame(CGRectMake(self.avatarImgView.right+15, 25, 110, 30));
    [self.bkgView addSubview:self.avatarImgView];
    [self.bkgView addSubview:self.nameImgView];
    
    self.contentBkgView = UIView.viewFrame(CGRectMake(20, self.avatarImgView.bottom+15, self.bkgView.width-40, 340)).bkgColor(kColorThemefff).cornerRadius(5);
    [self.contentBkgView addShadowWithRadius:5 Opacity:0.1];
    [self.bkgView addSubview:self.contentBkgView];
    
    self.titleLabel = UILabel.labelFrame(CGRectMake(15, 15, self.contentBkgView.width-30, 18)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c);
    self.timeLabel = UILabel.labelFrame(CGRectMake(15, self.titleLabel.bottom+5, self.contentBkgView.width-30, 17)).labelFont(kFontTheme13).labelTitleColor(kColorThemea4abb3);
    self.contentLabel = UILabel.labelFrame(CGRectMake(15, self.timeLabel.bottom+10, self.contentBkgView.width-30, self.contentBkgView.height-120)).labelFont(kFontTheme13).labelTitleColor(kColorTheme6d7278).labelNumberOfLines(0);
    [self.contentBkgView addSubview:self.titleLabel];
    [self.contentBkgView addSubview:self.timeLabel];
    [self.contentBkgView addSubview:self.contentLabel];
    
    self.sourceLabel = UILabel.labelFrame(CGRectMake(15, self.contentBkgView.height-50, self.contentBkgView.width-100, 50)).labelFont(kFontTheme14).labelTitleColor(kColorTheme6d7278).labelText(kFormat(@"来源：%@", user.merchantName));
    self.typeLabel = UILabel.labelFrame(CGRectMake(self.contentBkgView.width-70, self.sourceLabel.y+15, 70, 20)).labelFont(kFontTheme14).labelTitleColor(kColorTheme666).labelBkgColor(kColorThemee4e4e4).labelCornerRadius(3);
    [self.contentBkgView addSubview:self.sourceLabel];
    [self.contentBkgView addSubview:self.typeLabel];
    [self.contentBkgView addSubview:UIView.viewFrame(CGRectMake(15, self.contentBkgView.height-50, self.contentBkgView.width-30, 1)).bkgColor(kColorThemeeee)];
    
    self.miniCodeImgView = UIImageView.ivFrame(CGRectMake(self.bkgView.width-85, self.contentBkgView.bottom+20, 70, 70)).ivCornerRadius(35);
    self.sloganImgView = UIImageView.ivFrame(CGRectMake(self.miniCodeImgView.left-140, self.miniCodeImgView.y+20, 120, 30)).ivImage(kImageMake(@"share_slogan"));
    [self.bkgView addSubview:self.miniCodeImgView];
    [self.bkgView addSubview:self.sloganImgView];
    self.logoImgView = UIImageView.ivFrame(CGRectMake(19, 19, 32, 32)).ivBkgColor(kColorThemefff).ivCornerRadius(16);
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(user.headPath)]];
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
//    这个detailModel会有两个类型，一个是CommunityDetailModel 一个是ArticleModel
    _detailModel = detailModel;
    self.nameImgView.image = kImageMake(@"share_article");
    self.titleLabel.text = detailModel.name;
    self.timeLabel.text = detailModel.createTime;
    self.contentLabel.text = detailModel.Html2Text;
    self.typeLabel.text = kFormat(@" %@ ", @"海外头条");
    [self.typeLabel sizeToFit];
    self.typeLabel.height = 20;
    self.typeLabel.x = self.contentBkgView.width - 15 - self.typeLabel.width;
}

- (void)setMiniCodePath:(NSString *)miniCodePath {
    [self.miniCodeImgView sd_setImageWithURL:[NSURL URLWithString:kMiniCodePath(miniCodePath)]];
}

@end

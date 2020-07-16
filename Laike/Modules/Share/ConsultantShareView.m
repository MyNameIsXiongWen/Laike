//
//  ConsultantShareView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ConsultantShareView.h"
#import "MainBusinessShareView.h"

@interface ConsultantShareView ()

@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UIImageView *miniCodeImgView;
@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) InfoView *phoneInfoView;
@property (nonatomic, strong) InfoView *wxInfoView;
@property (nonatomic, strong) InfoView *companyInfoView;

@property (nonatomic, strong) ShareBottomView *bottomView;

@end

@implementation ConsultantShareView

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
    self.bkgView = UIView.viewFrame(CGRectMake(40, 0, kScreenW-80, 480)).bkgColor(kColorThemefff);
    self.bkgView.userInteractionEnabled = YES;
    [self.bkgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBkgView)]];
    [self.bkgView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBkgView:)]];
    [self addSubview:self.bkgView];
    
    self.coverImgView = UIImageView.ivFrame(CGRectMake(0, 0, self.bkgView.width, 300));
    [self.bkgView addSubview:self.coverImgView];
    
    self.avatarImgView = UIImageView.ivFrame(CGRectMake(self.bkgView.width-60, self.coverImgView.bottom+20, 40, 40)).ivCornerRadius(15);
    self.nameLabel = UILabel.labelFrame(CGRectMake(20, self.coverImgView.bottom+15, self.bkgView.width-90, 20)).labelFont(kMediumFontTheme18).labelTitleColor(kColorTheme2a303c);
    self.descLabel = UILabel.labelFrame(CGRectMake(self.nameLabel.left, self.nameLabel.bottom+5, self.nameLabel.width, 17)).labelFont(kFontTheme12).labelTitleColor(kColorTheme2a303c);
    [self.bkgView addSubview:self.avatarImgView];
    [self.bkgView addSubview:self.nameLabel];
    [self.bkgView addSubview:self.descLabel];
    
    [self.bkgView addSubview:UIView.viewFrame(CGRectMake(0, self.descLabel.bottom+15, self.bkgView.width, 1)).bkgColor(kColorThemeeee)];
    
    self.miniCodeImgView = UIImageView.ivFrame(CGRectMake(self.bkgView.width-90, self.descLabel.bottom+25, 70, 70)).ivCornerRadius(35);
    [self.bkgView addSubview:self.miniCodeImgView];
    self.logoImgView = UIImageView.ivFrame(CGRectMake(19, 19, 32, 32)).ivCornerRadius(16);
    [self.miniCodeImgView addSubview:self.logoImgView];
    
    self.phoneInfoView = [[InfoView alloc] initWithFrame:CGRectMake(20, self.miniCodeImgView.y, self.bkgView.width-130, 20)];
    self.wxInfoView = [[InfoView alloc] initWithFrame:CGRectMake(20, self.phoneInfoView.bottom+10, self.phoneInfoView.width, 20)];
    self.companyInfoView = [[InfoView alloc] initWithFrame:CGRectMake(20, self.wxInfoView.bottom+10, self.phoneInfoView.width, 20)];
    [self.bkgView addSubview:self.phoneInfoView];
    [self.bkgView addSubview:self.wxInfoView];
    [self.bkgView addSubview:self.companyInfoView];
    
    self.bottomView = [[ShareBottomView alloc] initWithFrame:CGRectMake(0, self.height-100, kScreenW, 100)];
    WEAKSELF
    self.bottomView.clickBtnBlock = ^(NSInteger index) {
        if ([weakSelf.delegate respondsToSelector:@selector(ShareBottomView_clickBottomBtnWithIndex:Image:TargetView:)]) {
            [weakSelf.delegate ShareBottomView_clickBottomBtnWithIndex:index Image:[weakSelf screenShot] TargetView:weakSelf];
        }
    };
    [self addSubview:self.bottomView];
}

- (void)clickBkgView {
    
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
    if (!self.userModel.snapShotImage) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bkgView.width, self.bkgView.height), NO, UIScreen.mainScreen.scale);
        [self.bkgView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.userModel.snapShotImage = screenShotImage;
    }
    return self.userModel.snapShotImage;
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.headPath)]];
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.headPath)]];
    self.nameLabel.text = userModel.realName;
    self.descLabel.text = userModel.merchantInfo;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.merchantHead)]];
    self.phoneInfoView.label.text = userModel.mobileNumber;
    self.wxInfoView.label.text = userModel.wechatNo;
    self.companyInfoView.label.text = userModel.companyName;
    self.phoneInfoView.imgView.image = kImageMake(@"icon_phone");
    self.wxInfoView.imgView.image = kImageMake(@"icon_wechat");
    self.companyInfoView.imgView.image = kImageMake(@"icon_company");
}

- (void)setMiniCodePath:(NSString *)miniCodePath {
    [self.miniCodeImgView sd_setImageWithURL:[NSURL URLWithString:kMiniCodePath(miniCodePath)]];
}

@end

@implementation InfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.imgView = UIImageView.ivFrame(CGRectMake(0, 0, 15, 20));
        self.label = UILabel.labelFrame(CGRectMake(self.imgView.right+5, 0, self.width-20, 20)).labelFont(kFontTheme12).labelTitleColor(kColorTheme8a90a6);
        [self addSubview:self.imgView];
        [self addSubview:self.label];
    }
    return self;
}

@end

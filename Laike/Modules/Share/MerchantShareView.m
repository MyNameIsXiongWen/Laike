//
//  ConsultantShareView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/6.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MerchantShareView.h"
#import "MainBusinessShareView.h"

@interface MerchantShareView ()

@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UIImageView *sloganImgView;
@property (nonatomic, strong) UIImageView *miniCodeImgView;
@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *industryLabel;

@property (nonatomic, strong) DataView *consultDataView;
@property (nonatomic, strong) DataView *consultantDataView;
@property (nonatomic, strong) DataView *fansDataView;
@property (nonatomic, strong) DataView *likeDataView;

@property (nonatomic, strong) ShareBottomView *bottomView;

@end

@implementation MerchantShareView

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
    }
    return self;
}

- (void)configUI {
    self.bkgView = UIView.viewFrame(CGRectMake(40, 0, kScreenW-80, 390)).bkgColor(kColorThemefff);
    self.bkgView.userInteractionEnabled = YES;
    [self.bkgView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBkgView:)]];
    [self addSubview:self.bkgView];
    
    
    self.avatarImgView = UIImageView.ivFrame(CGRectMake((self.bkgView.width-80)/2, 20, 80, 80)).ivCornerRadius(40);
    self.nameLabel = UILabel.labelFrame(CGRectMake(20, self.avatarImgView.bottom+15, self.bkgView.width-40, 25)).labelFont(kMediumFontTheme18).labelTitleColor(kColorTheme2a303c).labelTextAlignment(NSTextAlignmentCenter);
    self.descLabel = UILabel.labelFrame(CGRectMake(20, self.nameLabel.bottom+20, self.bkgView.width-40, 15)).labelFont(kFontTheme12).labelTitleColor(kColorTheme666);
    self.industryLabel = UILabel.labelFrame(CGRectMake(20, self.descLabel.bottom+20, self.bkgView.width-40, 15)).labelFont(kFontTheme12).labelTitleColor(kColorTheme666);
    [self.bkgView addSubview:self.avatarImgView];
    [self.bkgView addSubview:self.nameLabel];
    [self.bkgView addSubview:self.descLabel];
    [self.bkgView addSubview:self.industryLabel];
    
    CGFloat width = (self.bkgView.width-30)/4.0;
    self.consultDataView = [[DataView alloc] initWithFrame:CGRectMake(15, self.industryLabel.bottom+20, width, 45)];
    self.consultantDataView = [[DataView alloc] initWithFrame:CGRectMake(self.consultDataView.right, self.consultDataView.y, width, 45)];
    self.fansDataView = [[DataView alloc] initWithFrame:CGRectMake(self.consultantDataView.right, self.consultDataView.y, width, 45)];
    self.likeDataView = [[DataView alloc] initWithFrame:CGRectMake(self.fansDataView.right, self.consultDataView.y, width, 45)];
    [self.bkgView addSubview:self.consultDataView];
    [self.bkgView addSubview:self.consultantDataView];
    [self.bkgView addSubview:self.fansDataView];
    [self.bkgView addSubview:self.likeDataView];
    
    [self.bkgView addSubview:UIView.viewFrame(CGRectMake(self.consultDataView.right, self.consultDataView.y+5, 1, 35)).bkgColor(kColorThemeeee)];
    [self.bkgView addSubview:UIView.viewFrame(CGRectMake(self.consultantDataView.right, self.consultDataView.y+5, 1, 35)).bkgColor(kColorThemeeee)];
    [self.bkgView addSubview:UIView.viewFrame(CGRectMake(self.fansDataView.right, self.consultDataView.y+5, 1, 35)).bkgColor(kColorThemeeee)];
    [self.bkgView addSubview:UIView.viewFrame(CGRectMake(20, self.consultDataView.bottom+15, self.bkgView.width-40, 1)).bkgColor(kColorThemeeee)];
    
    self.sloganImgView = UIImageView.ivFrame(CGRectMake(15, self.bkgView.height-90, 130, 70));
    [self.bkgView addSubview:self.sloganImgView];
    self.miniCodeImgView = UIImageView.ivFrame(CGRectMake(self.bkgView.width-90, self.consultDataView.bottom+25, 70, 70));
    [self.bkgView addSubview:self.miniCodeImgView];
    self.logoImgView = UIImageView.ivFrame(CGRectMake(19, 19, 32, 32)).ivCornerRadius(16);
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
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.merchantHead)]];
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.merchantHead)]];
    self.nameLabel.text = userModel.merchantName;
    self.descLabel.text = kFormat(@"品牌简介：%@", userModel.merchantInfo);
    NSMutableArray *tempArray = NSMutableArray.array;
    for (NSDictionary *dic in userModel.industryList) {
        [tempArray addObject:dic[@"industryName"]];
    }
    self.industryLabel.text = kFormat(@"服务行业：%@", [tempArray componentsJoinedByString:@"、"]);
    self.consultDataView.countLabel.text = kFormat(@"%ld", userModel.consultCount);
    self.consultantDataView.countLabel.text = kFormat(@"%ld", userModel.consultantList.count);
    self.fansDataView.countLabel.text = kFormat(@"%ld", userModel.fansCount);
    self.likeDataView.countLabel.text = kFormat(@"%ld", userModel.likeCount);
    self.consultDataView.nameLabel.text = @"咨询";
    self.consultantDataView.nameLabel.text = @"顾问";
    self.fansDataView.nameLabel.text = @"粉丝";
    self.likeDataView.nameLabel.text = @"获赞";
    [self.sloganImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(userModel.headPath)]];
}

- (void)setMiniCodePath:(NSString *)miniCodePath {
    [self.miniCodeImgView sd_setImageWithURL:[NSURL URLWithString:kMiniCodePath(miniCodePath)]];
}

@end

@implementation DataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.countLabel = UILabel.labelFrame(CGRectMake(0, 0, self.width, 18)).labelTitleColor(kColorTheme2a303c).labelFont(kFontTheme14).labelTextAlignment(NSTextAlignmentCenter);
        self.nameLabel = UILabel.labelFrame(CGRectMake(0, self.height-15, self.width, 15)).labelTitleColor(kColorThemea4abb3).labelFont(kFontTheme12).labelTextAlignment(NSTextAlignmentCenter);
        [self addSubview:self.countLabel];
        [self addSubview:self.nameLabel];
    }
    return self;
}

@end

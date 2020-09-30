//
//  MainBusinessShareView.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/5.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "MainBusinessShareView.h"
#import "QHWHouseModel.h"
#import "QHWStudyModel.h"
#import "QHWMigrationModel.h"
#import "QHWStudentModel.h"
#import "QHWTreatmentModel.h"
#import "QHWActivityModel.h"
#import "UserModel.h"

@interface MainBusinessShareView ()

@property (nonatomic, strong) UIView *bkgView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UIImageView *nameImgView;
@property (nonatomic, strong) UIImageView *miniCodeImgView;
@property (nonatomic, strong) UIImageView *sloganImgView;
@property (nonatomic, strong) UIImageView *logoImgView;

@property (nonatomic, strong) UIView *contentBkgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) ShareBottomView *bottomView;

@end

@implementation MainBusinessShareView

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
    
    self.avatarImgView = UIImageView.ivFrame(CGRectMake(15, 15, 50, 50)).ivCornerRadius(25).ivBorderColor(kColorTheme2a303c);
    self.nameImgView = UIImageView.ivFrame(CGRectMake(self.avatarImgView.right+15, 25, 110, 30));
    [self.bkgView addSubview:self.avatarImgView];
    [self.bkgView addSubview:self.nameImgView];
    
    self.contentBkgView = UIView.viewFrame(CGRectMake(20, self.avatarImgView.bottom+15, self.bkgView.width-40, 340)).bkgColor(kColorThemefff).cornerRadius(5);
    [self.contentBkgView addShadowWithRadius:5 Opacity:0.1];
    [self.bkgView addSubview:self.contentBkgView];
    
    self.titleLabel = UILabel.labelFrame(CGRectMake(15, 0, self.contentBkgView.width-30, 45)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c);
    self.coverImgView = UIImageView.ivFrame(CGRectMake(15, self.titleLabel.bottom, self.contentBkgView.width-30, 180));
    [self.contentBkgView addSubview:self.titleLabel];
    [self.contentBkgView addSubview:self.coverImgView];
    
    self.sourceLabel = UILabel.labelFrame(CGRectMake(15, self.contentBkgView.height-50, self.contentBkgView.width-100, 50)).labelFont(kFontTheme14).labelTitleColor(kColorTheme6d7278);
    self.typeLabel = UILabel.labelFrame(CGRectMake(self.contentBkgView.width-70, self.sourceLabel.y+15, 70, 20)).labelFont(kFontTheme14).labelTitleColor(kColorTheme666).labelBkgColor(kColorThemee4e4e4).labelCornerRadius(3);
    [self.contentBkgView addSubview:self.sourceLabel];
    [self.contentBkgView addSubview:self.typeLabel];
    [self.contentBkgView addSubview:UIView.viewFrame(CGRectMake(15, self.contentBkgView.height-50, self.contentBkgView.width-30, 1)).bkgColor(kColorThemeeee)];
    
    self.miniCodeImgView = UIImageView.ivFrame(CGRectMake(self.bkgView.width-85, self.contentBkgView.bottom+20, 70, 70));
    self.sloganImgView = UIImageView.ivFrame(CGRectMake(self.miniCodeImgView.left-140, self.miniCodeImgView.y+20, 120, 30)).ivImage(kImageMake(@"share_slogan"));
    [self.bkgView addSubview:self.miniCodeImgView];
    [self.bkgView addSubview:self.sloganImgView];
    self.logoImgView = UIImageView.ivFrame(CGRectMake(19, 19, 32, 32)).ivBkgColor(kColorThemefff).ivCornerRadius(16);
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
    if (self.mainBusinessDetailModel) {
        if (!self.mainBusinessDetailModel.snapShotImage) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bkgView.width, self.bkgView.height), NO, UIScreen.mainScreen.scale);
            [self.bkgView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.mainBusinessDetailModel.snapShotImage = screenShotImage;
        }
        return self.mainBusinessDetailModel.snapShotImage;
    }
    if (self.liveModel) {
        if (!self.liveModel.snapShotImage) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bkgView.width, self.bkgView.height), NO, UIScreen.mainScreen.scale);
            [self.bkgView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.liveModel.snapShotImage = screenShotImage;
        }
        return self.liveModel.snapShotImage;
    }
    return UIImage.new;
}

- (void)setMainBusinessDetailModel:(QHWMainBusinessDetailBaseModel *)mainBusinessDetailModel {
    _mainBusinessDetailModel = mainBusinessDetailModel;
    self.titleLabel.text = mainBusinessDetailModel.name;
    NSArray *displayArray;
    NSString *topImgPath;
    NSString *title;
    switch (mainBusinessDetailModel.businessType) {
        case 1:
        {
            QHWHouseModel *houseModel = (QHWHouseModel *)mainBusinessDetailModel;
            displayArray = @[@{@"key": @"总价", @"value": kFormat(@"¥%@万起", [NSString formatterWithMoneyValue:houseModel.totalPrice])},
                             @{@"key": @"面积", @"value": kFormat(@"%@-%@m²", [NSString formatterWithValue:houseModel.areaMin], [NSString formatterWithValue:houseModel.areaMax])},
                             @{@"key": @"国家/地区", @"value": houseModel.countryName}];
            topImgPath = @"share_house";
            title = @"海外房产";
        }
            break;
        case 2:
        {
            QHWStudyModel *studyModel = (QHWStudyModel *)mainBusinessDetailModel;
            displayArray = @[@{@"key": @"费用", @"value": kFormat(@"¥%@万", [NSString formatterWithMoneyValue:studyModel.serviceFee])},
                             @{@"key": @"天数", @"value": kFormat(@"%ld天", (long)studyModel.tripCycle)},
                             @{@"key": @"国家/地区", @"value": studyModel.studyCountryName ?: @""}];
            topImgPath = @"share_study";
            title = @"海外游学";
        }
            break;
        case 3:
        {
            QHWMigrationModel *migrationModel = (QHWMigrationModel *)mainBusinessDetailModel;
            displayArray = @[@{@"key": @"身份类型", @"value": migrationModel.dentityTypeName ?: @""},
                             @{@"key": @"办理周期", @"value": migrationModel.handleCycle ?: @""},
                             @{@"key": @"国家/地区", @"value": migrationModel.countryName ?: @""}];
            topImgPath = @"share_migration";
            title = @"海外移民";
            self.titleLabel.text = kFormat(@"%@+%@", migrationModel.migrationItem, migrationModel.name);
        }
            break;
        case 4:
        {
            QHWStudentModel *studentModel = (QHWStudentModel *)mainBusinessDetailModel;
            displayArray = @[@{@"key": @"费用", @"value": kFormat(@"¥%@万", [NSString formatterWithMoneyValue:studentModel.serviceFee])},
                             @{@"key": @"学历", @"value": studentModel.educationString ?: @""},
                             @{@"key": @"国家/地区", @"value": studentModel.countryName ?: @""}];
            topImgPath = @"share_student";
            title = @"海外留学";
        }
            break;
        case 102001:
        {
            QHWTreatmentModel *treatmentModel = (QHWTreatmentModel *)mainBusinessDetailModel;
            displayArray = @[@{@"key": @"医疗类型", @"value": treatmentModel.treatmentTypeList.firstObject[@"name"] ?: @""},
                             @{@"key": @"目标国家", @"value": treatmentModel.countryName ?: @""},
                             @{@"key": @"价格", @"value": kFormat(@"¥%@万", [NSString formatterWithMoneyValue:treatmentModel.serviceFee])}];
            topImgPath = @"share_treatment";
            title = @"海外医疗";
        }
            break;
        case 17:
        {
            QHWActivityModel *activityModel = (QHWActivityModel *)mainBusinessDetailModel;
            displayArray = @[@{@"key": @"活动地点", @"value": activityModel.cityName ?: @""},
                             @{@"key": @"活动类型", @"value": activityModel.industryName ?: @""},
                             @{@"key": @"活动时间", @"value": activityModel.startEnd ?: @""}];
            topImgPath = @"share_activity";
            title = @"活动";
        }
            break;
            
        default:
            break;
    }
    UserModel *user = UserModel.shareUser;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(user.headPath)]];
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(user.headPath)]];
    self.nameImgView.image = kImageMake(topImgPath);
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(mainBusinessDetailModel.coverPath)]];
    self.sourceLabel.text = kFormat(@"来源：%@", user.merchantName);
    self.typeLabel.text = kFormat(@" %@ ", title);
    [self.typeLabel sizeToFit];
    self.typeLabel.height = 20;
    self.typeLabel.x = self.contentBkgView.width - 15 - self.typeLabel.width;
    [self configUIData:displayArray];
}

- (void)setLiveModel:(LiveModel *)liveModel {
    _liveModel = liveModel;
    NSArray *displayArray = @[@{@"key": @"主办方", @"value": liveModel.bottomData.subjectName ?: @""},
                              @{@"key": @"主讲嘉宾", @"value": liveModel.mainName ?: @""},
                              @{@"key": @"观看人数", @"value": kFormat(@"%ld", liveModel.browseCount)}];
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(liveModel.bottomData.subjectHead)]];
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(liveModel.bottomData.subjectHead)]];
    self.nameImgView.image = kImageMake(@"share_live");
    self.titleLabel.text = liveModel.name;
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(liveModel.coverPath)]];
    self.sourceLabel.text = kFormat(@"来源：%@", liveModel.bottomData.subjectName);
    self.typeLabel.text = @" 直播 ";
    [self.typeLabel sizeToFit];
    self.typeLabel.height = 20;
    self.typeLabel.x = self.contentBkgView.width - 15 - self.typeLabel.width;
    [self configUIData:displayArray];
}

- (void)configUIData:(NSArray *)dataArray {
    CGFloat width = (self.contentBkgView.width-30)/3.0;
    __block CGFloat originX = 15;
    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *keylabel = UILabel.labelFrame(CGRectMake(originX, self.coverImgView.bottom+10, width, 20)).labelTitleColor(kColorThemec8c8c8).labelFont(kFontTheme12).labelTextAlignment(NSTextAlignmentCenter).labelText(obj[@"key"]);
        UILabel *valuelabel = UILabel.labelFrame(CGRectMake(keylabel.x, keylabel.bottom, width, 20)).labelTitleColor(idx == 0 ? kColorThemefb4d56 : kColorTheme2a303c).labelFont(kFontTheme12).labelTextAlignment(NSTextAlignmentCenter).labelText(obj[@"value"]);
        [self.contentBkgView addSubview:keylabel];
        [self.contentBkgView addSubview:valuelabel];
        originX += width;
    }];
}

- (void)setMiniCodePath:(NSString *)miniCodePath {
    [self.miniCodeImgView sd_setImageWithURL:[NSURL URLWithString:kMiniCodePath(miniCodePath)]];
}

@end

@implementation ShareBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = kColorThemefff;
        ShareBottomBtnView *leftBtnView = [[ShareBottomBtnView alloc] initWithFrame:CGRectMake(80, 0, 70, self.height)];
        leftBtnView.logoImgView.image = kImageMake(@"share_wechat");
        leftBtnView.logoLabel.text = @"微信好友";
        leftBtnView.tag = 1;
        
        ShareBottomBtnView *rightBtnView = [[ShareBottomBtnView alloc] initWithFrame:CGRectMake(leftBtnView.right+(kScreenW-300), 0, 70, self.height)];
        rightBtnView.logoImgView.image = kImageMake(@"share_friend");
        rightBtnView.logoLabel.text = @"朋友圈";
        rightBtnView.tag = 2;
        
        leftBtnView.viewAction(self, @selector(clickBtnView:));
        rightBtnView.viewAction(self, @selector(clickBtnView:));
        [self addSubview:leftBtnView];
        [self addSubview:rightBtnView];
    }
    return self;
}

- (void)clickBtnView:(UIGestureRecognizer *)gesture {
    UIView *gestureView = gesture.view;
    if (self.clickBtnBlock) {
        self.clickBtnBlock(gestureView.tag);
    }
}

@end

@implementation ShareBottomBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.logoImgView];
        [self addSubview:self.logoLabel];
    }
    return self;
}

- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = UIImageView.ivFrame(CGRectMake((self.width-40)/2, 15, 40, 40));
    }
    return _logoImgView;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = UILabel.labelFrame(CGRectMake(0, self.logoImgView.bottom+10, self.width, 14)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelTextAlignment(NSTextAlignmentCenter);
    }
    return _logoLabel;
}

@end

//
//  QHWShareView.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/26.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWShareView.h"
#import <UMShare/UMShare.h>
#import "UIImage+Category.h"
#import "QHWSystemService.h"
#import "MainBusinessShareView.h"
#import "CommunityArticleShareView.h"
#import "CommunityContentShareView.h"
#import "ConsultantShareView.h"
#import "MerchantShareView.h"
#import "QHWMainBusinessDetailBaseModel.h"
#import "CommunityDetailService.h"
#import "UserModel.h"
#import "LiveModel.h"
#import "QHWMigrationModel.h"

@interface QHWShareView () <UICollectionViewDelegate, UICollectionViewDataSource, MainBusinessShareViewDelegate, CommunityArticleShareViewDelegate, CommunityContentShareViewDelegate, MerchantShareViewDelegate, ConsultantShareViewDelegate>

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

///分享
@property (nonatomic, strong) QHWMainBusinessDetailBaseModel *mainBusinessDetailModel;
@property (nonatomic, strong) CommunityDetailModel *communityDetailModel;
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) LiveModel *liveModel;
@property (nonatomic, strong) UIImage *certificateImage;
@property (nonatomic, strong) MainBusinessShareView *mainBusinessShareView;
@property (nonatomic, strong) CommunityArticleShareView *articleShareView;
@property (nonatomic, strong) CommunityContentShareView *contentShareView;
@property (nonatomic, strong) ConsultantShareView *consultantShareView;
@property (nonatomic, strong) MerchantShareView *merchantShareView;
@property (nonatomic, assign) ShareType shareType;

@end

@implementation QHWShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict {
    if (self == [super initWithFrame:frame]) {
        self.shareType = [dict[@"shareType"] integerValue];
        if (self.shareType == ShareTypeMainBusiness) {
            self.mainBusinessDetailModel = dict[@"detailModel"];
        } else if (self.shareType == ShareTypeArticle || self.shareType == ShareTypeContent) {
            self.communityDetailModel = dict[@"detailModel"];
            if (self.shareType == ShareTypeContent && !self.communityDetailModel.videoImg) {
                if (self.communityDetailModel.fileType == 1 && self.communityDetailModel.filePathList.count > 0) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSDictionary *dic = self.communityDetailModel.filePathList.firstObject;
                        [dic[@"path"] thumbnailImageForVideoWithComplete:^(UIImage *img) {
                            self.communityDetailModel.videoImg = img;
                        }];
                    });
                }
            }
        } else if (self.shareType == ShareTypeConsultant || self.shareType == ShareTypeMerchant) {
            self.userModel = dict[@"detailModel"];
        } else if (self.shareType == ShareTypeCertification) {
            self.certificateImage = dict[@"certificateImage"];
            [self.dataArray removeLastObject];
        } else if (self.shareType == ShareTypeLive) {
            self.liveModel = dict[@"detailModel"];
        }
        self.popType = PopTypeBottom;
        [self addSubview:self.collectionView];
        [self addSubview:self.cancelBtn];
    }
    return self;
}

- (void)clickCancelBtn {
    [self dismiss];
}

#pragma mark ------------UICollectionViewDelegate-------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QHWShareCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QHWShareCollectionCell.class) forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.logoImgView.image = kImageMake(dic[@"logoImage"]);
    cell.logoLabel.text = dic[@"logoLabel"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataArray.count) {
        NSDictionary *dic = self.dataArray[indexPath.item];
        NSInteger platformType = [dic[@"platformType"] integerValue];
        if (platformType == 1000) {
            [self generatePoster];
        } else {
            [self dismiss];
            [self getShareContentWithPlatformType:platformType Poster:self.certificateImage];
        }
    }
}

- (void)generatePoster {
    NSInteger type = 1;
    NSString *idString;
    if (self.shareType == ShareTypeMainBusiness) {
        type = self.mainBusinessDetailModel.businessType;
        idString = self.mainBusinessDetailModel.id;
    } else if (self.shareType == ShareTypeArticle) {
        type = 5;
        idString = self.communityDetailModel.id;
    } else if (self.shareType == ShareTypeContent) {
        self.contentShareView = [[CommunityContentShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 650)];
        self.contentShareView.miniCodePath = self.communityDetailModel.qrCode;
        self.contentShareView.detailModel = self.communityDetailModel;
        self.contentShareView.delegate = self;
        [self.contentShareView show];
        return;
    } else if (self.shareType == ShareTypeConsultant) {
        self.consultantShareView = [[ConsultantShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 600)];
        self.consultantShareView.miniCodePath = self.userModel.qrCode;
        self.consultantShareView.userModel = self.userModel;
        self.consultantShareView.delegate = self;
        [self.consultantShareView show];
        return;
    } else if (self.shareType == ShareTypeMerchant) {
        self.merchantShareView = [[MerchantShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 510)];
        self.merchantShareView.miniCodePath = self.userModel.qrCode;
        self.merchantShareView.userModel = self.userModel;
        self.merchantShareView.delegate = self;
        [self.merchantShareView show];
        return;
    } else if (self.shareType == ShareTypeLive) {
        type = 103001;
        idString = self.liveModel.id;
    }
    [QHWSystemService.new getShareMiniCodeRequestWithBusinessType:type BusinessId:idString Completed:^(NSString * _Nonnull miniCodePath) {
        if (self.shareType == ShareTypeMainBusiness || self.shareType == ShareTypeLive) {
            self.mainBusinessShareView = [[MainBusinessShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 650)];
            self.mainBusinessShareView.miniCodePath = miniCodePath;
            if (self.shareType == ShareTypeLive) {
                self.mainBusinessShareView.liveModel = self.liveModel;
            } else {
                self.mainBusinessShareView.mainBusinessDetailModel = self.mainBusinessDetailModel;
            }
            self.mainBusinessShareView.delegate = self;
            [self.mainBusinessShareView show];
        } else if (self.shareType == ShareTypeArticle) {
            self.articleShareView = [[CommunityArticleShareView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 650)];
            self.articleShareView.miniCodePath = miniCodePath;
            self.articleShareView.detailModel = self.communityDetailModel;
            self.articleShareView.delegate = self;
            [self.articleShareView show];
        }
    }];
}

- (void)getShareContentWithPlatformType:(NSInteger)platformType Poster:(nullable UIImage *)poster {
    if ([[UMSocialManager defaultManager] isInstall:platformType]) {
        [self shareWebPageToPlatformType:platformType Poster:poster];
    } else {
        [SVProgressHUD showInfoWithStatus:@"您还未安装微信，请先安装微信"];
    }
}

//分享到第三方平台
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType Poster:(nullable UIImage *)poster {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (poster) {
        UMShareImageObject *imgObject = UMShareImageObject.new;
        imgObject.shareImage = poster;
        messageObject.shareObject = imgObject;
    } else {
        messageObject.shareObject = [self generateMainBusinessObjectPlatformType:platformType];
    }
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSDictionary *dict = error.userInfo;
            [SVProgressHUD showErrorWithStatus:dict[@"message"]];
        } else {
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
            } else {
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

///产品分享
- (UMShareObject *)generateMainBusinessObjectPlatformType:(UMSocialPlatformType)platformType {
    NSData *imageData;
    NSString *coverPath;
    NSString *name;
    NSString *urlPath;
    UIImage *img;
    if (self.shareType == ShareTypeMainBusiness) {
        coverPath = self.mainBusinessDetailModel.coverPath;
        name = self.mainBusinessDetailModel.name;
        urlPath = self.mainBusinessDetailModel.htmlUrl;
        if (self.mainBusinessDetailModel.businessType == 3) {
            QHWMigrationModel *migrationModel = (QHWMigrationModel *)self.mainBusinessDetailModel;
            name = kFormat(@"%@+%@", migrationModel.migrationItem, migrationModel.name);
        }
    } else if (self.shareType == ShareTypeArticle) {
        if (self.communityDetailModel.coverPathList.count > 0) {
            coverPath = self.communityDetailModel.coverPathList.firstObject[@"path"];
        }
        name = self.communityDetailModel.name;
        urlPath = self.communityDetailModel.htmlUrl;
    } else if (self.shareType == ShareTypeContent) {
        if (self.communityDetailModel.fileType == 1 && self.communityDetailModel.filePathList.count > 0) {
            img = self.communityDetailModel.videoImg;
        } else if (self.communityDetailModel.fileType == 2) {
            if (self.communityDetailModel.filePathList.count > 0) {
                coverPath = self.communityDetailModel.filePathList.firstObject[@"path"];
            }
        }
        name = self.communityDetailModel.title;
        urlPath = self.communityDetailModel.htmlUrl;
    } else if (self.shareType == ShareTypeConsultant) {
        name = kFormat(@"%@（%@）", self.userModel.realName, self.userModel.merchantName);
        coverPath = self.userModel.headPath;
        urlPath = self.userModel.html;
    } else if (self.shareType == ShareTypeMerchant) {
        name = self.userModel.merchantName;
        coverPath = self.userModel.merchantHead;
        urlPath = self.userModel.htmlUrl;
    } else if (self.shareType == ShareTypeLive) {
        name = self.liveModel.name;
        coverPath = self.liveModel.coverPath;
        urlPath = self.liveModel.htmlUrl;
    }
    if (!img) {
        if (coverPath.length > 0) {
            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kFilePath(coverPath)]];
        } else {
            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kImageLogo]];
        }
        img = [UIImage imageWithData:imageData];
        img = [self compressImage:img];
    }
    imageData = UIImageJPEGRepresentation(img, 0.7);
    if (platformType == UMSocialPlatformType_WechatSession) {
        NSString *sharePath;
        if (self.shareType == ShareTypeMainBusiness) {
            switch (self.mainBusinessDetailModel.businessType) {
                case 1:
                    sharePath = kHouseDetailPath(self.mainBusinessDetailModel.id);
                    break;
                case 2:
                    sharePath = kStudyDetailPath(self.mainBusinessDetailModel.id);
                    break;
                case 3:
                    sharePath = kMigrationDetailPath(self.mainBusinessDetailModel.id);
                    break;
                case 4:
                    sharePath = kStudentDetailPath(self.mainBusinessDetailModel.id);
                    break;
                case 102001:
                    sharePath = kTreatmentDetailPath(self.mainBusinessDetailModel.id);
                    break;
                default:
                    sharePath = kActivityDetailPath(self.mainBusinessDetailModel.id);
                    break;
            }
        } else if (self.shareType == ShareTypeArticle) {
            sharePath = kArticleDetailPath(self.communityDetailModel.id);
        } else if (self.shareType == ShareTypeContent) {
            sharePath = kConsultantDetailPath(self.communityDetailModel.subjectData.subjectId);
        } else if (self.shareType == ShareTypeConsultant) {
            sharePath = kConsultantDetailPath(self.userModel.id);
        } else if (self.shareType == ShareTypeMerchant) {
            sharePath = kMerchantDetailPath(self.userModel.id);
        } else if (self.shareType == ShareTypeLive) {
            sharePath = kLiveDetailPath(self.liveModel.id);
        }
        UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:name ?: @"" descr:@"" thumImage:imageData];
        shareObject.userName = kWXMini;
        shareObject.webpageUrl = sharePath;
        shareObject.path = sharePath;
        shareObject.hdImageData = imageData;
        shareObject.miniProgramType = UShareWXMiniProgramTypeRelease;//UShareWXMiniProgramTypeTest; // 可选体验版和开发板
        return shareObject;
    } else {
        UMShareWebpageObject *webObject = [UMShareWebpageObject shareObjectWithTitle:name descr:@"" thumImage:imageData];
        webObject.webpageUrl = urlPath ?: kHomeIndex;
        return webObject;
    }
}

- (UIImage *)compressImage:(UIImage *)img {
    CGSize size = img.size;
    if (size.width > 400 || size.height > 400) {
        size = CGSizeMake(400, 400);
    }
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

#pragma mark ------------ShareViewDelegate-------------
- (void)MainBusinessShareView_clickBottomBtnWithIndex:(NSInteger)index Image:(UIImage *)image {
    [self dismiss];
    [self.mainBusinessShareView dismiss];
    [self getShareContentWithPlatformType:index Poster:image];
}

- (void)CommunityArticleShareView_clickBottomBtnWithIndex:(NSInteger)index Image:(UIImage *)image {
    [self dismiss];
    [self.articleShareView dismiss];
    [self getShareContentWithPlatformType:index Poster:image];
}

- (void)CommunityContentShareView_clickBottomBtnWithIndex:(NSInteger)index Image:(UIImage *)image {
    [self dismiss];
    [self.contentShareView dismiss];
    [self getShareContentWithPlatformType:index Poster:image];
}

- (void)ConsultantShareView_clickBottomBtnWithIndex:(NSInteger)index Image:(UIImage *)image {
    [self dismiss];
    [self.consultantShareView dismiss];
    [self getShareContentWithPlatformType:index Poster:image];
}

- (void)MerchantShareView_clickBottomBtnWithIndex:(NSInteger)index Image:(UIImage *)image {
    [self dismiss];
    [self.merchantShareView dismiss];
    [self getShareContentWithPlatformType:index Poster:image];
}

#pragma mark ------------UI-------------
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        UILabel *label = UILabel.labelFrame(CGRectMake(0, 0, self.width, 50)).labelText(@"分享到").labelFont(kFontTheme16).labelTitleColor(kColorTheme8a90a6).labelTextAlignment(NSTextAlignmentCenter).labelBkgColor(kColorThemef5f5f5);
        [self addSubview:label];
        _cancelBtn = UIButton.btnFrame(CGRectMake(0, self.collectionView.bottom, kScreenW, 50)).btnTitle(@"取消").btnFont(kFontTheme16).btnTitleColor(kColorTheme2a303c).btnBkgColor(kColorThemef5f5f5).btnAction(self, @selector(clickCancelBtn));
    }
    return _cancelBtn;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(60, 80);
        CGFloat miniSpace = (kScreenW-self.dataArray.count*60)/(self.dataArray.count+1);
        layout.minimumInteritemSpacing = miniSpace;
        layout.sectionInset = UIEdgeInsetsMake(20, miniSpace, 20, miniSpace);
        
        _collectionView = [UICreateView initWithFrame:CGRectMake(0, 50, kScreenW, 120) Layout:layout Object:self];
        _collectionView.backgroundColor = kColorThemef5f5f5;
        [_collectionView registerClass:QHWShareCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(QHWShareCollectionCell.class)];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@{@"logoImage": @"share_wechat",
                         @"logoLabel": @"微信好友",
                         @"platformType":@(UMSocialPlatformType_WechatSession)},
                       @{@"logoImage": @"share_friend",
                         @"logoLabel": @"朋友圈",
                         @"platformType":@(UMSocialPlatformType_WechatTimeLine)},
                       @{@"logoImage": @"share_poster",
                         @"logoLabel": @"海报分享",
                         @"platformType":@(1000)}].mutableCopy;
    }
    return _dataArray;
}

@end

@implementation QHWShareCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self.contentView addSubview:self.logoImgView];
        [self.contentView addSubview:self.logoLabel];
    }
    return self;
}

- (UIImageView *)logoImgView {
    if (!_logoImgView) {
        _logoImgView = UIImageView.ivFrame(CGRectMake((self.width-50)/2.0, 0, 50, 50));
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

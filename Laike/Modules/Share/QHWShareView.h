//
//  QHWShareView.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/26.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "QHWPopView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ShareTypeMainBusiness, //产品和活动
    ShareTypeArticle, //海外头条
    ShareTypeContent, //海外圈子
    ShareTypeMerchant, //商户
    ShareTypeConsultant, //顾问
    ShareTypeCertification, //认证
    ShareTypeLive, //直播
    ShareTypeGallery //海报
} ShareType;

@class QHWShareCollectionCell;
@interface QHWShareView : QHWPopView

- (instancetype)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict;

@end

@interface QHWShareCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *logoLabel;

@end

NS_ASSUME_NONNULL_END

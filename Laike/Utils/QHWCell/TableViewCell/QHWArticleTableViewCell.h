//
//  QHWArticleTableViewCell.h
//  GoOverSeas
//  通用头条cell
//  Created by xiaobu on 2019/7/13.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHWCommunityArticleModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ArticleTypeImage = 1, // 3图 上下排列
    ArticleTypeBoth, //都有 左右排列
    ArticleTypeText, //纯文字
} ArticleType;

@interface QHWArticleTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *articleTitleLabel;//标题
@property (nonatomic, strong, readonly) UILabel *articleIssuerLabel;//发行人

@property (nonatomic, strong) QHWCommunityArticleModel *articleModel;

///动态类型 取值范围：1-多图动态 2-少图动态 3-纯文字动态  introduction主要是为了显示
- (void)setType:(ArticleType)articleType introduction:(NSString *)introduction;

@end

NS_ASSUME_NONNULL_END

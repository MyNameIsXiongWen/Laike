//
//  CommunityArticleShareView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/5.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"
#import "CommunityDetailService.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CommunityArticleShareViewDelegate <NSObject>

@optional
- (void)CommunityArticleShareView_clickBottomBtnWithIndex:(NSInteger)index Image:(UIImage *)image;

@end

@interface CommunityArticleShareView : QHWPopView

@property (nonatomic, copy) NSString *miniCodePath;
@property (nonatomic, strong) CommunityDetailModel *detailModel;
@property (nonatomic, weak) id<CommunityArticleShareViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

//
//  CommunityContentShareView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/5.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"
#import "CommunityDetailService.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CommunityContentShareViewDelegate <NSObject>

@optional
- (void)CommunityContentShareView_clickBottomBtnWithIndex:(NSInteger)index Image:(UIImage *)image;

@end

@interface CommunityContentShareView : QHWPopView

@property (nonatomic, copy) NSString *miniCodePath;
@property (nonatomic, strong) CommunityDetailModel *detailModel;
@property (nonatomic, weak) id<CommunityContentShareViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

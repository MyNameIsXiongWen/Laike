//
//  CommunityContentShareView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/5.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "QHWPopView.h"
#import "CommunityDetailService.h"
#import "QHWShareBottomViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityContentShareView : QHWPopView

@property (nonatomic, copy) NSString *miniCodePath;
@property (nonatomic, strong) CommunityDetailModel *detailModel;
@property (nonatomic, weak) id<QHWShareBottomViewProtocol>delegate;

@end

NS_ASSUME_NONNULL_END

//
//  CommunityTableHeaderView.h
//  GoOverSeas
//
//  Created by 熊文 on 2020/5/17.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityTableHeaderView : UIView

///社区类型 1:头条  2:圈子
@property (nonatomic, assign) NSInteger communityType;
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSArray *consultantArray;

@end

NS_ASSUME_NONNULL_END

//
//  CommunityDetailViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/21.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "QHWCycleScrollView.h"
#import "QHWVideoPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityDetailViewController : UIViewController

@property (nonatomic, copy) NSString *communityId;
///社区类型 1:头条  2:圈子
@property (nonatomic, assign) NSInteger communityType;

@end

@class CommunityAutherView;
@interface CommunityArticleDetailHeaderView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) CommunityAutherView *autherView;
@property (nonatomic, strong) WKWebView *wkWebView;

@end

@class CommunityAutherView;
@interface CommunityContentDetailHeaderView : UIView

@property (nonatomic, strong) CommunityAutherView *autherView;
@property (nonatomic, strong) QHWCycleScrollView *cycleScrollView;
@property (nonatomic, strong) QHWVideoPlayerView *playerView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@interface CommunityAutherView : UIView

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UIImageView *tagImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, copy) void (^ clickLogoBlock)(void);
@property (nonatomic, copy) void (^ clickShareBlock)(void);

@end

NS_ASSUME_NONNULL_END

//
//  AllCommentViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/12.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllCommentViewController : UIViewController

@property (nonatomic, copy) NSString *communityId;
///社区类型 1:头条  2:圈子
@property (nonatomic, assign) NSInteger communityType;
///文件类型：1--视频；2-图片（限制最多9张）
@property (nonatomic, assign) NSInteger fileType;

@end

@interface AllCommentBottomView : UIView

@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, copy) void (^ clickCommentBlock)(void);

@end

NS_ASSUME_NONNULL_END

//
//  CommunityDetailBottomView.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/9/24.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface CommunityDetailBottomView : UIView

@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, copy) void (^ clickCommentBlock)(void);
@property (nonatomic, copy) void (^ clickAllCommentBlock)(void);
@property (nonatomic, copy) void (^ clickCollectBlock)(void);
@property (nonatomic, copy) void (^ clickLikeBlock)(void);

@end

NS_ASSUME_NONNULL_END

//
//  CommentBottomView.h
//  GoOverSeas
//
//  Created by manku on 2019/8/8.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentBottomView : UIView

@property (nonatomic, strong, readonly) UILabel *commentLbl;
@property (nonatomic, strong, readonly) UIButton *praiseButton;
@property (nonatomic, copy) void (^ bottomViewCommentBlock)(void);
@property (nonatomic, copy) void (^ bottomViewPraiseBlock)(void);

@end

NS_ASSUME_NONNULL_END

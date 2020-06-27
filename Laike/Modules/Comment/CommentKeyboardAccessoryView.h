//
//  CommentKeyboardAccessoryView.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentKeyboardAccessoryView : UIView

@property (nonatomic, strong) UITextView *accessoryTextView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, copy) void (^ sendCommentBlock)(NSString *content);
- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder;
- (void)show;
- (void)dismissSelf;

@end

NS_ASSUME_NONNULL_END

//
//  CommentKeyboardAccessoryView.m
//  GoOverSeas
//
//  Created by xiaobu on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "CommentKeyboardAccessoryView.h"
#import <IQKeyboardManager.h>

@interface CommentKeyboardAccessoryView () <UITextViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) UIView *blackView;

@end

@implementation CommentKeyboardAccessoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.keyBoardHeight = 0;
        [self appendWithViewsWithPlaceHolder:placeHolder];
        IQKeyboardManager.sharedManager.enable = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// 键盘监听事件
- (void)keyboardWillShow:(NSNotification*)sender{
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [value CGRectValue].size.height;
    self.keyBoardHeight = height;
    [self.accessoryTextView becomeFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.top = 10;
        self.contentView.height = self.accessoryTextView.height+10;
        self.sendButton.top = self.contentView.bottom;
        self.bgView.height = self.contentView.height + 40 + 10;
        self.bgView.top = kScreenH - (self.keyBoardHeight + self.bgView.height);
        self.blackView.height = self.bgView.top;
    }];
}

//第三方键盘问题
- (void)keyboardWillHide:(NSNotification*)sender{
    [self.accessoryTextView resignFirstResponder];
    self.bgView.top = kScreenH;
}

- (void)show {
    [self.getCurrentMethodCallerVC.view addSubview:self.bgView];
    [self.getCurrentMethodCallerVC.view addSubview:self.blackView];
}

- (void)clickSendBtn {
    if ([NSString isEmpty:self.accessoryTextView.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入内容"];
        return;
    }
    if (self.sendCommentBlock) {
        self.sendCommentBlock(self.accessoryTextView.text);
    }
}

#pragma mark ------------UITextViewDelegate-------------
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.accessoryTextView == textView) {
        return YES;
    }
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.accessoryTextView == textView) {
        static CGFloat maxHeight = 50.0f;
        CGRect frame = textView.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        CGSize size = [textView sizeThatFits:constraintSize];
        if (size.height<=frame.size.height) {
            size.height=frame.size.height;
        } else {
            if (size.height >= maxHeight) {
                size.height = maxHeight;
                self.accessoryTextView.scrollEnabled = YES;
            } else {
                self.accessoryTextView.scrollEnabled = NO;
            }
        }
        self.accessoryTextView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    }
}

- (void)dismissSelf {
    [self.accessoryTextView resignFirstResponder];
    [self removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self.blackView removeFromSuperview];
}

#pragma mark ------------UI-------------
- (void)appendWithViewsWithPlaceHolder:(NSString *)placeHolder {
    self.bgView = UIView.viewFrame(CGRectMake(0, kScreenH, kScreenW, 120)).bkgColor(kColorThemefff);
    
    self.blackView = UIView.viewFrame(CGRectMake(0, 0, kScreenW, 0));
    UITapGestureRecognizer *blackTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [self.blackView addGestureRecognizer:blackTap];
    
    UIView *line = UIView.viewFrame(CGRectMake(0, 0, self.bgView.width, 0.5)).bkgColor(kColorThemeeee);
    [self.bgView addSubview:line];
    
    self.contentView = [UICreateView initWithFrame:CGRectMake(15, 10, kScreenW-30, 80) BackgroundColor:kColorThemef5f5f5 CornerRadius:4];
    [self.bgView addSubview:self.contentView];
    
    self.accessoryTextView = UITextView.tvFrame(CGRectMake(15, 5, self.contentView.width-30, 70)).tvFont(kFontTheme14).tvTextColor(kColorTheme2a303c).tvPlaceholder(placeHolder);
    self.accessoryTextView.backgroundColor = UIColor.clearColor;
    self.accessoryTextView.tag = 999;
    self.accessoryTextView.delegate = self;
    [self.contentView addSubview:self.accessoryTextView];
    
    self.sendButton = UIButton.btnFrame(CGRectMake(kScreenW-65, self.contentView.bottom, 50, 40)).btnTitle(@"发布").btnFont(kFontTheme15).btnTitleColor(kColorThemefb4d56).btnAction(self, @selector(clickSendBtn));
    self.sendButton.contentHorizontalAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.sendButton];
}

@end

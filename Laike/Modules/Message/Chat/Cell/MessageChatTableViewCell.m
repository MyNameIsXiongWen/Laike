//
//  MessageChatTableViewCell.m
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MessageChatTableViewCell.h"

@implementation MessageChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kColorThemef5f5f5;
        [self.contentView addSubview:self.avatarImgView];
        [self.contentView addSubview:self.container];
        [self.contentView addSubview:self.indicator];
        [self.contentView addSubview:self.retryView];
        [self.contentView addSubview:self.statusLabel];
    }
    return self;
}

- (void)fillWithData:(MessageChatMsgCellData *)data {
    _messageData = data;
    [self.avatarImgView sd_setImageWithURL:data.avatarUrl placeholderImage:kPlaceHolderImage_Avatar];
    self.indicator.hidden = !data.isSelf;
//    self.statusLabel.hidden = !data.isSelf;
    self.statusLabel.hidden = YES;
    if (data.status == Msg_Status_Fail) {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        self.retryView.image = kImageMake(@"chat_msg_send_error");
    } else {
        if (data.status == Msg_Status_Sending) {
            [self.indicator startAnimating];
            self.indicator.hidden = NO;
        } else if (data.status == Msg_Status_Succ) {
            [self.indicator stopAnimating];
            self.indicator.hidden = YES;
        } else {
            [self.indicator stopAnimating];
            self.indicator.hidden = YES;
        }
        self.retryView.image = nil;
    }
    CGSize csize = self.msgModel.size;
    self.container.y = 1.5+7.5;
    self.container.width = csize.width;
    self.container.height = csize.height;
    if (data.isSelf) {
        self.avatarImgView.x = kScreenW-20-40;
//        self.container.height -= 15;//减掉已读未读状态的高度
        self.container.x = kScreenW-self.avatarImgView.width-25-csize.width;
        self.bubbleImgView.image = [[UIImage imageNamed:@"chat_bubble_self"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 5, 5, 12) resizingMode:UIImageResizingModeStretch];
        self.indicator.x = self.container.x-30;
    } else {
        self.avatarImgView.x = 20;
        self.container.x = self.avatarImgView.width+25;
        self.bubbleImgView.image = [[UIImage imageNamed:@"chat_bubble_other"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 12, 5, 5) resizingMode:UIImageResizingModeStretch];
    }
    self.bubbleImgView.frame = self.container.bounds;
    self.indicator.centerY = self.container.centerY;
    self.retryView.frame = self.indicator.frame;
    self.statusLabel.frame = CGRectMake(self.avatarImgView.x-60, csize.height-5, 50, 15);
    self.statusLabel.text = self.msgModel.isPeerReaded ? @"已读" : @"未读";
    self.statusLabel.textColor = self.msgModel.isPeerReaded ? kColorTheme666 : kColorThemefb4d56;
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(revokeContent)) {
        return YES;
    }
    return NO;
}

- (void)revokeContent {
    if ([self.delegate respondsToSelector:@selector(revokeMessage:)]) {
        [self.delegate revokeMessage:self];
    }
}

#pragma mark ------------MessageChatTableViewCellDelegate-------------
- (void)onLongPress:(UIGestureRecognizer *)recognizer {
    return;
    if ([ChatMsgModel getSecondFormStartTime:self.messageData.innerMessage.timestamp] <= 120) {
        if (![self.messageData.cellReuseIdentifier isEqualToString:@"MessageChatTextTableViewCell"]) {
            UIMenuController *menu = [UIMenuController sharedMenuController];
            if (!menu.isMenuVisible) {
                if ([self becomeFirstResponder]) {
                    UIMenuItem *revokeItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revokeContent)];
                    menu.menuItems = @[revokeItem];
                    [menu setTargetRect:self.container.bounds inView:self.container];
                    [menu setMenuVisible:YES animated:YES];
                }
            }
        }
    }
    if([recognizer isKindOfClass:[UILongPressGestureRecognizer class]] &&
       recognizer.state == UIGestureRecognizerStateBegan){
        if(_delegate && [_delegate respondsToSelector:@selector(onLongPressMessage:)]){
            [_delegate onLongPressMessage:self];
        }
    }
}

- (void)onRetryMessage:(UIGestureRecognizer *)recognizer {
    if (_messageData.status == Msg_Status_Fail) {
        if (_delegate && [_delegate respondsToSelector:@selector(onRetryMessage:)]) {
            [_delegate onRetryMessage:self];
        }
    }
}

- (void)onSelectMessage:(UIGestureRecognizer *)recognizer {
    if(_delegate && [_delegate respondsToSelector:@selector(onSelectMessage:)]){
        [_delegate onSelectMessage:self];
    }
}

- (void)onSelectMessageAvatar:(UIGestureRecognizer *)recognizer {
    if(_delegate && [_delegate respondsToSelector:@selector(onSelectMessageAvatar:)]){
        [_delegate onSelectMessageAvatar:self];
    }
}

#pragma mark ------------UI-------------
- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = UIImageView.ivFrame(CGRectMake(20, 7.5, 40, 40)).ivCornerRadius(20);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectMessageAvatar:)];
        [_avatarImgView addGestureRecognizer:tap];
        [_avatarImgView setUserInteractionEnabled:YES];
    }
    return _avatarImgView;
}

- (UIView *)container {
    if (!_container) {
        _container = UIView.viewInit();
        [_container addSubview:self.bubbleImgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectMessage:)];
        [_container addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [_container addGestureRecognizer:longPress];
    }
    return _container;
}
- (UIImageView *)bubbleImgView {
    if (!_bubbleImgView) {
        _bubbleImgView = UIImageView.ivInit().ivMode(UIViewContentModeScaleToFill);
        _bubbleImgView.hidden = YES;
    }
    return _bubbleImgView;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _indicator;
}

- (UIImageView *)retryView {
    if (!_retryView) {
        _retryView = UIImageView.ivInit();
        _retryView.userInteractionEnabled = YES;
        UITapGestureRecognizer *resendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRetryMessage:)];
        [_retryView addGestureRecognizer:resendTap];
    }
    return _retryView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = UILabel.labelInit().labelText(@"未读").labelFont(kFontTheme10).labelTitleColor(kColorThemefb4d56).labelTextAlignment(NSTextAlignmentRight);
        _statusLabel.hidden = YES;
    }
    return _statusLabel;
}

@end

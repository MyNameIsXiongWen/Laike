//
//  MessageChatTextTableViewCell.m
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MessageChatTextTableViewCell.h"

@implementation MessageChatTextTableViewCell

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
        [self.container addSubview:self.contentLabel];
        self.bubbleImgView.hidden = NO;
    }
    return self;
}

- (void)fillWithData:(MessageChatMsgCellData *)data {
    [super fillWithData:data];
    
    self.contentLabel.frame = CGRectMake(15, 10, self.messageData.contentSize.width-25, self.messageData.contentSize.height-20);
    if (data.isSelf) {
        self.contentLabel.x = 10;
//        self.contentLabel.height -= 15;
        self.bubbleImgView.image = [[UIImage imageNamed:@"chat_bubble_self_text"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 5, 5, 12) resizingMode:UIImageResizingModeStretch];
    } else {
        self.bubbleImgView.image = [[UIImage imageNamed:@"chat_bubble_other"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 12, 5, 5) resizingMode:UIImageResizingModeStretch];
    }
    self.contentLabel.attributedText = data.emojiUtil.richTextAttribute;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyContent) || action == @selector(addCommonWords) || action == @selector(revokeContent)) {
        return YES;
    }
    return NO;
}

- (void)onLongPress:(UIGestureRecognizer *)recognizer {
    return;
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (!menu.isMenuVisible) {
        if ([self becomeFirstResponder]) {
            UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyContent)];
            UIMenuItem *addItem = [[UIMenuItem alloc] initWithTitle:@"添加到常用语" action:@selector(addCommonWords)];
            UIMenuItem *revokeItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revokeContent)];
            if ([ChatMsgModel getSecondFormStartTime:self.messageData.innerMessage.timestamp] <= 120) {
                menu.menuItems = @[copyItem, addItem, revokeItem];
            } else {
                menu.menuItems = @[copyItem, addItem];
            }
            [menu setTargetRect:self.contentLabel.bounds inView:self.contentLabel];
            [menu setMenuVisible:YES animated:YES];
        }
    }
}

- (void)revokeContent {
    if ([self.delegate respondsToSelector:@selector(revokeMessage:)]) {
        [self.delegate revokeMessage:self];
    }
}

- (void)copyContent {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.contentLabel.text;
    [SVProgressHUD showInfoWithStatus:@"已复制到剪切板"];
}

- (void)addCommonWords {
    if (self.contentLabel.text.length > 200) {
        [SVProgressHUD showInfoWithStatus:@"文字超过常用语最大限制200字"];
        return;
    }
//    [QHWHttpLoading showWithMaskTypeBlack];
//    [QHWHttpManager.sharedInstance QHW_POST:kUserCommonWordAdd parameters:@{@"userImCommonLanguageContent": self.contentLabel.text} success:^(id responseObject) {
//        [SVProgressHUD showInfoWithStatus:@"已添加到常用语"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddCommonWord object:nil];
//    } failure:^(NSError *error) {
//
//    }];
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.labelInit().labelFont(kFontTheme16).labelTitleColor(kColorTheme000).labelNumberOfLines(0);
    }
    return _contentLabel;
}

@end

//
//  MessageChatPhoneTableViewCell.m
//  Guider
//
//  Created by jason on 2019/10/3.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MessageChatPhoneTableViewCell.h"

@interface MessageChatPhoneTableViewCell ()

@property (nonatomic, strong) UILabel *authStatusLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation MessageChatPhoneTableViewCell

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
        [self.container addSubview:self.titleLabel];
        [self.container addSubview:self.contentLabel];
        [self.container addSubview:self.line];
        [self.container addSubview:self.authStatusLabel];
        self.bubbleImgView.hidden = NO;
    }
    return self;
}

- (void)fillWithData:(MessageChatMsgCellData *)data {
    [super fillWithData:data];
    NSDictionary *dictionary = data.innerMessage.ext;
    if ([dictionary isKindOfClass:NSDictionary.class]) {
        if ([dictionary[@"message_attr_is_authorize"] boolValue]) { //授权消息
            //授权消息状态  0 等待 1 同意 2 拒绝
            NSInteger authStatus = [dictionary[@"message_attr_authorize_status"] integerValue];
            NSString *phone = dictionary[@"message_attr_authorize_phone"];
            self.contentLabel.text = kFormat(@"为了方便联络，系统会把您的手机号%@展示给我，其他顾问看不到，信息已经加密", phone);
            if (authStatus == 1) {
                self.authStatusLabel.text = @"对方已同意";
            } else if (authStatus == 2) {
                self.authStatusLabel.text = @"对方已拒绝";
            } else if (authStatus == 0) {
                self.authStatusLabel.text = @"等待对方授权";
            }
        }
    }
}

#pragma mark ------------UI------------
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.labelFrame(CGRectMake(15, 0, 205, 35)).labelText(@"是否同意我帮您？").labelFont(kFontTheme13).labelTitleColor(kColorTheme666);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = UILabel.labelFrame(CGRectMake(self.titleLabel.left, self.titleLabel.bottom, 205, 75)).labelFont(kFontTheme15).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
    }
    return _contentLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.viewFrame(CGRectMake(self.titleLabel.left, self.contentLabel.bottom+5, 205, 0.5)).bkgColor(kColorThemeeee);
    }
    return _line;
}

- (UILabel *)authStatusLabel {
    if (!_authStatusLabel) {
        _authStatusLabel = UILabel.labelFrame(CGRectMake(self.titleLabel.left, self.line.bottom, 205, 40)).labelText(@"等待对方授权").labelFont(kFontTheme16).labelTitleColor(kColorThemefb4d56).labelTextAlignment(NSTextAlignmentCenter);
    }
    return _authStatusLabel;
}

@end

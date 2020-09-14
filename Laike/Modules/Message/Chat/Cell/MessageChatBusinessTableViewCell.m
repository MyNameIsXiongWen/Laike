//
//  MessageChatBusinessTableViewCell.m
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MessageChatBusinessTableViewCell.h"
#import "QHWMainBusinessDetailBaseModel.h"

@interface MessageChatBusinessTableViewCell ()

@property (nonatomic, strong) UIView *contentBkgView;//内容view，放一起区分消息是谁发的时候好操作一些
@property (nonatomic, strong) UIImageView *schemeImgView;
@property (nonatomic, strong) UILabel *schemeNameLabel;
@property (nonatomic, strong) UILabel *schemeInfoLabel;
@property (nonatomic, strong) UILabel *shopNameLabel;

@end

@implementation MessageChatBusinessTableViewCell

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
        [self.container addSubview:self.contentBkgView];
        self.bubbleImgView.hidden = NO;
    }
    return self;
}

- (void)fillWithData:(MessageChatMsgCellData *)data {
    [super fillWithData:data];
    _contentBkgView.frame = self.container.bounds;
    if (!data.isSelf) {
        _contentBkgView.x = 5;
    }
    EMCustomMessageBody *customElem = (EMCustomMessageBody *)data.innerMessage.body;
    NSDictionary *dictionary = customElem.ext;
    if (dictionary) {
        EMCustomMsgModel *msgModel = [EMCustomMsgModel yy_modelWithJSON:dictionary];
        self.schemeNameLabel.height = msgModel.contentHeight;
        self.schemeInfoLabel.y = self.schemeNameLabel.bottom+5;
        self.schemeInfoLabel.height = msgModel.subContentHeight;
        self.shopNameLabel.y = self.schemeInfoLabel.bottom+5;
        [self.schemeImgView sd_setImageWithURL:[NSURL URLWithString:kFilePath(msgModel.message_attr_subject_img)]];
        self.schemeNameLabel.text = msgModel.message_attr_subject_content;
        self.schemeInfoLabel.text = msgModel.message_attr_subject_sub_content;
        self.shopNameLabel.text = msgModel.message_attr_subject_bottom;
    }
}

#pragma mark ------------UI-------------
- (UIView *)contentBkgView {
    if (!_contentBkgView) {
        _contentBkgView = UIView.viewInit().bkgColor(UIColor.clearColor);
    }
    return _contentBkgView;
}

- (UIImageView *)schemeImgView {
    if (!_schemeImgView) {
        _schemeImgView = UIImageView.ivFrame(CGRectMake(10, 10, 205, 115)).ivBkgColor(kColorThemeeee);
        [self.contentBkgView addSubview:_schemeImgView];
    }
    return _schemeImgView;
}

- (UILabel *)schemeNameLabel {
    if (!_schemeNameLabel) {
        _schemeNameLabel = UILabel.labelFrame(CGRectMake(10, self.schemeImgView.bottom+5, 205, 17)).labelFont(kFontTheme14).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
        [self.contentBkgView addSubview:_schemeNameLabel];
    }
    return _schemeNameLabel;
}

- (UILabel *)schemeInfoLabel {
    if (!_schemeInfoLabel) {
        _schemeInfoLabel = UILabel.labelFrame(CGRectMake(10, self.schemeNameLabel.bottom+5, self.schemeNameLabel.width, 14)).labelFont(kFontTheme12).labelTitleColor(kColorTheme2a303c).labelNumberOfLines(0);
        [self.contentBkgView addSubview:_schemeInfoLabel];
    }
    return _schemeInfoLabel;
}

- (UILabel *)shopNameLabel {
    if (!_shopNameLabel) {
        _shopNameLabel = UILabel.labelFrame(CGRectMake(10, self.schemeInfoLabel.bottom+5, self.schemeNameLabel.width, 17)).labelFont(kFontTheme14).labelTitleColor(kColorThemefb4d56);
        [self.contentBkgView addSubview:_shopNameLabel];
    }
    return _shopNameLabel;
}

@end

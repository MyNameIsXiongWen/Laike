//
//  MessageChatMsgCellData.m
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import "MessageChatMsgCellData.h"

@implementation MessageChatMsgCellData

- (id)init {
    self = [super init];
    if (self) {
        _status = Msg_Status_Init;
        _emojiUtil = ChatEmojiUtil.new;
    }
    return self;
}

- (CGFloat)cellHeight {
    CGSize containerSize = [self contentSize];
    CGFloat height = containerSize.height;
    height += 15;
    height = MAX(height, 55);
    return height;
}

- (CGSize)contentSize {
    EMMessageBody *body = self.innerMessage.body;
    CGSize resultSize = CGSizeZero;
    switch (body.type) {
        case EMMessageBodyTypeText:
        {//文字
            self.cellReuseIdentifier = @"MessageChatTextTableViewCell";
            EMTextMessageBody *textElem = (EMTextMessageBody *)body;
            [self.emojiUtil getRichTextAttributeString:textElem.text Font:kFontTheme16];
            UILabel *label = UILabel.labelFrame(CGRectMake(0, 0, 205, 10)).labelFont(kFontTheme16).labelTitleColor(kColorTheme000).labelNumberOfLines(0);
            label.attributedText = self.emojiUtil.richTextAttribute;
            [label sizeToFit];
            resultSize = CGSizeMake(label.width+25, label.height+20);
            label = nil;
            
            NSDictionary *ext = self.innerMessage.ext;
            if ([ext isKindOfClass:NSDictionary.class]) {
                if ([ext[@"message_attr_is_subject"] boolValue]) { //业务消息
                    self.cellReuseIdentifier = @"MessageChatBusinessTableViewCell";
                    EMCustomMsgModel *msgModel = [EMCustomMsgModel yy_modelWithDictionary:ext];
                    resultSize = CGSizeMake(225+5, msgModel.msgHeight);
                }
                if ([ext[@"message_attr_is_authorize"] boolValue]) { //授权消息
                    self.cellReuseIdentifier = @"MessageChatPhoneTableViewCell";
                    resultSize = CGSizeMake(225+5, 155);
                }
            }
            
//            CGRect rect = [self.richTextAttribute boundingRectWithSize:CGSizeMake(205, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
//            resultSize = CGSizeMake(rect.size.width+25, rect.size.height+20);
        }
            break;
            
        case EMMessageBodyTypeImage:
        {//图片
            self.cellReuseIdentifier = @"MessageChatImageTableViewCell";
            EMImageMessageBody *imageElem = (EMImageMessageBody *)body;
            UIImage *img = [UIImage imageWithContentsOfFile:imageElem.thumbnailLocalPath];
            if (img) {
                resultSize = [self getImageSizeBySize:img.size];
            } else {
                img = [UIImage imageWithContentsOfFile:imageElem.localPath];
                if (img) {
                    resultSize = [self getImageSizeBySize:img.size];
                } else {
                    resultSize = [self getImageSizeBySize:imageElem.size];
                }
            }
            
//            BOOL isDir = NO;
//            if ([[NSFileManager defaultManager] fileExistsAtPath:imageElem.remotePath isDirectory:&isDir]) {
//                UIImage *image = [UIImage imageWithContentsOfFile:imageElem.remotePath];
//                resultSize = [self getImageSizeBySize:image.size];
//            } else {
//                resultSize = [self getImageSizeBySize:imageElem.size];
////                TIMImage *image = imageElem.imageList.lastObject;
////                resultSize = [self getImageSizeBySize:CGSizeMake(image.width, image.height)];
//            }
        }
        break;
        
        case EMMessageBodyTypeVoice:
        {//语音
            self.cellReuseIdentifier = @"MessageChatVoiceTableViewCell";
            EMVoiceMessageBody *soundElem = (EMVoiceMessageBody *)body;
            CGFloat bubbleWidth = 65 + soundElem.duration / 60.0 * 140;
            if(bubbleWidth > 200){
                bubbleWidth = 200;
            }
            resultSize = CGSizeMake(bubbleWidth, 35);
        }
        break;
            
        case EMMessageBodyTypeCmd:
        {//cmd 透传消息
            
        }
        break;
            
        case EMMessageBodyTypeCustom:
        {//自定义
            NSDictionary *dictionary = self.innerMessage.ext;
            if ([dictionary isKindOfClass:NSDictionary.class]) {
                self.cellReuseIdentifier = @"MessageChatTableViewCell";//识别不到的类型
                resultSize =  CGSizeMake(60, 15+40);
                if ([dictionary[@"message_attr_is_subject"] boolValue]) { //业务消息
                    self.cellReuseIdentifier = @"MessageChatBusinessTableViewCell";
                    EMCustomMsgModel *msgModel = [EMCustomMsgModel yy_modelWithDictionary:dictionary];
                    resultSize = CGSizeMake(225+5, msgModel.msgHeight);
                }
                if ([dictionary[@"message_attr_is_authorize"] boolValue]) { //授权消息
                    self.cellReuseIdentifier = @"MessageChatPhoneTableViewCell";
                    resultSize = CGSizeMake(225+5, 155);
                }
            } else {
                NSString *content = dictionary[@"data"];
                self.emojiUtil.richTextAttribute = [[NSMutableAttributedString alloc] initWithString:content];
                [self.emojiUtil.richTextAttribute addAttributes:@{NSFontAttributeName: kFontTheme16} range:NSMakeRange(0, content.length)];
                self.cellReuseIdentifier = @"MessageChatTextTableViewCell";//时间
                return CGSizeMake(15+25, 15+20);
           }
        }
        break;
            
        default:
        {//未知类型
            self.cellReuseIdentifier = @"MessageChatTableViewCell";//识别不到的类型
            return CGSizeMake(60, 15+40);
        }
            break;
    }
//    if (self.innerMessage.direction == EMMessageDirectionSend) {//如果是自己发的消息需要标注已读未读
//        resultSize = CGSizeMake(resultSize.width, resultSize.height+15);
//    }
    return resultSize;
}

- (CGSize)getImageSizeBySize:(CGSize)imgSize {
    CGSize realSize = imgSize;
    if (imgSize.width > imgSize.height) {
        if (imgSize.width > 150) {
            realSize = CGSizeMake(150, 150.0/imgSize.width*imgSize.height);
        }
        else if (imgSize.width > 0 && imgSize.width < 85) {
            realSize = CGSizeMake(85, 85.0/imgSize.width*imgSize.height);
        }
     }
    else {
        if (imgSize.height > 175) {
            realSize = CGSizeMake(175.0/imgSize.height*imgSize.width, 175);
        }
        else if (imgSize.height > 0 && imgSize.height < 35) {
            realSize = CGSizeMake(35.0/imgSize.height*imgSize.width, 35);
        }
    }
    return realSize;
}

@end

@implementation EMCustomMsgModel

- (CGFloat)msgHeight {
    _msgHeight = 25+115+self.contentHeight+self.subContentHeight;
    if (self.message_attr_subject_bottom.length > 0) {
        _msgHeight += 20+5;
    }
    return _msgHeight;
}

- (CGFloat)contentHeight {
    if (!_contentHeight) {
        if (self.message_attr_subject_content.length > 0) {
            _contentHeight = MAX(20, [self.message_attr_subject_content getHeightWithFont:kFontTheme14 constrainedToSize:CGSizeMake(205, CGFLOAT_MAX)]);
        }
    }
    return _contentHeight;
}

- (CGFloat)subContentHeight {
    if (!_subContentHeight) {
        if (self.message_attr_subject_sub_content.length > 0) {
            _subContentHeight = MAX(17, [self.message_attr_subject_sub_content getHeightWithFont:kFontTheme12 constrainedToSize:CGSizeMake(205, CGFLOAT_MAX)]);
        }
    }
    return _subContentHeight;
}

@end

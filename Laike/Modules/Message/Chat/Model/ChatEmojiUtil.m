//
//  ChatEmojiUtil.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/9/8.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "ChatEmojiUtil.h"

#define BEGIN_FLAG @"["
#define END_FLAG @"]"
static NSString *const checkStrEmoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5|<>,.:;'~!@#$%^&*()+{}-]+\\]";

@implementation ChatEmojiUtil

- (void)getRichTextAttributeString:(NSString *)content Font:(UIFont *)font {
    if (!_richTextAttribute) {
        [self executeMatchWithContent:content];
        _richTextAttribute = [[NSMutableAttributedString alloc] initWithString:content];
        [_richTextAttribute addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, content.length)];
        for (NSValue *value in self.matches.reverseObjectEnumerator) {
            NSRange range = value.rangeValue;
            NSString *imageName = [content substringWithRange:range];
            NSString *imageEmoji = self.emojiDic[imageName];
            EMTextAttachment *textAttachment = EMTextAttachment.new;
            textAttachment.imageName = imageName;
            textAttachment.imageEmoji = imageEmoji;
            textAttachment.image = kImageMake(imageEmoji);
            NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            if (textAttachment != nil) {
                [_richTextAttribute deleteCharactersInRange:range];
                [_richTextAttribute insertAttributedString:textAttachmentString atIndex:range.location];
            }
        }
    }
}

- (void)executeMatchWithContent:(NSString *)content {
    self.matches = NSMutableArray.array;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:checkStrEmoji options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *array = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    for (NSTextCheckingResult *result in array) {
        if ([self.emojiDic.allKeys containsObject:[content substringWithRange:result.range]]) {
            [self.matches addObject:[NSValue valueWithRange:result.range]];
        }
    }
}

//- (void)getEmojiRange:(NSString *)message {
//    NSRange range = [message rangeOfString:BEGIN_FLAG];
//    NSRange range1 = [message rangeOfString:END_FLAG];
//    //判断当前字符串是否还有表情的标志。
//    if (range.length && range1.length) {
//        NSRange specialRange = NSMakeRange(range.location, range1.location+1-range.location);
//        NSString *specialStr = [message substringWithRange:specialRange];
//        [self parseSpecialStr:specialStr Range:NSMakeRange(specialRange.location+subStringToIndex, specialRange.length)];
//        NSString *str = [message substringFromIndex:range1.location+1];
//        subStringToIndex += range1.location+1;
//        [self getEmojiRange:str];
//    }
//}
//
//- (void)parseSpecialStr:(NSString *)content Range:(NSRange)range {
//    NSString *targetStr = [content substringWithRange:NSMakeRange(1, content.length-1)];
//    NSRange specialRange = [targetStr rangeOfString:BEGIN_FLAG];
//    if (specialRange.length > 0) {
//        NSString *specialStr = [content substringFromIndex:specialRange.location+1];
//        subStringToIndex += specialRange.location+1;
//        [self parseSpecialStr:specialStr Range:NSMakeRange(range.location+specialRange.location, specialStr.length)];
//    } else {
//        if ([self.emojiDic.allKeys containsObject:content]) {
//            [self.matches addObject:[NSValue valueWithRange:range]];
//        }
//    }
//}
//
//- (NSMutableArray *)matches {
//    if (!_matches) {
//        _matches = NSMutableArray.array;
//    }
//    return _matches;
//}

- (NSDictionary *)emojiDic {
    if (!_emojiDic) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"plist"];
        _emojiDic = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _emojiDic;
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end


#define kEmotionTopMargin -3.0f

@implementation EMTextAttachment
//I want my emoticon has the same size with line's height
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0) {
    return CGRectMake( 0, kEmotionTopMargin, lineFrag.size.height, lineFrag.size.height);
}

@end

//
//  ChatEmojiUtil.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/9/8.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatEmojiUtil : NSObject {
    NSInteger subStringToIndex;
}

@property (nonatomic, strong) NSDictionary *emojiDic;
@property (nonatomic, strong) NSMutableArray *matches;
@property (nonatomic, strong) NSMutableAttributedString *richTextAttribute;

- (void)getRichTextAttributeString:(NSString *)content Font:(UIFont *)font;
//- (void)executeMatchWithContent:(NSString *)content;
//- (void)getEmojiRange:(NSString *)message;
+ (BOOL)stringContainsEmoji:(NSString *)string;

@end

@interface EMTextAttachment : NSTextAttachment

@property(nonatomic, strong) NSString *imageName;
@property(nonatomic, strong) NSString *imageEmoji;

@end

NS_ASSUME_NONNULL_END

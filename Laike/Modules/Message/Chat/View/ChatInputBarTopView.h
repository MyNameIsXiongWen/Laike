//
//  ChatInputBarTopView.h
//  XuanWoJia
//
//  Created by jason on 2019/9/27.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ChatInputBarTopView;
@protocol ChatInputBarTopViewDelegate <NSObject>

- (void)inputBarTopView_didClickTopView:(ChatInputBarTopView *)topView didSelectTopCell:(NSString *)cellIdentifier;

@end

@interface ChatInputBarTopView : UIView

@property (nonatomic, weak) id <ChatInputBarTopViewDelegate>delegate;
@property (nonatomic, strong) UICollectionView *moreCollectionView;

@property (nonatomic, assign) BOOL commonWordBtnSelected;

@end

@interface ChatInputBarTopViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, assign) BOOL cellSelected;

@end

NS_ASSUME_NONNULL_END

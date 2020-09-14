//
//  ChatMoreView.h
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ChatMoreView;
@class ChatMoreViewCell;
@protocol ChatMoreViewDelegate <NSObject>
- (void)moreView:(ChatMoreView *)moreView didSelectMoreCell:(NSString *)cellIdentifier;
@end

@interface ChatMoreView : UIView

@property (nonatomic, strong) UICollectionView *moreCollectionView;
@property (nonatomic, weak) id<ChatMoreViewDelegate> delegate;

@end

@interface ChatMoreViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titlaLabel;

@end

NS_ASSUME_NONNULL_END

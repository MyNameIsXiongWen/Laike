//
//  ChatGifView.h
//  XuanWoJia
//
//  Created by jason on 2019/8/12.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZFaceModel.h"
#import "QHWImageViewCell.h"
//#import "HouseDetailPageControl.h"

NS_ASSUME_NONNULL_BEGIN

@class ChatGifView;
@protocol ChatGifViewDelegate <NSObject>
- (void)gifView:(ChatGifView *)gifView didSelectGif:(LZFaceImgModel *)faceModel;
@end

@class ChatGifMenuView;
@interface ChatGifView : UIView

@property (nonatomic, strong) UICollectionView *gifCollectionView;
//@property (nonatomic, strong) HouseDetailPageControl *pageControl;
@property (nonatomic, strong) ChatGifMenuView *menuView;
@property (nonatomic, weak) id <ChatGifViewDelegate>delegate;

@end

@class ChatGifMenuCell;
@interface ChatGifMenuView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, copy) void (^ selectFaceBlock)(NSInteger index);

@end

@interface ChatGifMenuCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *menuImgView;

@end

NS_ASSUME_NONNULL_END

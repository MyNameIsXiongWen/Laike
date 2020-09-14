//
//  ChatFaceView.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/9/8.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZFaceModel.h"

NS_ASSUME_NONNULL_BEGIN
@class ChatFaceView;
@protocol ChatFaceViewDelegate <NSObject>
- (void)faceView:(ChatFaceView *)gifView didSelectFace:(LZFaceImgModel *)faceModel;
- (void)faceViewClickSend;
- (void)faceViewClickDelete;
@end

@interface ChatFaceView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id <ChatFaceViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

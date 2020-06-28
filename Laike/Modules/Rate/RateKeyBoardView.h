//
//  RateKeyBoardView.h
//  Laike
//
//  Created by xiaobu on 2020/6/28.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KeyBoardRightView;
@interface RateKeyBoardView : UIView

@property (nonatomic, copy) void (^ clickKeyBoardBlock)(NSString *title);
@property (nonatomic, strong, readonly) KeyBoardRightView *rightView;

@end

@interface KeyBoardCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@interface KeyBoardRightView : UIView

@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, copy) void (^ clickClearBlock)(void);
@property (nonatomic, copy) void (^ clickDeleteBlock)(void);

@end

NS_ASSUME_NONNULL_END

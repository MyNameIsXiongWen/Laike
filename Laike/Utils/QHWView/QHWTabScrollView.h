//
//  QHWTabScrollView.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/13.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ItemWidthTypeFixed, //view固定宽度 按钮固定宽度（例如：一行显示2个按钮，2个就是各一半宽度）
    ItemWidthTypeFixedAdaptive, //view固定宽度 按钮自适应宽度
    ItemWidthTypeAdaptive, //按钮自适应宽度 view宽度根据按钮宽度来
} ItemWidthType;

@interface QHWTabScrollView : UIScrollView

@property (nonatomic, assign) ItemWidthType itemWidthType;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong, readonly) NSMutableArray *tagBtnArray;
/**
 tab之间的间隔，可不传，默认10
 */
@property (nonatomic, assign) CGFloat itemSpace;

/**
 未选中item颜色，可不传，默认kColorThemefff
 */
@property (nonatomic, strong) UIColor *itemSelectedColor;

/**
 未选中item颜色，可不传，默认和选中颜色一样
 */
@property (nonatomic, strong) UIColor *itemUnselectedColor;

/**
 label两边间距可不传，默认26，传进来的值是已经*2的了
 */
@property (nonatomic, assign) CGFloat labelSpace;
/**
选中item背景颜色，可不传，默认和选中颜色一样
*/
@property (nonatomic, strong) UIColor *itemSelectedBackgroundColor;

/**
未选中item背景颜色，可不传，默认和选中颜色一样
*/
@property (nonatomic, strong) UIColor *itemUnselectedBackgroundColor;
@property (nonatomic, strong) UIColor *tagIndicatorColor;
/**
 是否隐藏小红条 默认YES
 */
@property (nonatomic, assign) BOOL hideIndicatorView;
/**
 滑动的时候是否做动画   默认YES
 */
@property (nonatomic, assign) BOOL scrollAnimate;
///当前索引
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, assign) CGFloat btnCornerRadius;
/**
 滑动到指定索引

 @param index 索引
 */
- (void)scrollToIndex:(NSInteger)index;
@property (nonatomic, copy) void (^ clickTagBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END

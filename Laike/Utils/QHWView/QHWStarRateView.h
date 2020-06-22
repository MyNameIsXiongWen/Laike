//
//  QHWStarRateView.h
//  Guider
//
//  Created by manku on 2019/9/3.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol StarRateViewDelegate <NSObject>
@optional
- (void)scroePercentDidChange:(CGFloat)newScorePercent;
@end

@interface QHWStarRateView : UIView
@property (nonatomic, assign) BOOL allowIncompleteStar;//评分时是否允许不是整星，默认为NO
@property (nonatomic, assign) BOOL hasAnimation;//是否允许动画，默认为NO
@property (nonatomic, assign) BOOL canTap;//是否允许点击，默认为NO
@property (nonatomic, assign) CGFloat scorePercent;//得分值，范围为0--5，默认为5

@property (nonatomic, weak) id<StarRateViewDelegate>delegate;

/**
 初始化星星

 @param frame frame
 @param numberOfStars 星星数量
 @param backStarImage 星星图片 只有线条的橘色星星或者灰色星星
 @param foreStarImage 星星图片 填充的橘色星星或者灰色星星
 @param spaceWidth 星星之间的间隙
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars backStarImage:(NSString *)backStarImage foreStarImage:(NSString *)foreStarImage spaceWidth:(CGFloat)spaceWidth;

@end

NS_ASSUME_NONNULL_END

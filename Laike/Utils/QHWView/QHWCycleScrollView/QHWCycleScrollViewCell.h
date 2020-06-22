//
//  QHWCycleScrollViewCell.h
//  QHWCycleScrollView
//
//  Created by cheyr on 2019/2/27.
//  Copyright © 2018年 cheyr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHWCycleScrollViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) CGFloat imgCornerRadius;
@property (nonatomic, strong) UIImageView *playImageView;//播放按钮
 
@end

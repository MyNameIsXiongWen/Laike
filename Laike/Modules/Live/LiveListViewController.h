//
//  LiveListViewController.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/6/11.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveListViewController : UIViewController

@end

@interface LiveCollectionVieCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *liveCountLabel;

@end

NS_ASSUME_NONNULL_END

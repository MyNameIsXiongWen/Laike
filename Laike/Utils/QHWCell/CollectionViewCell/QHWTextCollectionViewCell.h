//
//  QHWTextCollectionViewCell.h
//  GoOverSeas
//
//  Created by xiaobu on 2019/7/18.
//  Copyright © 2019 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QHWTextCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) CGFloat contentViewCornerRadius;
@property (nonatomic, copy) NSString *titleText;
@end

NS_ASSUME_NONNULL_END

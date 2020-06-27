//
//  PublishImgViewCell.h
//  GoOverSeas
//
//  Created by zhaoxiafei on 2019/3/19.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface PublishImgViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UIButton *button;

@property(nonatomic,copy)void(^closeAction)(void);
@end

NS_ASSUME_NONNULL_END

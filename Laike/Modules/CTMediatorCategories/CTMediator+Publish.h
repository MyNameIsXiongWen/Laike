//
//  CTMediator+Publish.h
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/9.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (Publish)

- (void)CTMediator_viewControllerForPublishViewController;

- (UICollectionViewCell *)CTMediator_collectionViewCellWithIndexPath:(NSIndexPath *)indexPath CollectionView:(UICollectionView *)collectionView ImageArray:(NSMutableArray *)imageArray ShowPlayImgView:(BOOL)showPlayImgView ResultBlk:(void (^)(void))blk;

@end

NS_ASSUME_NONNULL_END

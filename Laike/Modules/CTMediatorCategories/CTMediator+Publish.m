//
//  CTMediator+Publish.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/9.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "CTMediator+Publish.h"

NSString * const kCTMediatorTargetPublish = @"Publish";

NSString * const kCTMediatorActionNativePublishSuccessViewController = @"nativePublishSuccessViewController";
NSString * const kCTMediatorActionNativePublishImageCell = @"nativePublishImageCell";

@implementation CTMediator (Publish)

- (void)CTMediator_viewControllerForPublishViewController {
    [self performTarget:kCTMediatorTargetPublish
                 action:kCTMediatorActionNativePublishSuccessViewController
                 params:@{}
        shouldCacheTarget:NO];
}

- (UICollectionViewCell *)CTMediator_collectionViewCellWithIndexPath:(NSIndexPath *)indexPath CollectionView:(UICollectionView *)collectionView ImageArray:(NSMutableArray *)imageArray ShowPlayImgView:(BOOL)showPlayImgView ResultBlk:(void (^)(void))blk {
    UICollectionViewCell *cell = [self performTarget:kCTMediatorTargetPublish
                                              action:kCTMediatorActionNativePublishImageCell
                                              params:@{@"indexPath": indexPath,
                                                       @"collectionView": collectionView,
                                                       @"imageArray": imageArray,
                                                       @"showPlayImgView": @(showPlayImgView),
                                                       @"block": blk}
                                   shouldCacheTarget:YES];
    if ([cell isKindOfClass:UICollectionViewCell.class]) {
        return cell;
    } else {
        return UICollectionViewCell.new;
    }
}

@end

//
//  Target_Publish.m
//  GoOverSeas
//
//  Created by xiaobu on 2020/5/9.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import "Target_Publish.h"
//#import "PublishImgViewCell.h"
//#import "PublishSuccessViewController.h"
#import "QHWImageModel.h"

@implementation Target_Publish

- (void)Action_nativePublishSuccessViewController:(NSDictionary *)params {
//    PublishSuccessViewController *vc = PublishSuccessViewController.new;
//    [self.getCurrentMethodCallerVC.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewCell *)Action_nativePublishImageCell:(NSDictionary *)params {
//    UICollectionView *collectionView = params[@"collectionView"];
//    NSIndexPath *indexPath = params[@"indexPath"];
//    NSMutableArray *imageArray = params[@"imageArray"];
//    void (^blk)(void) = params[@"block"];
//    PublishImgViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PublishImgViewCell.class) forIndexPath:indexPath];
//    cell.closeAction = blk;
//    if (imageArray.count < kPublishImgCount) {
//        if (indexPath.row == imageArray.count) {
//            cell.button.hidden = YES;
//            cell.bgImageView.image = [UIImage imageNamed:@"publish_add"];
//        } else {
//            QHWImageModel *model = imageArray[indexPath.row];
//            cell.bgImageView.image = model.image;
//            cell.button.hidden = NO;
//        }
//        return cell;
//    } else {
//        QHWImageModel *model = imageArray[indexPath.row];
//        cell.bgImageView.image = model.image;
//        cell.button.hidden = NO;
//    }
//    return cell;
    return UICollectionViewCell.new;
}

@end

//
//  CRMBtnCollectionViewCell.h
//  ManKu_Merchant
//
//  Created by jason on 2019/1/18.
//  Copyright © 2019年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRMBtnCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (nonatomic, assign) BOOL itemSelected;

@end

NS_ASSUME_NONNULL_END

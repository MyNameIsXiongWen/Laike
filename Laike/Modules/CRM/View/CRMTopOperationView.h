//
//  CRMTopOperationView.h
//  Laike
//
//  Created by xiaobu on 2020/6/23.
//  Copyright © 2020 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRMTopOperationView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@end

@interface OperationCollectionSubView : UIView

@property (nonatomic, strong) UIImageView *logoImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

NS_ASSUME_NONNULL_END
